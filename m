Return-Path: <linux-kernel-owner+w=401wt.eu-S1754651AbYGOEqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651AbYGOEqe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 00:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752320AbYGOEq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 00:46:26 -0400
Received: from 1wt.eu ([62.212.114.60]:3963 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752241AbYGOEq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 00:46:26 -0400
Date: Tue, 15 Jul 2008 06:45:21 +0200
From: Willy Tarreau <w@1wt.eu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: David Miller <davem@davemloft.net>, jeff@garzik.org, david@lang.hm,
       arjan@infradead.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel, use it in more drivers.
Message-ID: <20080715044521.GF1369@1wt.eu>
References: <alpine.DEB.1.10.0807141704120.14223@asgard.lang.hm> <1216082213.27455.109.camel@shinybook.infradead.org> <487C0788.7030907@garzik.org> <20080714.191727.223788995.davem@davemloft.net> <1216088636.27455.163.camel@shinybook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216088636.27455.163.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

just noticed this thread which frightens me...

On Mon, Jul 14, 2008 at 07:23:55PM -0700, David Woodhouse wrote:
> In all the years we've been using request_firmware(), nobody ever asked
> for a way to build the firmware _into_ the .ko file, until now. Why is
> it suddenly so important for a small handful of older network drivers,
> when nobody else has ever seen the need for it -- even in modern network
> drivers?

Because most often, you need to bring the network driver from any location
to your machine by any method *before* you can transfer anything easily.
It's already painful to have to load modules from userland, please do not
complicate the installation process. I can assure you that it's painful
to boot a system and see that neither network nor USB work. When you
find a way to pass a network driver there through any method (included
writing it onto a CD), you're finally safe. If now you have to iterate
because once you modprobe, you notice that *some* firmware files are
missing, it'll get really really annoying.

You say that it is suddenly important, but I disagree. The only network
driver I have which needs a firmware is myri10ge. And guess what ? Getting
it to work on test platforms was a real hassle. Upon modprobe, the system
would wait 2 minutes (I never understood why we have to wait when a file
is missing, but that's another story of crappy design). From the first
second, I could think "oh sh*t, the firmware again...". The I had to get
the firmware files, hotplug script and also the script to configure /proc
and /sys entries just to be able to load this driver. Fortunately, I could
transfer these files via the other NIC which did not require a firmware to
be loaded.

It was so much hard to get it to work on test platforms that I finally
found how to rebuild the myri10ge driver with the firmware included in
it, and now it has changed my life. Simply modprobe and that's all.
Firmwares are so much annoying that I think that those should just be
optional, and be built into modules *by default*. There should be a
really valid reason for wanting to extract them. Upgradability is not
one, because there are more frequent changes in modules than in firmwares.

Just my 2 cents,
Willy

