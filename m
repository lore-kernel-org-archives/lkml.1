Return-Path: <linux-kernel-owner+w=401wt.eu-S1763823AbXKNAmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763823AbXKNAmY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 19:42:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761174AbXKNAmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 19:42:13 -0500
Received: from mga03.intel.com ([143.182.124.21]:15480 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760911AbXKNAmL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 19:42:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,412,1188802800"; 
   d="scan'208";a="317874778"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [kvm-devel] [PATCH 2/3] kvmclock - the host part.
Date: Wed, 14 Nov 2007 08:41:16 +0800
Message-ID: <10EA09EFD8728347A513008B6B0DA77A025DFCCF@pdsmsx411.ccr.corp.intel.com>
In-Reply-To: <4739CD03.90406@qumranet.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [kvm-devel] [PATCH 2/3] kvmclock - the host part.
Thread-Index: AcgmEQpyzGU3AnogSRGmKinC6f2kgwARYbcw
References: <11945615632624-git-send-email-gcosta@redhat.com><11945615703593-git-send-email-gcosta@redhat.com> <11945615751747-git-send-email-gcosta@redhat.com> <10EA09EFD8728347A513008B6B0DA77A025DF8A2@pdsmsx411.ccr.corp.intel.com> <4739906B.2080103@redhat.com> <4739B916.4000405@qumranet.com> <10EA09EFD8728347A513008B6B0DA77A025DFB75@pdsmsx411.ccr.corp.intel.com> <4739CD03.90406@qumranet.com>
From: "Dong, Eddie" <eddie.dong@intel.com>
To: "Avi Kivity" <avi@qumranet.com>
Cc: "Glauber de Oliveira Costa" <gcosta@redhat.com>,
       <linux-kernel@vger.kernel.org>, <jeremy@goop.org>, <hollisb@us.ibm.com>,
       <kvm-devel@lists.sourceforge.net>
X-OriginalArrivalTime: 14 Nov 2007 00:41:33.0407 (UTC) FILETIME=[1AD276F0:01C82657]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> 
>> +	kvm_get_msr(vcpu, MSR_IA32_TIME_STAMP_COUNTER,
>> +			  &vcpu->hv_clock.last_tsc);
>> +
>> +	ktime_get_ts(&ts);
>> +	vcpu->hv_clock.now_ns = ts.tv_nsec + (NSEC_PER_SEC *
>> (u64)ts.tv_sec); +	vcpu->hv_clock.wc_sec = get_seconds();
>> 
>> I am even thinking we have to disable interrupt between these lines,
>> otherwise guest wall clock may see backward time source when
>> calculating the delta TSC since last vcpu->hv_clock.now_ns update.
>> 
> 
> That's true.  While we do need to handle vcpu migration and
> descheduling, the code sequence you note needs to be as atomic as
> possible. 
> 

Yes VCPU migration is another issue. Since the physical platform TSC is 
totally different across migration, so we can't expose host TSC to
guest.
For KVM, it should be simple to just use guest_TSC (=HOST_TSC + offset).

thanks, eddie
