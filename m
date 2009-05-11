Return-Path: <linux-kernel-owner+w=401wt.eu-S1753027AbZEKD40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027AbZEKD40 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 23:56:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751801AbZEKD4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 23:56:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:53514 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbZEKD4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 23:56:16 -0400
Date: Sun, 10 May 2009 20:55:58 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Peter Zijlstra <peterz@infradead.org>,
       Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Fabio Comolli <fabio.comolli@gmail.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch 00/13] devtmpfs patches
Message-ID: <20090510205558.7117182a@infradead.org>
In-Reply-To: <ac3eb2510905101822t7fde14b3nf2c689621f69c925@mail.gmail.com>
References: <20090509143742.GA27663@kroah.com>
	<20090509150853.GA32394@suse.de>
	<20090509082233.32cbb8e4@infradead.org>
	<20090509161923.GA942@suse.de>
	<20090509223454.4642753d.akpm@linux-foundation.org>
	<20090510152005.GA9461@suse.de>
	<1241980263.9562.380.camel@laptop>
	<20090510221901.30c1c5a5@lxorguk.ukuu.org.uk>
	<ac3eb2510905101647k12a1b9ck71d43933037bac48@mail.gmail.com>
	<20090510170016.1e3a4d97@infradead.org>
	<ac3eb2510905101822t7fde14b3nf2c689621f69c925@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 May 2009 03:22:53 +0200
Kay Sievers <kay.sievers@vrfy.org> wrote:

> On Mon, May 11, 2009 at 02:00, Arjan van de Ven <arjan@infradead.org>
> wrote:
> > (and it seems to be irrelevant to the devtmpfs discussion anyway
> > since Eric Biederman has shown that pulling the device numbers out
> > of sysfs is basically free... even though it'd be nice to give that
> > some help to make it a nice index)
> 
> It's not free, and it's racy to just copy over the stuff. You have to
> subscribe to events _before_ you start reading /sys and create nodes,
> to catch the new stuff that comes in in the meantime. You have to
> mount an empty tmpfs, bring up a udevd-like process to subscribe to
> events for new devices and create nodes for them, create the nodes for
> the already existing devices found in /sys. That's all far from
> "free", and has non-trivial dependencies.
> 

How about we do something that is useful for more scenarios instead,
like proposed already? A /proc or similar file that just lists the
type,major,minor and name for the known nodes.
This has none of the race issues you mention (since udev still later
processes the events) but opens a LOT of flexibility. You could use it
in your set up, but I could use it in the Moblin setup as well.
And I suspect many other setups suddenly become possible, just because
there now is a lost of device nodes that are "active". Debugging
drivers, etc etc. Long list.

I sort of get a bad taste in my mouth from this thread to be honest;
it really feels like "this is the code that HAS to be pushed", rather
than working on getting something useful for a wide set of uses... even
if it's not your initial implementation. 

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
