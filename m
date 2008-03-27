Return-Path: <linux-kernel-owner+w=401wt.eu-S1759264AbYC0KRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759264AbYC0KRd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 06:17:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756196AbYC0KRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 06:17:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:45810 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754998AbYC0KRY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 06:17:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,562,1199692800"; 
   d="scan'208";a="265298469"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [patch] x86, ptrace: support pebs in ds.c and disableptraceand ds support
Date: Thu, 27 Mar 2008 10:16:10 -0000
Message-ID: <029E5BE7F699594398CA44E3DDF55444019B5B78@swsmsx413.ger.corp.intel.com>
In-Reply-To: <20080327095803.GB15003@elte.hu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch] x86, ptrace: support pebs in ds.c and disableptraceand ds support
Thread-Index: AciP8d0SfJPyfMz8TEG79gjbKBU6/QAAECJA
References: <20080312125318.A15510@sedona.ch.intel.com> <20080321125338.GB27245@elte.hu> <029E5BE7F699594398CA44E3DDF55444019B5025@swsmsx413.ger.corp.intel.com> <20080327095803.GB15003@elte.hu>
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, <roland@redhat.com>
Cc: <ak@suse.de>, <hpa@zytor.com>, <linux-kernel@vger.kernel.org>,
       <tglx@linutronix.de>, <markus.t.metzger@gmail.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       <akpm@linux-foundation.org>, <mtk.manpages@gmail.com>,
       <eranian@googlemail.com>, "Villacis, Juan" <juan.villacis@intel.com>
X-OriginalArrivalTime: 27 Mar 2008 10:15:20.0253 (UTC) FILETIME=[762CC6D0:01C88FF3]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Ingo Molnar [mailto:mingo@elte.hu] 
>Sent: Donnerstag, 27. März 2008 10:58
>To: Metzger, Markus T

Ingo,

Thanks for your comments.


>> The patch is not adding new features. It is merely 
>re-establishing the 
>> state before the patch mysteriously disappeared from x86#testing.
>
>well, Roland is the de-facto ptrace maintainer and he has NAK-ed the 
>current approach of extending ptrace, so i removed the patch. Is there 
>anything particularly wrong about doing this based on utrace? The API 
>will hit upstream in 2.6.26 or 2.6.27.

There is nothing wrong with a utrace interface.

It's just that if I want to enable existing debuggers, I need to offer ptrace, as well - at least until utrace is widely used. The intel debugger, for example, will not speak utrace for the next version; but it would support execution tracing, if it were available.


Regarding the patch, it merely restructures the existing (and still present) implementation and adds support for PEBS so Stephane can use this as the low-level interface.

It does not invent any new ptrace commands (although it changes bits in an existing ptrace command).

The patch further allows the ptrace and ds parts to be completely disabled - including all changes to context switching or task destruction (requested by Roland).

I think it is a definite improvement over what we have today.


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

