Return-Path: <linux-kernel-owner+w=401wt.eu-S1758671AbXLaJ3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758671AbXLaJ3U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 04:29:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754416AbXLaJ3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 04:29:13 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:33271 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987AbXLaJ3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 04:29:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Fx0QR+dd3Q9UvokcZjsD8mVH3317NZB7DBucIeV9rmG+CL+sDm5U0/uIQtrfXsFIl4hLgr+3xRzMVJ1LSimRlIxUOc0ehFJcFrSZZ3Wf70WF5Hk9sHti0dOVFlIPLjfvgtZjETh4fu7U1wh6C6l7t9EViEu4IPo2bQ7ag+PpDNE=
Message-ID: <64bb37e0712310129s5b03b490wc1a8a4f9ec9da529@mail.gmail.com>
Date: Mon, 31 Dec 2007 10:29:10 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] Hibernation: Document __save_processor_state() on x86-64
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "pm list" <linux-pm@lists.linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Len Brown" <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       "Pavel Machek" <pavel@suse.cz>
In-Reply-To: <20071230215745.GB31386@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200712281353.37976.rjw@sisk.pl> <200712302248.03567.rjw@sisk.pl>
	 <20071230213126.GB14654@elte.hu> <200712302308.51562.rjw@sisk.pl>
	 <20071230215745.GB31386@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 30, 2007 10:57 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> > > what's exactly in the hibernation image? Dirty data i suppose
> >
> > No, everything, including the kernel code, page tables etc. :-)
> >
> > > - but what about kernel-internal pages. What if we go from SLAB to
> > > SLUB? What if the size of a structure changes? Etc.
> >
> > We can go from SLAB to SLUB just fine, it doesn't matter.  The only
> > thing that matters is we have to jump to the right address at the end
> > of core_restore_code() (defined in arch/x86/kernel/suspend_asm_64.S).
>
> ok, just to make sure we are talking about the same thing. Do you mean
> we can restore an image saved by v2.6.12 into v2.6.24? I.e. a 2.6.24
> kernel will be able to run a 2.6.12 kernel's hibernation image, with all
> the kernel internal data from v2.6.12, etc? No way can that work.

I suspect here is a slight misunderstanding: It will never be possible
to switch a kernel with a hibernation/resume cycle.
The new thing is, that you can use a 2.6.24-SLUB-kernel to load a
2.6.12-SLAB-kernel(*) and then have the *2.6.12* kernel continue to
run.

The jump that Rafael talks about is a complete switchover from the
kernel doing the resume to the old kernel (and all of its data
structures) from the hibernation image. The now again running old
kernel will discard any internal data from the resuming kernel and so
it is not important if there was a SLAB vs SLUB difference.

In some way you could see the kernel loading the image as a gigantic
bootloader and just as is does not matter if you use lilo or grub it
should no longer matter what bootloader/kernel was used for resuming,
now that a ABI for the resume has been defined.

Torsten

(*): 2.6.12 might not work, as Rafael said the feature supporting
different kernel versions was only merge recently.
