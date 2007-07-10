Return-Path: <linux-kernel-owner+w=401wt.eu-S1762862AbXGJQ42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762862AbXGJQ42 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 12:56:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757488AbXGJQ4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 12:56:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:15872 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754812AbXGJQ4T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 12:56:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,523,1175497200"; 
   d="scan'208";a="266619135"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: OOPS at dmar_table_init (2.6.22-rc6-mm1 kernel)
Date: Tue, 10 Jul 2007 09:56:10 -0700
Message-ID: <8A3E977AB3C24845947ADAAE0526E39502804C7B@orsmsx419.amr.corp.intel.com>
In-Reply-To: <20070710094930.1d4be2f4.rdunlap@xenotime.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: OOPS at dmar_table_init (2.6.22-rc6-mm1 kernel)
Thread-Index: AcfDEcy1h64p5kPaSsKnTjgfWnrNKwAATnDw
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
To: "Randy Dunlap" <rdunlap@xenotime.net>, "Pavel Emelianov" <xemul@sw.ru>
Cc: "Raj, Ashok" <ashok.raj@intel.com>, "Li, Shaohua" <shaohua.li@intel.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@osdl.org>
X-OriginalArrivalTime: 10 Jul 2007 16:56:16.0936 (UTC) FILETIME=[3B428A80:01C7C313]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(Sorry for the top post) 

This bug is fixed and the fix should appear in the next MM release.
See this link for the patch
http://marc.info/?l=linux-kernel&m=118313130109808&w=2 

-Anil
-----Original Message-----
From: Randy Dunlap [mailto:rdunlap@xenotime.net] 
Sent: Tuesday, July 10, 2007 9:50 AM
To: Pavel Emelianov
Cc: Raj, Ashok; Li, Shaohua; Keshavamurthy, Anil S; Linux Kernel Mailing
List; Andrew Morton
Subject: Re: OOPS at dmar_table_init (2.6.22-rc6-mm1 kernel)

On Tue, 10 Jul 2007 17:57:25 +0400 Pavel Emelianov wrote:

> Hi.
> 
> While working with Andrew's kernel I faced an OOPS on x86_64 
> machine. Unfortunately kernel logs are not appearing in serial 
> console by the time oops happens, but I have some info on the
> screen:
> 
> OOPs is at dmar_table_init() here:
> ffffffff80532873 <dmar_table_init>:
> ffffffff80532873:       41 55                   push   %r13
> ffffffff80532875:       41 54                   push   %r12
> ffffffff80532877:       55                      push   %rbp
> ffffffff80532878:       53                      push   %rbx
> ffffffff80532879:       51                      push   %rcx
> ffffffff8053287a:       4c 8b 2d 07 21 01 00    mov
73991(%rip),%r13        # ffffffff80544988 <dmar_tbl>
> ffffffff80532881:       41 0f b6 45 24          movzbl 0x24(%r13),%eax
<<<<<<<<<<< OOPS, %r13 = NULL
> ffffffff80532886:       84 c0                   test   %al,%al
> ffffffff80532888:       75 11                   jne
ffffffff8053289b <dmar_table_init+0x28>
> ffffffff8053288a:       48 c7 c7 b0 3d 45 80    mov
$0xffffffff80453db0,%rdi
> ffffffff80532891:       e8 c2 4a cf ff          callq
ffffffff80227358 <printk>
> ffffffff80532896:       e9 f2 01 00 00          jmpq
ffffffff80532a8d <dmar_table_init+0x21a>
> 
> Looks like dmar_tbl is NULL. 
> BUG is 100% reproducible. Is there any other info that can be useful?

You could test the patch from
http://lkml.org/lkml/2007/6/29/174 (see "Get diff 1").


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code
***
