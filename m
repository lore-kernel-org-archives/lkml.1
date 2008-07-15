Return-Path: <linux-kernel-owner+w=401wt.eu-S1755340AbYGOJ5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340AbYGOJ5V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 05:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754289AbYGOJ5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 05:57:13 -0400
Received: from senator.holtmann.net ([87.106.208.187]:40742 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324AbYGOJ5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 05:57:12 -0400
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
	in-kernel, use it in more drivers.
From: Marcel Holtmann <marcel@holtmann.org>
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, dwmw2@infradead.org,
       torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, jgarzik@pobox.com, mchan@broadcom.com
In-Reply-To: <20080714.184418.203308475.davem@davemloft.net>
References: <1216077806.27455.85.camel@shinybook.infradead.org>
	 <20080714164119.99c33d5b.akpm@linux-foundation.org>
	 <20080714.184418.203308475.davem@davemloft.net>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 11:57:18 +0200
Message-Id: <1216115838.27242.54.camel@violet.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

> I'm not happy for network drivers, although I'm happy to see that
> David respected out NACKs on tg3/bnx2/etc. and didn't include those
> bits.
> 
> I still haven't seen an answer to the chip reset issues.  The argument
> has been that this stuff is going to save kernel memory when the
> driver isn't loading firmware, but that's not really possible.
> 
> When a lot of these network drivers reset, due to a transmit timeout
> or other exception, we need to load the firmware again.
> 
> So this means, that if request_firmware() dies or fails for some
> reason in these scenerios, we can't reset the network card.  Something
> as simple as a memory or other allocation failure deep inside of
> request_firmware() means we lose the networking interface.
> 
> To me this seems like a very non-resilient setup.  It makes sense
> to just keep the firmware in-core so we can load it without having
> to even think about possible failures.

actually when we wrote request_firmware() a long time ago, the idea was
to support various kind of setups (although until now only the on-demand
got used).

So one idea was to allow minimal inclusion of firmware as binary blobs
in the driver and allow overwriting them by loading newer version from
the filesystem. This was intended to ensure minimal working drivers. The
main background was that some devices work with a small firmware and
provide basic features and only need extra firmware for advanced
features. Everything suppose to be hidden behind request_firmware() and
a method to register binary blobs as firmware from within a driver. So
the driver developer really doesn't have to invent anything by himself.

We are not there yet and at the moment, I am not sure if this is still a
valid requirement, but David's work goes into the right direction and is
a good start.

Regards

Marcel


