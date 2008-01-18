Return-Path: <linux-kernel-owner+w=401wt.eu-S1755175AbYARIRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175AbYARIRS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 03:17:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751189AbYARIRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 03:17:06 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:31877 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbYARIRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 03:17:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=NgpVBMRjpsJNbK+wJDBtvpFVIQ1cwuNHJdq2loUETvsI06+Y9ezSSHMCBh/I2KjhFMOWU1jao8ZUjODHvg0MMx9JpJkbhvrD0MZVGK1YCgH77/1SVSejR1YwHq5iPlp6+XAFiA4vur11PE9uqqXsTMiwCyCzEiiuTizT7PeoUTU=
Date: Fri, 18 Jan 2008 09:23:27 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Alan Stern <stern@rowland.harvard.edu>,
       Greg KH <gregkh@suse.de>, stefanr@s5r6.in-berlin.de,
       David Brownell <david-b@pacbell.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/7] driver-core : convert semaphore to mutex in struct
	class
Message-ID: <20080118082327.GC1703@ff.dom.local>
References: <Pine.LNX.4.44L0.0801171448590.5731-100000@iolanthe.rowland.org> <20080117203155.GA2791@ami.dom.local> <20080117232626.GC2905@ami.dom.local> <a8e1da0801171742o5520c3d9v577979f527f1a977@mail.gmail.com> <3ae72650801171755k85c4245i3b4c46a84ae8f52d@mail.gmail.com> <a8e1da0801171828n26b37be0oa8b1c3cbec5f83cb@mail.gmail.com> <1200626323.5640.21.camel@lov.site> <a8e1da0801172131h57097622h6d111133b6a0773d@mail.gmail.com> <20080118073836.GA1703@ff.dom.local> <a8e1da0801172348q575d6c2fs9f51e3e76d41c62@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8e1da0801172348q575d6c2fs9f51e3e76d41c62@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2008 at 03:48:02PM +0800, Dave Young wrote:
> On Jan 18, 2008 3:38 PM, Jarek Poplawski <jarkao2@gmail.com> wrote:
...
> > IMHO, it would be nice to get the real state of current lockdep
> > problems here to figure out if there is any chance to do this right &
> > without any warnings with current lockdep. If I got it right from
> > earlier threads it might be impossible with USB, at least.
> 
> I don't think so, usb doesn't be affected by struct class mutex, they
> only use the lock of struct device. As I replied before, the lockdep
> issue exist only between class_interface and class_device.

OK, but I've meant possibility of changing their own semaphores later.

> > So, since I think these nesting levels seem to be wrong in 7/7 patch,
> > maybe it's better to exclude it from this patchset, and to try this as
> > testing for some time.
> 
> I may file the updated patch with more nesting changes and test it of
> course. Actually I should have done it, thanks.
...
> 1) Using CLASS_NORMAL/CLASS_PARENT/CLASS_CHILD will be enough.
> or
> 2) Simply add SINGLE_LEVEL_NESTING in class_device_add and other
> class_device functions because it is the only possible nest-lock place
> as I know.

If SINGLE_LEVEL_NESTING is enough? (means 2 levels total)

I think you should more care about real (logical) relations here, than
what's enough to get rid of lockdep warnings.

Since there are not so much of these changes, you can try both
variants. I'll be glad to look at this - maybe I'll mangage to figure
out BTW, what it's all about...

Jarek P.
