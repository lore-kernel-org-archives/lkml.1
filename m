Return-Path: <linux-kernel-owner+w=401wt.eu-S1758567AbYARJIC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758567AbYARJIC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 04:08:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753141AbYARJHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 04:07:45 -0500
Received: from hs-out-0708.google.com ([64.233.178.243]:11097 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758185AbYARJHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 04:07:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=IMf1T3ZEHoPxOvl/R80f4ABclaHWtob49y1mHRaJU6/68jDaFIRGdW8p79Cve4uEZAt+iN21j4dHejTKzObjFp1fR6P0mmlsmZKYWEKkx53ZO7OAGAy55CHt+qlLtT4LNC4hFLPeTHsqmxFjk+C0rBEofBQeQHBUXuEyTZBkcTA=
Message-ID: <a8e1da0801180107w2d5a4be2r2b30d57a0d2b85ce@mail.gmail.com>
Date: Fri, 18 Jan 2008 17:07:40 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Jarek Poplawski" <jarkao2@gmail.com>
Subject: Re: [PATCH 7/7] driver-core : convert semaphore to mutex in struct class
Cc: "Kay Sievers" <kay.sievers@vrfy.org>,
       "Alan Stern" <stern@rowland.harvard.edu>, "Greg KH" <gregkh@suse.de>,
       stefanr@s5r6.in-berlin.de, "David Brownell" <david-b@pacbell.net>,
       "Kernel development list" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080118082327.GC1703@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.44L0.0801171448590.5731-100000@iolanthe.rowland.org>
	 <20080117232626.GC2905@ami.dom.local>
	 <a8e1da0801171742o5520c3d9v577979f527f1a977@mail.gmail.com>
	 <3ae72650801171755k85c4245i3b4c46a84ae8f52d@mail.gmail.com>
	 <a8e1da0801171828n26b37be0oa8b1c3cbec5f83cb@mail.gmail.com>
	 <1200626323.5640.21.camel@lov.site>
	 <a8e1da0801172131h57097622h6d111133b6a0773d@mail.gmail.com>
	 <20080118073836.GA1703@ff.dom.local>
	 <a8e1da0801172348q575d6c2fs9f51e3e76d41c62@mail.gmail.com>
	 <20080118082327.GC1703@ff.dom.local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 18, 2008 4:23 PM, Jarek Poplawski <jarkao2@gmail.com> wrote:
> On Fri, Jan 18, 2008 at 03:48:02PM +0800, Dave Young wrote:
> > On Jan 18, 2008 3:38 PM, Jarek Poplawski <jarkao2@gmail.com> wrote:
> ...
> > > IMHO, it would be nice to get the real state of current lockdep
> > > problems here to figure out if there is any chance to do this right &
> > > without any warnings with current lockdep. If I got it right from
> > > earlier threads it might be impossible with USB, at least.
> >
> > I don't think so, usb doesn't be affected by struct class mutex, they
> > only use the lock of struct device. As I replied before, the lockdep
> > issue exist only between class_interface and class_device.
>
> OK, but I've meant possibility of changing their own semaphores later.
>
> > > So, since I think these nesting levels seem to be wrong in 7/7 patch,
> > > maybe it's better to exclude it from this patchset, and to try this as
> > > testing for some time.
> >
> > I may file the updated patch with more nesting changes and test it of
> > course. Actually I should have done it, thanks.
> ...
> > 1) Using CLASS_NORMAL/CLASS_PARENT/CLASS_CHILD will be enough.
> > or
> > 2) Simply add SINGLE_LEVEL_NESTING in class_device_add and other
> > class_device functions because it is the only possible nest-lock place
> > as I know.
>
> If SINGLE_LEVEL_NESTING is enough? (means 2 levels total)

I think so.

>
> I think you should more care about real (logical) relations here, than
> what's enough to get rid of lockdep warnings.

You are quite right, thanks.

>
> Since there are not so much of these changes, you can try both
> variants.

Will do.

>I'll be glad to look at this - maybe I'll mangage to figure
> out BTW, what it's all about...
>
> Jarek P.
>
