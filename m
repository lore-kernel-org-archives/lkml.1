Return-Path: <linux-kernel-owner+w=401wt.eu-S1758404AbZDDHST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758404AbZDDHST (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 03:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754764AbZDDHSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 03:18:07 -0400
Received: from mga14.intel.com ([143.182.124.37]:39174 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754426AbZDDHSF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 03:18:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,322,1235980800"; 
   d="scan'208";a="127839729"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: "mingo@elte.hu" <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "eranian@googlemail.com" <eranian@googlemail.com>,
       "oleg@redhat.com" <oleg@redhat.com>,
       "Villacis, Juan" <juan.villacis@intel.com>,
       "ak@linux.jf.intel.com" <ak@linux.jf.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Date: Sat, 4 Apr 2009 08:17:56 +0100
Subject: RE: [patch 03/20] x86, ptrace, bts: defer branch trace stopping
Thread-Topic: [patch 03/20] x86, ptrace, bts: defer branch trace stopping
Thread-Index: Acm0bNhPr74zhbSdRiqAG+Bx204pGAAiA53w
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77E9271853A@irsmsx504.ger.corp.intel.com>
References: <20090403144332.799740000@intel.com>
	 <20090403144550.712401000@intel.com> <1238770852.798.146.camel@twins>
In-Reply-To: <1238770852.798.146.camel@twins>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Peter Zijlstra [mailto:a.p.zijlstra@chello.nl]
>Sent: Friday, April 03, 2009 5:01 PM
>To: Metzger, Markus T


>Also, I can't say I like the name, what about something like:
>
>void account_locked_buffer(struct mm_struct *mm, long pages)
>{
>	down_write(&mm->mmap_sem);
>
>	mm->total_vm += pages;
>	mm->locked_vm += pages;
>
>	up_write(&mm->mmap_sem);
>}
>
>but looking more closely at that alloc_locked_buffer() stuff, I really
>hate it, who in his right mind does a multi-page kmalloc() -- that's
>crazy.

I need a non-pageable chunk of memory to give to the cpu to store branch
trace data in. Kmalloc() is easy to use and gives me what I need.

How would I do this correctly?

thanks,
markus.
---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

