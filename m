Return-Path: <linux-kernel-owner+w=401wt.eu-S1760120AbZDCGqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760120AbZDCGqq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 02:46:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759267AbZDCGqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 02:46:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:25397 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759253AbZDCGqf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 02:46:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,318,1235980800"; 
   d="scan'208";a="444631622"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "tglx@linutronix.de" <tglx@linutronix.de>, "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "eranian@googlemail.com" <eranian@googlemail.com>,
       "oleg@redhat.com" <oleg@redhat.com>,
       "Villacis, Juan" <juan.villacis@intel.com>,
       "ak@linux.jf.intel.com" <ak@linux.jf.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 3 Apr 2009 07:46:30 +0100
Subject: RE: [patch 14/18] x86, ds: use single debug store cpu configuration
Thread-Topic: [patch 14/18] x86, ds: use single debug store cpu configuration
Thread-Index: AcmzyW+ucrsn5EjYRGSqkaDWMZu0dAAXejrw
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77E9271806D@irsmsx504.ger.corp.intel.com>
References: <20090402145455.597376000@intel.com>
 <20090402145728.179163000@intel.com> <20090402192942.GE2455@elte.hu>
In-Reply-To: <20090402192942.GE2455@elte.hu>
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
>From: Ingo Molnar [mailto:mingo@elte.hu]
>Sent: Thursday, April 02, 2009 9:30 PM
>To: Metzger, Markus T
>Cc: tglx@linutronix.de; hpa@zytor.com; markus.t.metzger@gmail.com; roland@redhat.com;
>eranian@googlemail.com; oleg@redhat.com; Villacis, Juan; ak@linux.jf.intel.com; linux-
>kernel@vger.kernel.org
>Subject: Re: [patch 14/18] x86, ds: use single debug store cpu configuration
>
>
>* markus.t.metzger@intel.com <markus.t.metzger@intel.com> wrote:
>
>> Use a single configuration for all cpus.
>>
>
>> @@ -1291,11 +1290,15 @@ ds_configure(const struct ds_configurati
>>  	printk("bts/pebs record: %u/%u bytes\n",
>>  	       ds_cfg.sizeof_rec[ds_bts], ds_cfg.sizeof_rec[ds_pebs]);
>>
>> -	WARN_ON_ONCE(MAX_SIZEOF_DS < (12 * ds_cfg.sizeof_ptr_field));
>> +	WARN_ON(MAX_SIZEOF_DS < (12 * ds_cfg.sizeof_ptr_field));
>
>Why this change?

The function is only called once, now - for the boot cpu.
The _ONCE is a nop. I thought its better to remove it, since it became redundant.

regards,
markus.

>
>Firstly, it was not declared in the changelog which is a no-no.
>
>Secondly, this is a bad change: we are more than content to have a
>single such warning bootup - not dozens of it (on some large
>system).
>
>	Ingo
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

