Return-Path: <linux-kernel-owner+w=401wt.eu-S1757204AbZC0PTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204AbZC0PTu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 11:19:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752281AbZC0PTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 11:19:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:14298 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837AbZC0PTl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 11:19:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,432,1233561600"; 
   d="scan'208";a="398084662"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Oleg Nesterov <oleg@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "eranian@googlemail.com" <eranian@googlemail.com>,
       "Villacis, Juan" <juan.villacis@intel.com>,
       "ak@linux.jf.intel.com" <ak@linux.jf.intel.com>
Date: Fri, 27 Mar 2009 15:18:40 +0000
Subject: RE: [patch 2/14] x86, mm: add release_locked_buffer_on_behalf
Thread-Topic: [patch 2/14] x86, mm: add release_locked_buffer_on_behalf
Thread-Index: Acmu5+hbF7dUBF/2SIWKmi0/i4wOZQABrVYQ
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77E9266B6C0@irsmsx504.ger.corp.intel.com>
References: <20090327094836.A11033@sedona.ch.intel.com>
 <20090327142215.GC14504@redhat.com>
In-Reply-To: <20090327142215.GC14504@redhat.com>
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
>From: Oleg Nesterov [mailto:oleg@redhat.com]
>Sent: Friday, March 27, 2009 3:22 PM
>To: Metzger, Markus T
>Cc: linux-kernel@vger.kernel.org; mingo@elte.hu; tglx@linutronix.de; hpa@zytor.com;
>markus.t.metzger@gmail.com; roland@redhat.com; eranian@googlemail.com; Villacis, Juan;
>ak@linux.jf.intel.com
>Subject: Re: [patch 2/14] x86, mm: add release_locked_buffer_on_behalf
>
>On 03/27, Markus Metzger wrote:
>>
>> -void release_locked_buffer(void *buffer, size_t size)
>> +void release_locked_buffer_on_behalf(struct mm_struct *mm,
>> +				     void *buffer, size_t size)
>>  {
>>  	unsigned long pgsz = PAGE_ALIGN(size) >> PAGE_SHIFT;
>>
>> -	down_write(&current->mm->mmap_sem);
>> +	down_write(&mm->mmap_sem);
>>
>> -	current->mm->total_vm  -= pgsz;
>> -	current->mm->locked_vm -= pgsz;
>> +	mm->total_vm  -= pgsz;
>> +	mm->locked_vm -= pgsz;
>>
>> -	up_write(&current->mm->mmap_sem);
>> +	up_write(&mm->mmap_sem);
>>  }
>
>If you change this helper, perhaps you can remove the "void *buffer"
>argument? It is not used. Actually, this helper should be renamed.
>It doesn't free the memory, it only updates mm->xxx_vm.

OK.

There's an alloc/free pair. This one is in between to allow another task to free
the buffer and get the memory correctly refunded.

How about refund_locked_buffer_memory(struct mm_struct *, size_t)?

regards,
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

