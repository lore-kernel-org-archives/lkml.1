Return-Path: <linux-kernel-owner+w=401wt.eu-S1753252AbXKMFBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252AbXKMFBR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 00:01:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750701AbXKMFBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 00:01:07 -0500
Received: from mga03.intel.com ([143.182.124.21]:7542 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699AbXKMFBG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 00:01:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,408,1188802800"; 
   d="scan'208";a="317151631"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [kvm-devel] [PATCH 2/3] kvmclock - the host part.
Date: Tue, 13 Nov 2007 13:00:10 +0800
Message-ID: <10EA09EFD8728347A513008B6B0DA77A025DF8A2@pdsmsx411.ccr.corp.intel.com>
In-Reply-To: <11945615751747-git-send-email-gcosta@redhat.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [kvm-devel] [PATCH 2/3] kvmclock - the host part.
Thread-Index: AcgiT875b1FvW8jRRSCcZ0xh11GGBADYcupw
References: <11945615632624-git-send-email-gcosta@redhat.com><11945615703593-git-send-email-gcosta@redhat.com> <11945615751747-git-send-email-gcosta@redhat.com>
From: "Dong, Eddie" <eddie.dong@intel.com>
To: "Glauber de Oliveira Costa" <gcosta@redhat.com>,
       <linux-kernel@vger.kernel.org>
Cc: <jeremy@goop.org>, <hollisb@us.ibm.com>, <kvm-devel@lists.sourceforge.net>,
       <avi@qumranet.com>
X-OriginalArrivalTime: 13 Nov 2007 05:00:13.0080 (UTC) FILETIME=[12DAE180:01C825B2]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> +static void kvm_write_guest_time(struct kvm_vcpu *vcpu) +{
> +	struct timespec ts;
> +	int r;
> +
> +	if (!vcpu->clock_gpa)
> +		return;
> +
> +	/* Updates version to the next odd number, indicating
> we're writing */
> +	vcpu->hv_clock.version++;
> +	kvm_write_guest(vcpu->kvm, vcpu->clock_gpa,
> &vcpu->hv_clock, PAGE_SIZE);
> +
> +	kvm_get_msr(vcpu, MSR_IA32_TIME_STAMP_COUNTER,
> +			  &vcpu->hv_clock.last_tsc);
> +
> +	ktime_get_ts(&ts);

Do we need to disable preemption here?

> +	vcpu->hv_clock.now_ns = ts.tv_nsec + (NSEC_PER_SEC *
> (u64)ts.tv_sec); +	vcpu->hv_clock.wc_sec = get_seconds();
> +	vcpu->hv_clock.version++;
> +	kvm_write_guest(vcpu->kvm, vcpu->clock_gpa,
> &vcpu->hv_clock, PAGE_SIZE);
> +}
> +
thx,eddie
