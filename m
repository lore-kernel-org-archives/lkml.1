Return-Path: <linux-kernel-owner+w=401wt.eu-S1753864AbYKSMPG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864AbYKSMPG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 07:15:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbYKSMOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 07:14:53 -0500
Received: from mga11.intel.com ([192.55.52.93]:61344 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752197AbYKSMOw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 07:14:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,631,1220252400"; 
   d="scan'208";a="641009585"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: "eranian@gmail.com" <eranian@gmail.com>,
       Markus Metzger <markus.t.metzger@googlemail.com>
CC: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 19 Nov 2008 12:14:45 +0000
Subject: RE: debugctl msr
Thread-Topic: debugctl msr
Thread-Index: AclJyST9oNUNfXnsT1KHVfre1MWzigAdRjCA
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77E08F10AAA@irsmsx504.ger.corp.intel.com>
References: <7c86c4470810300753v7d377092qbcd266178d8e7338@mail.gmail.com>
	 <1226236327.6104.4.camel@raistlin>
	 <7c86c4470811111411k754887a8ic9b63163928157a6@mail.gmail.com>
	 <491A812D.9010208@gmail.com>
	 <7c86c4470811120210j2ea5ccdcv59a654aadc32ebd2@mail.gmail.com>
	 <029E5BE7F699594398CA44E3DDF5544402B1F123@swsmsx413.ger.corp.intel.com>
	 <7c86c4470811130650j4192c63n1fa9800a0cdfb93c@mail.gmail.com>
	 <029E5BE7F699594398CA44E3DDF5544402B595A3@swsmsx413.ger.corp.intel.com>
	 <7c86c4470811141310h4fd3c5fbvc6357985cf2aed0e@mail.gmail.com>
	 <1226743286.6162.6.camel@raistlin>
 <7c86c4470811181400r1fa56ef9o1931467ee10e4f52@mail.gmail.com>
In-Reply-To: <7c86c4470811181400r1fa56ef9o1931467ee10e4f52@mail.gmail.com>
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
>Sent: Dienstag, 18. November 2008 23:01
>To: Markus Metzger
>Cc: Metzger, Markus T; Ingo Molnar; Andi Kleen; Andrew Morton; 
>linux-kernel@vger.kernel.org
>Subject: Re: debugctl msr
>

>I think your definition for ds_cfg_64 is wrong. On Core, the PEBS
>record ALWAYS includes r8-r15 even on
>32 bits (zero filled). Also the DS_AREA has 9 fields, not 8.
>Consequently, I think the structure should be defined
>as follows:
>
>static const struct ds_configuration ds_cfg_64 = {
>        .sizeof_ds    = 8 * 9,

You are right that there are 9 fields.
However, the 9th field is double the size of the other fields and the entire structure is padded.
The original code should read 8 * 12 to reflect that.

>        .sizeof_field = 8,
>        .sizeof_rec[ds_bts]   = 8 * 3,
>        .sizeof_rec[ds_pebs]  = 8 * 18

You're right about the PEBS size.

I will send a patch some time this week.

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

