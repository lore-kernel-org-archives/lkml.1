Return-Path: <linux-kernel-owner+w=401wt.eu-S1764284AbYJJUpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764284AbYJJUpY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 16:45:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764163AbYJJUo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 16:44:56 -0400
Received: from kroah.org ([198.145.64.141]:55115 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764157AbYJJUoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 16:44:55 -0400
Date: Fri, 10 Oct 2008 13:41:12 -0700
From: Greg KH <greg@kroah.com>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [stable] [PATCH] x86: Reserve FIRST_DEVICE_VECTOR in
	used_vectors bitmap
Message-ID: <20081010204112.GA32357@kroah.com>
References: <48EFB4B2.2020508@canonical.com> <20081010201610.GA32164@kroah.com> <20081010202350.GA11090@elte.hu> <20081010202915.GA32318@kroah.com> <48EFBCBB.6050104@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48EFBCBB.6050104@canonical.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2008 at 04:36:11PM -0400, Stefan Bader wrote:
> Greg KH wrote:
> > On Fri, Oct 10, 2008 at 10:23:50PM +0200, Ingo Molnar wrote:
> >> * Greg KH <greg@kroah.com> wrote:
> >>
> >>> On Fri, Oct 10, 2008 at 04:01:54PM -0400, Stefan Bader wrote:
> >>>> Affected: 2.6.24-2.6.27
> >>>>
> >>>> Someone from the community found out, that after repeatedly unloading and
> >>>> loading a device driver that uses MSI IRQs, the system eventually assigned
> >>>> the vector initially reserved for IRQ0 to the device driver.
> >>>>
> >>>> The reason for this is, that although IRQ0 is tied to the FIRST_DEVICE_VECTOR
> >>>> when declaring the irq_vector table, the corresponding bit in the used_vectors
> >>>> map is not set. So, if vectors are released and assigned often enough, the
> >>>> vector will get assigned to another interrupt. This happens more often with
> >>>> MSI interrupts as those are exclusively using a vector.
> >>>>
> >>>> Fix this by setting the bit for the FIRST_DEVICE_VECTOR in the bitmap.
> >>>>
> >>>> Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
> >>> Hint, if you want patches to go into the -stable tree, just add:
> >>> 	cc: Stable <stable@kernel.org>
> >>> to the patch when you submit it in the signed-off-by area, and it will
> >>> be automatically sent to us when it goes into the main kernel tree.
> >> yes. Note that this is a special case, as there will be no upstream 
> >> commit to tag with Cc: <stable@kernel.org>, because this bug got 
> >> eliminated via not backportable means: APIC code unification.
> >>
> >> Acked-by: Ingo Molnar <mingo@elte.hu>
> > 
> > So this is a -stable release only patch?  .28 will never get/need this?
> > 
> > thanks,
> > 
> > greg k-h
> 
> Correct. Tried to hint this by the Affected line but should have been more verbose.

Great, thanks for letting me know, I'll queue it up for -stable.

Oh, next time, please don't attach patches in base64 format, that's a
pain in the ass...

thanks,

greg k-h
