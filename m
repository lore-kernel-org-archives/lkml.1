Return-Path: <linux-kernel-owner+w=401wt.eu-S932570AbXCOS6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570AbXCOS6p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 14:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932574AbXCOS6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 14:58:45 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:25441 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932570AbXCOS6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 14:58:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:reply-to:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=L6ogJpptmBB6GvA/erW6+WERYyuKGfEXaTyny2O+0geClSFMOV7YeWvJVR9wMT86lg3gN7m6z283qwFqY4yc+POegyt3JhF9qD44pyGhBbGPj7x3dbWvSPnmhftsWC5I95QafD749WythPwEECEGyf1uVv8uUYIMPgOIkvGkda8=
Message-ID: <2c0942db0703151158l59cbede2x845fc134d9f1cf9d@mail.gmail.com>
Date: Thu, 15 Mar 2007 11:58:39 -0700
From: "Ray Lee" <madrabbit@gmail.com>
Reply-To: ray-gmail@madrabbit.org
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Subject: Re: RSDL v0.30 cpu scheduler for mainline kernels
Cc: "Con Kolivas" <kernel@kolivas.org>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>,
       "ck list" <ck@vds.kolivas.org>
In-Reply-To: <20070315174654.GB12447@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703121058.11966.kernel@kolivas.org>
	 <20070315023102.GL30596@linux-os.sc.intel.com>
	 <200703151705.13761.kernel@kolivas.org>
	 <20070315174654.GB12447@linux-os.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/15/07, Siddha, Suresh B <suresh.b.siddha@intel.com> wrote:
> On Thu, Mar 15, 2007 at 05:05:13PM +1100, Con Kolivas wrote:
> > On Thursday 15 March 2007 13:31, Siddha, Suresh B wrote:
> > > Just to see the % increase in number of context switches, I ran 8 infinite
> > > loops (simple while(1); 's) and with 2.6.21-rc3 I see ~70 context switches
> > > every second, whereas with RSDL I see ~530 context switches.
> >
> > Thanks. If it's just that then scaling rr interval with cpus somewhat would
> > help. If you could, the following patch just to test might confirm that.
> > -#define RR_INTERVAL          ((6 * HZ / 1001) + 1)
> > +#define RR_INTERVAL          ((12 * HZ / 1001) + 1)
>
> Context switches now are ~370 per second. Still much above the regular ~70
> we see in the mainline.
>
> why do you say the rr_interval needs to be scaled with cpus? The basic point
> in RSDL is, if we have more than one same priority task on a single logic
> cpu, context switch happens every RR_INTERVAL (6 or 12 msec) whereas in
> mainline it happens every 100 msec.

With more CPUs, the context switch period can be multiplied by that
number of CPUs while still allowing all tasks the same frequency of
access to the CPU. With 4 processors, the context switch would be
24ms, by which point we're probably reaching the point of diminishing
returns for minimizing overhead and maximizing throughput.

> We need to minimize these context switches.

That's a judgement call. If a synthetic benchmark degrades but other
things improve, then this, as most everything in computer science, is
yet another trade-off that needs to be evaluated. (You recognize there
is a tradeoff here, right? Some benchmarks would improve even further
if the switch time were 500ms. But that would make the system nearly
unusable in general.)

Ray
