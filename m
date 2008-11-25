Return-Path: <linux-kernel-owner+w=401wt.eu-S1753428AbYKYLXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbYKYLXa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 06:23:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751506AbYKYLXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 06:23:22 -0500
Received: from mga09.intel.com ([134.134.136.24]:26419 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917AbYKYLXV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 06:23:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,663,1220252400"; 
   d="scan'208";a="467089072"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: =?iso-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
CC: "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "mtk.manpages@gmail.com" <mtk.manpages@gmail.com>,
       "eranian@googlemail.com" <eranian@googlemail.com>,
       "Villacis, Juan" <juan.villacis@intel.com>,
       Andi Kleen <andi@firstfloor.org>
Date: Tue, 25 Nov 2008 11:23:09 +0000
Subject: RE: [patch 9/9] x86, bts, ftrace: a BTS ftrace plug-in prototype
Thread-Topic: [patch 9/9] x86, bts, ftrace: a BTS ftrace plug-in prototype
Thread-Index: AclO6i4xLdeE3S3ZQRGZwHAKuZOXzQABaL9w
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77E08F3C3A1@irsmsx504.ger.corp.intel.com>
References: <20081125092415.A31432@sedona.ch.intel.com>
 <c62985530811250239v4a51cd1p4de5f1616a41ef36@mail.gmail.com>
In-Reply-To: <c62985530811250239v4a51cd1p4de5f1616a41ef36@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Frédéric Weisbecker [mailto:fweisbec@gmail.com] 
>Sent: Dienstag, 25. November 2008 11:40
>To: Metzger, Markus T

>2008/11/25 Markus Metzger <markus.t.metzger@intel.com>:
>> +static enum print_line_t bts_trace_print_line(struct 
>trace_iterator *iter)
>> +{
>> +       struct trace_entry *entry = iter->ent;
>> +       struct trace_seq *seq = &iter->seq;
>> +       struct bts_entry *it;
>> +
>> +       trace_assign_type(it, entry);
>> +
>> +       if (entry->type == TRACE_BTS) {
>> +               int ret;
>> +#ifdef CONFIG_KALLSYMS
>> +               char function[KSYM_SYMBOL_LEN];
>> +               sprint_symbol(function, it->from);
>> +#else
>> +               char *function = "<unknown>";
>> +#endif
>> +
>> +               ret = trace_seq_printf(seq, "%4d  0x%lx -> 
>0x%lx [%s]\n",
>> +                                      entry->cpu, it->from, 
>it->to, function);
>
>
>You can use seq_print_ip_sym() which handles the ifdef and the 
>sprint_symbol...

Thanks.


>> +void trace_bts(struct trace_array *tr, unsigned long from, 
>unsigned long to)
>> +{
>> +       struct ring_buffer_event *event;
>> +       struct bts_entry *entry;
>> +       unsigned long irq;
>> +
>> +       event = ring_buffer_lock_reserve(tr->buffer, 
>sizeof(*entry), &irq);
>> +       if (!event)
>> +               return;
>> +       entry   = ring_buffer_event_data(event);
>> +       tracing_generic_entry_update(&entry->ent, 0, from);
>> +       entry->ent.type = TRACE_BTS;
>> +       entry->ent.cpu = smp_processor_id();
>
>
>If you look at the struct trace_entry, you will see find the cpu
>field. It is already inserted automatically :-)

I am using that field in struct trace_entry.

Without the assignment, though, I've seen funny cpu numbers. It seems that the field is not filled automatically.


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

