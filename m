Return-Path: <linux-kernel-owner+w=401wt.eu-S1754432AbZFSDLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432AbZFSDLi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 23:11:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751547AbZFSDLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 23:11:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:29215 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371AbZFSDLa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 23:11:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,248,1243839600"; 
   d="scan'208";a="423603372"
From: "Jiang, Yunhong" <yunhong.jiang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
CC: Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, Keir Fraser <keir.fraser@eu.citrix.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 19 Jun 2009 11:10:24 +0800
Subject: RE: [Xen-devel] Re: [PATCH RFC] x86/acpi: don't ignore I/O APICs
 just	because there's no local APIC
Thread-Topic: [Xen-devel] Re: [PATCH RFC] x86/acpi: don't ignore I/O APICs
 just	because there's no local APIC
Thread-Index: AcnwfsNknbEEMrsMTaKVB8BpYdWoMgACtUtw
Message-ID: <E2263E4A5B2284449EEBD0AAB751098402CBA3427E@PDSMSX501.ccr.corp.intel.com>
References: <4A329CF8.4050502@goop.org> <m1d499yyug.fsf@fess.ebiederm.org>
	<4A35ACB3.9040501@goop.org> <m1k53dbwo2.fsf@fess.ebiederm.org>
	<4A36B3EC.7010004@goop.org> <m1fxe117n5.fsf@fess.ebiederm.org>
	<4A37F4AE.5050902@goop.org> <m1vdmvxe3u.fsf@fess.ebiederm.org>
	<4A392896.9090408@goop.org> <m1zlc6memu.fsf@fess.ebiederm.org>
	<4A3A96BC.1000302@goop.org> <m1ab45i8vs.fsf@fess.ebiederm.org>
	<4A3AACFD.5020805@goop.org> <m1zlc5f1em.fsf@fess.ebiederm.org>
In-Reply-To: <m1zlc5f1em.fsf@fess.ebiederm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



xen-devel-bounces@lists.xensource.com wrote:
> I/O APICs just because there's no local APIC
> 
> Jeremy Fitzhardinge <jeremy@goop.org> writes:
> 
>> Ah, OK.  The pirq is set up for a specific domain rather than being
>> global (otherwise it would need some kind of "which domain can access
>> which pirq" table).  dom0 can either create a pirq for itself or
>> someone else, and the final user of the pirq binds it to a
>> domain-local evtchn. 

I think currently the GSI pirq is global, while MSI irq is per-domain. In fact, the irq for gsi is allocated by dom0 itself, and is shared by xen/dom0. I suspect this is partly because In 2.6.18 kernel, the irq/gsi is really messed up (I remember there is cleanup happen in 2.6.19).  

The domU get the pirq value through pci-backend and pci frontend driver. The user space tools will grant one pirq to a guest through hypercall and the permission information is saved in domain's structure.

When we switch to Jeremy's new method, maybe we can make the irq to be alocated by Xen HV, but I suspect it is ok to be kept still as global.

The MSI is using per-domain pirq.

--jyh

>> 
>> I think.  I really haven't looked into the pci-passthrough parts very
>> closely yet.
> 
> I certainly could not find the code that would let you setup a pirq
> for another domain.  In fact the pirq code aka alloc_vectors appears
> to hard code dom0 in Xen 3.4.
> 
> pci-passthrough since it is domU, and since you describe it as well
> isolated and comparatively simple should be a shoe in.
> 
> Further as you describe it pci-passthrough is a subset of what we
> have to do for dom0. So if we can I would like to see the pci
> passthrough code get merged first. 
> 
> Eric
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel