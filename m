Return-Path: <linux-kernel-owner+w=401wt.eu-S1758380AbXLLIsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758380AbXLLIsm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 03:48:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756250AbXLLIsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 03:48:33 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:60918 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919AbXLLIsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 03:48:33 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ben Woodard <woodard@redhat.com>,
       Neil Horman <nhorman@redhat.com>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>, hbabu@us.ibm.com,
       Andi Kleen <andi@firstfloor.org>, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com
Subject: Re: [PATCH] k8: Enable legacy irqs with  extended cpu ids
References: <20071207175832.GA18485@hmsreliant.think-freely.org>
	<m1k5nm2g3w.fsf@ebiederm.dsl.xmission.com>
	<20071211034349.GA3635@localhost.localdomain>
	<m1ejdt25x0.fsf@ebiederm.dsl.xmission.com>
	<20071211143910.GA10999@hmsreliant.think-freely.org>
	<m1ve75z1v3.fsf@ebiederm.dsl.xmission.com>
	<20071211182254.GB10999@hmsreliant.think-freely.org>
	<m1ejdtysqd.fsf@ebiederm.dsl.xmission.com>
	<20071211192434.GD10999@hmsreliant.think-freely.org>
	<86802c440712111151t29acd38kf9fac8e41743f3e4@mail.gmail.com>
	<20071211205955.GF10999@hmsreliant.think-freely.org>
Date: Wed, 12 Dec 2007 01:43:31 -0700
In-Reply-To: <20071211205955.GF10999@hmsreliant.think-freely.org> (Neil
	Horman's message of "Tue, 11 Dec 2007 15:59:55 -0500")
Message-ID: <m17ijkz4jw.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Horman <nhorman@tuxdriver.com> writes:

> Recently a kdump bug was discovered in which a system would hang inside
> calibrate_delay during the booting of the kdump kernel.  This was caused by the
> fact that the jiffies counter was not being incremented during timer
> calibration.  The root cause of this problem was found to be a bios
> misconfiguration of the hypertransport bus.  On system affected by this hang,
> the bios had assigned APIC ids which used extended apic bits (more than the
> nominal 4 bit ids's), but failed to configure bit 17 of the hypertransport
> transaction config register, which indicated that the mask for the destination
> field of interrupt packets accross the ht bus (see section 3.3.9 of
> http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/26094.PDF).
> If a crash occurs on a cpu with an APIC id that extends beyond 4 bits, it will
> not recieve interrupts during the kdump kernel boot, and this hang will be the
> result.  The fix is to add this patch, whcih add an early pci quirk check, to
> forcibly enable this bit in the httcfg register.  This enables all cpus on a
> system to receive interrupts, and allows kdump kernel bootup to procede
> normally.
>
> Regards
> Neil
>
>
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

Eric
