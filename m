Return-Path: <linux-kernel-owner+w=401wt.eu-S1752442AbYLCJbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442AbYLCJbS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 04:31:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750876AbYLCJbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 04:31:08 -0500
Received: from mx2.redhat.com ([66.187.237.31]:49100 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755AbYLCJbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 04:31:07 -0500
Message-ID: <493651C4.50705@redhat.com>
Date: Wed, 03 Dec 2008 10:30:44 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: "J.R. Mauro" <jrm8005@gmail.com>
CC: Christoph Bartelmus <lirc@bartelmus.de>, pavel@suse.cz, jonsmirl@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: In-kernel IR remote control support
References: <AqQThtpZjFB@christoph> <4935B00D.5010302@redhat.com> <3aaafc130812021659x36701b19vc0d22f3c38471b65@mail.gmail.com>
In-Reply-To: <3aaafc130812021659x36701b19vc0d22f3c38471b65@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

>> The only way to get out of this situation long-term is to get advanced
>> IR support into the mainline kernel.
> 
> We at least need a unified place for drivers, or unified support for
> those drivers that must be put in userspace, a la usbfs and libusb.

That isn't good enougth.  That unified place must be mainline (for the
kernel stuff).  Userland bits can continue to live in the lirc package,
that isn't a problem.

>> It is certainly a good thing to have only *one* way to handle IR
>> remotes.  But the kernel side of that way *must* be in mainline.
>> Everything else simply isn't going to fly.
> 
> One way or a hybrid way to address everyone's concerns. I don't see
> why this has to be ALL kernel or ALL userspace.

It hasn't to be all kernel or all userspace.
But all kernel bits must be in mainline.

> I would think it could
> be both and still be clean.

Sure.  We can even support both ways in the very same driver.  I'll grab
a piece of hardware I know of as example: cx88-based TV cards:

 * The hardware gives you the raw IR samples.
 * The kernel takes them, decodes them and sends the input layer way
   to user.  The remote bundled with the TV card works fine.  Which
   is what probably 95% of the users need.
 * In theory you can decode *any* remote IR codes.  In practice you
   can't because there is no way to get the raw IR samples to userspace
   where lircd can handle them.

Ok, what are the options to fix the latter?

 * lirc would do the trick.  Doesn't fly though due to cx88 being
   mainline and lirc (kernel drivers) being out-of-tree.
 * input layer extension for raw IR codes.  Doesn't exist (yet?).
 * something completely different ...

Then you can have cx88 register both within the input layer (for the
bundled remote) and in the new raw-ir-codes subsystem.  Someone (say
lircd) opening the raw IR interface will make the in-kernel decoding
stop.  You are done ;)

cheers,
  Gerd
