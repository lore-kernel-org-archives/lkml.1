Return-Path: <linux-kernel-owner+w=401wt.eu-S1755587AbYKUI7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587AbYKUI7S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 03:59:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752806AbYKUI7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 03:59:04 -0500
Received: from mga01.intel.com ([192.55.52.88]:19768 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752487AbYKUI7C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 03:59:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,639,1220252400"; 
   d="scan'208";a="406361342"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: "eranian@gmail.com" <eranian@gmail.com>
CC: Markus Metzger <markus.t.metzger@googlemail.com>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 21 Nov 2008 08:58:43 +0000
Subject: RE: debugctl msr
Thread-Topic: debugctl msr
Thread-Index: AclLtgRZciet7FsPSym3ldy2rYkh5QAAEKwg
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77E08F1160E@irsmsx504.ger.corp.intel.com>
References: <7c86c4470810300753v7d377092qbcd266178d8e7338@mail.gmail.com>
	 <928CFBE8E7CB0040959E56B4EA41A77E08F10AAA@irsmsx504.ger.corp.intel.com>
	 <7c86c4470811190459y5996f51bp24ab38c9e856c2eb@mail.gmail.com>
	 <928CFBE8E7CB0040959E56B4EA41A77E08F10CB1@irsmsx504.ger.corp.intel.com>
	 <7c86c4470811190913u743706abgafff3b0f0e3559ec@mail.gmail.com>
	 <1227119245.6025.12.camel@raistlin>
	 <7c86c4470811191120i63b70970s3e24af5c962ea538@mail.gmail.com>
	 <1227133570.6104.10.camel@raistlin>
	 <7c86c4470811201319x2eb93d41vbdd8ce480a797fab@mail.gmail.com>
	 <928CFBE8E7CB0040959E56B4EA41A77E08F115BC@irsmsx504.ger.corp.intel.com>
 <7c86c4470811210047u66a4c188nb99785527f1718ef@mail.gmail.com>
In-Reply-To: <7c86c4470811210047u66a4c188nb99785527f1718ef@mail.gmail.com>
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
>From: stephane eranian [mailto:eranian@googlemail.com] 
>Sent: Freitag, 21. November 2008 09:48
>To: Metzger, Markus T

>> If ds_validate() is disabled, it would put the context twice.
>>
>Yes, that was my case.

The code heavily relies on ds_validate().
I would expect a lot of things to break down if ds_validate() were
disabled.


>I found the reason why in system-wide my kernel was crashing.
>It was due to the way you are writing DS_AREA_MSR in
>ds_allocate_context():
>
>                if (!task || (task == current))
>                        wrmsr(MSR_IA32_DS_AREA, (unsigned 
>long)context->ds, 0);


Thanks. I have a fix in my sandbox.


I won't be able to send the patches out this week. Especially the
interface change to introduce the handle is quite big. I should have
them early next week.


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

