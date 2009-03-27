Return-Path: <linux-kernel-owner+w=401wt.eu-S1758289AbZC0Pj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758289AbZC0Pj4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 11:39:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754586AbZC0Pjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 11:39:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:33431 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754305AbZC0Pjr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 11:39:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,432,1233561600"; 
   d="scan'208";a="398089840"
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
Date: Fri, 27 Mar 2009 15:39:31 +0000
Subject: RE: [patch 4/14] x86, ds: wait before freeing the DS configuration
Thread-Topic: [patch 4/14] x86, ds: wait before freeing the DS configuration
Thread-Index: Acmu6dgLNK4/NgDDR9mKbVKc/qWUpAACDz+w
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77E9266B6D8@irsmsx504.ger.corp.intel.com>
References: <20090327095840.A11187@sedona.ch.intel.com>
 <20090327143556.GE14504@redhat.com>
In-Reply-To: <20090327143556.GE14504@redhat.com>
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
>Sent: Friday, March 27, 2009 3:36 PM
>To: Metzger, Markus T
>Cc: linux-kernel@vger.kernel.org; mingo@elte.hu; tglx@linutronix.de; hpa@zytor.com;
>markus.t.metzger@gmail.com; roland@redhat.com; eranian@googlemail.com; Villacis, Juan;
>ak@linux.jf.intel.com
>Subject: Re: [patch 4/14] x86, ds: wait before freeing the DS configuration
>
>On 03/27, Markus Metzger wrote:
>>
>> --- git-tip.orig/arch/x86/kernel/ds.c	2009-03-27 07:59:23.000000000 +0100
>> +++ git-tip/arch/x86/kernel/ds.c	2009-03-27 08:00:41.000000000 +0100
>> @@ -783,6 +783,14 @@ void ds_release_bts(struct bts_tracer *t
>>
>>  	ds_suspend_bts(tracer);
>>
>> +	/*
>> +	 * We must wait for the suspend to take effect before we may
>> +	 * free the tracer and the ds configuration.
>> +	 */
>> +	if (tracer->ds.context->task &&
>> +	    (tracer->ds.context->task != current))
>> +		wait_task_inactive(tracer->ds.context->task, 0);
>> +
>
>Since you didn't replay yet, I will just repeat my question ;)

I replied in http://lkml.org/lkml/2009/3/27/220.

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

