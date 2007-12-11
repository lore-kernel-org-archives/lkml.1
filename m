Return-Path: <linux-kernel-owner+w=401wt.eu-S1756181AbXLKTv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181AbXLKTv6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 14:51:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077AbXLKTvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 14:51:49 -0500
Received: from py-out-1112.google.com ([64.233.166.181]:50312 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbXLKTvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 14:51:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=xzKwl+9Wm5L/J2zxrCf1Al8C20H20htA5hrHtc5Z0C86x90InnvlNamqsLiO8OmCbAut4Bc0Sxlt7hiPGgimykeCgMV+1CyAjkJ5rEnPHSRexex53kcb+KSIEqmjnay5FNQQcrt845dAsQ0m3tjsMGQyPPAvSvSr1d31hdE2EW0=
Message-ID: <86802c440712111151t29acd38kf9fac8e41743f3e4@mail.gmail.com>
Date: Tue, 11 Dec 2007 11:51:39 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Neil Horman" <nhorman@tuxdriver.com>
Subject: Re: [PATCH] kexec: force x86_64 arches to boot kdump kernels on boot cpu
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Ben Woodard" <woodard@redhat.com>, "Neil Horman" <nhorman@redhat.com>,
       kexec@lists.infradead.org, "Andi Kleen" <ak@suse.de>,
       linux-kernel@vger.kernel.org, hbabu@us.ibm.com,
       "Andi Kleen" <andi@firstfloor.org>
In-Reply-To: <20071211192434.GD10999@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440712070122q6e5824bcp12e1c3f560e2ab53@mail.gmail.com>
	 <20071207175832.GA18485@hmsreliant.think-freely.org>
	 <m1k5nm2g3w.fsf@ebiederm.dsl.xmission.com>
	 <20071211034349.GA3635@localhost.localdomain>
	 <m1ejdt25x0.fsf@ebiederm.dsl.xmission.com>
	 <20071211143910.GA10999@hmsreliant.think-freely.org>
	 <m1ve75z1v3.fsf@ebiederm.dsl.xmission.com>
	 <20071211182254.GB10999@hmsreliant.think-freely.org>
	 <m1ejdtysqd.fsf@ebiederm.dsl.xmission.com>
	 <20071211192434.GD10999@hmsreliant.think-freely.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 11, 2007 11:24 AM, Neil Horman <nhorman@tuxdriver.com> wrote:
> On Tue, Dec 11, 2007 at 11:46:34AM -0700, Eric W. Biederman wrote:
> > Neil Horman <nhorman@tuxdriver.com> writes:
> >
> > Ok. My only remaining nit to pick is that fix_hypertransport_config
> > is right in the middle of the nvidia quirks, which can be a bit
> > confusing when reading through the code.  Otherwise I think this
> > is a version that we can merge.
> >
> Sure, I'll move it to the top of the file
>
> > Let's get a clean description on this thing and send it to the
> > current x86 maintainers. Thomas, Ingo, and HPA
> >
>
> Clean Summary:
>
> Recently a kdump bug was discovered in which a system would hang inside
> calibrate_delay during the booting of the kdump kernel.  This was caused by the
> fact that the jiffies counter was not being incremented during timer
> calibration.  The root cause of this problem was found to be a bios
> misconfiguration of the hypertransport bus.  On system affected by this hang,
> the bios had assigned APIC ids which used extended apic bits (more than the
> nominal 4 bit ids's), but failed to configure bit 18 of the hypertransport

should be bit 17.

YH
