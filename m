Return-Path: <linux-kernel-owner+w=401wt.eu-S1765114AbXJTFuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765114AbXJTFuZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 01:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752709AbXJTFuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 01:50:14 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:15846 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbXJTFuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 01:50:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZGaQnZuBM1BteOEzTDp37S4tdCmHeOYgfD/dnM24N8BE9v/fW9VDhLvwVphW8uqmLKL3ewECc9O7I6WFBZs4kxz3/qolq9jBkr3wtdQx/8jm/km8j6+XC4hCeHjHcoAATKCMDbzBvhqrCCDbbK6jSxICwiXJW4JJ/JtcA2vH5/c=
Message-ID: <851fc09e0710192250k7c2d5269rf6bf1ec604a23603@mail.gmail.com>
Date: Sat, 20 Oct 2007 13:50:10 +0800
From: "huang ying" <huang.ying.caritas@gmail.com>
To: "Phillip Susi" <psusi@cfl.rr.com>
Subject: Re: [PATCH 0/2 -mm] kexec based hibernation -v5
Cc: "Huang, Ying" <ying.huang@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Pavel Machek" <pavel@ucw.cz>, nigel@nigel.suspend2.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Jeremy Maitin-Shepard" <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       "Kexec Mailing List" <kexec@lists.infradead.org>
In-Reply-To: <47190B28.6070405@cfl.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1192068833.27482.13.camel@caritas-dev.intel.com>
	 <47190B28.6070405@cfl.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/07, Phillip Susi <psusi@cfl.rr.com> wrote:
> Huang, Ying wrote:
> > The hibernation procedure with the patch set is as follow:
> >
> > 1. Boot a kernel A
> >
> > 2. Work under kernel A
> >
> > 3. Kexec another kernel B (crash dump enabled) in kernel A.
> >
> > 4. Save the memory image of kernel A through crash dump (such as "cp
> >    /proc/vmcore ~"). Save the "jump back entry".
>
> Doesn't this also save the memory of kernel B?

The memory area of kernel B is excluded from the elf header of
/proc/vmcore. This is done in kexec-tools (/sbin/kexec) patches.

> > 5. Shutdown or reboot
> >
> >
> > The restore process with the patch set is as follow:
> >
> > 1. Boot a kernel C (crash dump enabled), the memory area used by
> >    kernel C must be a subset of memory area used by kernel B.
>
> Why is a third kernel needed?  Why can't kernel B be used for this as
> well?  In fact, if kernel A has been compiled to be relocatable and
> crash dump enabled, why wouldn't it suffice for all 3 instances?

One kernel can be used for three situation. In fact, I use just one
kernel for testing.

Best Regards,
Huang Ying
