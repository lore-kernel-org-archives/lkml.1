Return-Path: <linux-kernel-owner+w=401wt.eu-S1030200AbXCFVfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030200AbXCFVfy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 16:35:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030194AbXCFVfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 16:35:54 -0500
Received: from mga09.intel.com ([134.134.136.24]:11246 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030200AbXCFVfx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 16:35:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,255,1170662400"; 
   d="scan'208"; a="53982425:sNHT20503575"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Xen & VMI?
Date: Tue, 6 Mar 2007 13:35:51 -0800
Message-ID: <8FFF7E42E93CC646B632AB40643802A8022CBA54@scsmsx412.amr.corp.intel.com>
In-Reply-To: <20070306203712.GC21736@elte.hu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Xen & VMI?
Thread-Index: AcdgL0JQNMCdaM76Qr++eQom2dn7SAAAykAQ
From: "Nakajima, Jun" <jun.nakajima@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Anthony Liguori" <anthony@codemonkey.ws>,
       "virtualization" <virtualization@lists.osdl.org>,
       "Roland McGrath" <roland@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Jan Beulich" <jbeulich@novell.com>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 06 Mar 2007 21:35:52.0084 (UTC) FILETIME=[69FA7D40:01C76037]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Nakajima, Jun <jun.nakajima@intel.com> wrote:
> 
>> I think a KVM Linux would benefit more from paravirt ops, rather than
>> VMI. The higher-level interface such as the one in Xen, espeically
>> for I/O, interrupt controllers, timer, SMP, etc. actually simplifies
>> the implementation of the VMM, and improve performance of the guest.
>> Even for MMU, direct page tables, for example, would work better for
>> hardware-based virtualization because the processor can use the
>> native page tables.
> 
> maybe we are talking past each other because i dont really disagree
> with that: i mentioned it right at beginning that higher-level APIs
> would have to be added to VMI. What i'd like to avoid is the ABI
> duplication for the lowlevel stuff /and/ for the highlevel stuff.
> Since VMI is mostly about lowlevel stuff right now it's obvious that
> it would have to grow more highlevel ops. Doing an IO driver via IO
> emulation is obviously pretty ... low-tech.
>

I agree with you.
 
> maybe i shouldnt call it 'VMI' but 'the paravirt ABI'. I dont mind if
> it's the Xen ABI or the VMWare ABI or a mesh of the two - everyone can
> map their own internals to that /one/ ABI.

To me it should be handled as 'paravirt devices', 'paravirt chipset',
etc. If we use the standard H/W detection mechanism (such as CPUID, I/O
port, etc.) used by the native kernel, we should be able to extend the
kernel cleanly (or just add device drivers). And the key here is to
define the behavior of such pseudo (or fake) H/W as we do for actual
H/W. Then 'the paravirt ABI' is the set of (high-level) operations for
such fake H/W devices.

> 
> 	Ingo

Jun
---
Intel Open Source Technology Center
