Return-Path: <linux-kernel-owner+w=401wt.eu-S1761333AbZEMSpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761333AbZEMSpp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 14:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760855AbZEMSpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 14:45:36 -0400
Received: from science.horizon.com ([192.35.100.1]:56101 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759851AbZEMSpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 14:45:35 -0400
Date: 13 May 2009 14:45:16 -0400
Message-ID: <20090513184516.19020.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: belyshev@depni.sinp.msu.ru, johnstul@us.ibm.com
Subject: Re: [PATCH] tsc_khz= boot option to avoid TSC calibration variance
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux@horizon.com,
       mingo@elte.hu, tglx@linutronix.de, ulrich.windl@rz.uni-regensburg.de,
       williams@redhat.com, zippel@linux-m68k.org
In-Reply-To: <87d4aejw5b.fsf@depni.sinp.msu.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> No, it won't, because...  
> <cde snippet>
> ... of this "if".
> 
> Please *please* don't set arbitrary limits.  Just use user supplied value.
> 
> Or at the very least print big red warning if you are going to ignore a user
> supplied option (and have another tsc_khz_really= option to override faulty
> calibration routine).

I'd like to disagree.  The calibration is accurate and reliable.
It has worked without any override for millions of users for many
years.  What is the plausible reason to need to set it to a wildly
divergent value?

On the other hand, what if my CPU gets fried and I replace it with one
with a different clock multiplier?  Or the motherboard fries and I move
the boot hard drive to a different machine?  That's a situation that I
have found myself in.  And I don't want to figure out how to edit the
LILO options before booting the machine, even if I remember to do it
at all; this is an emergency replacement.

In such a case, having the kernel believe the command line could result
in it not booting, or the system not working properly.

Much better that it basically work, even if some fine-tuning remains
to be done.

And that's the idea: this is a fine-tuning option.  If the calibration
says the option value is grossly wrong, then something strange has
happened, and the kernel calibration value is safer.

If you think a coarse-tuning option is required, I can extend the patch
so that a trailing ! (e.g. "tsc_khz=3000000!") disables the sanity check.
Bit I'd still like to see an argument for why it is required.  Remember,
it would be far better to make the kernel self-calibration more accurate,
so people don't even have to use this option.  It's only there because
it's the simplest way (simplest for the lazy programmer, not the user!)
to guarantee getting exactly the same value each boot.

>From a *user* point of view, I'd rather the kernel did it automagically
and I didn't need to futz with the kernel command line at all.
