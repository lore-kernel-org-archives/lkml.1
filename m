Return-Path: <linux-kernel-owner+w=401wt.eu-S1756106AbYH1SGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106AbYH1SGt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 14:06:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753487AbYH1SGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 14:06:41 -0400
Received: from nn7.de ([85.214.94.156]:49402 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138AbYH1SGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 14:06:40 -0400
Subject: Re: converting appletouch to usb autosuspend again...
From: Soeren Sonnenburg <kernel@nn7.de>
To: Oliver Neukum <oliver@neukum.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Jiri Kosina <jikos@jikos.cz>
In-Reply-To: <200808242039.48701.oliver@neukum.org>
References: <1219525218.8221.31.camel@localhost>
	 <200808242039.48701.oliver@neukum.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 28 Aug 2008 15:41:11 +0000
Message-Id: <1219938071.9717.59.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-08-24 at 20:39 +0200, Oliver Neukum wrote:
> Am Samstag 23 August 2008 23:00:18 schrieb Soeren Sonnenburg:
> > Dear all,
> > 
> > I wonder whether anyone else tried to get appletouch usb autosuspend to
> > work. I've seen Oliver's patch but as it kept oopsing on me and I
> 
> You might post the oops. I haven't seen it.

Do you have an updated version of your patch that applies to
git-current? I will give your patch another try then.

> > couldn't parse the usb_mark_last_busy logic I came up with the attached
> > patch against (current git; at least didn't oops for me over the last
> > several days and suspend/resume cycles).
> > 
> > However things I don't understand, 
> > 
> > a) is autosuspend on the appletouch driver used at all (how can I find
> > out)
> 
> Compile your kernel with CONFIG_USB_DEBUG and autosuspend will be logged.
> You need to activate autosuspend via sysfs.

OK, indeed it never autosuspends... I guess this is this due to the
keyboard and the mice being on the same usb port and as the kbd part
does not support autosuspend it never suspends?!

> > b) do I need dev->intf->needs_remote_wakeup = 1; ?
> 
> Yes.
> 
> > c) is line 33 in the patch safe to do ?
> 
> Why do you want to add it?

Well reaching this line the touchpad is idling (hasn't been touched+no
button was pressed) - I somehow wanted to force it to suspend in this
case.

> > And while we are at it I am still seeing these X falls back to hid mouse
> > mode, only switching to console and back resolves this (looks like this
> > only worked in previous kernels as resume from s2ram took a lot longer
> > due to the IDE driver doing a couple of resets) - is there anything one
> > could do about it?
> 
> Post a log.

My fault. I was still rmmod'ing appletouch before suspending. It works
perfectly + reliably the way it is.

Thanks,
Soeren
