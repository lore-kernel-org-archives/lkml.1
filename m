Return-Path: <linux-kernel-owner+w=401wt.eu-S1754431AbZIUH0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431AbZIUH0E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 03:26:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751463AbZIUH0C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 03:26:02 -0400
Received: from mga11.intel.com ([192.55.52.93]:50840 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348AbZIUH0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 03:26:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,423,1249282800"; 
   d="scan'208";a="495306403"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: "mingo@elte.hu" <mingo@elte.hu>
CC: "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
       "Metzger, Markus T" <markus.t.metzger@intel.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "mingo@redhat.com" <mingo@redhat.com>,
       "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Date: Mon, 21 Sep 2009 08:25:29 +0100
Subject: RE: [tip:perfcounters/core] x86, perf_counter, bts: Optimize BTS
 overflow handling
Thread-Topic: [tip:perfcounters/core] x86, perf_counter, bts: Optimize BTS
 overflow handling
Thread-Index: Aco4lOCeKJBMUzbGRgOPO3+Cewv2vQB9oFmw
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77EC69BA609@irsmsx504.ger.corp.intel.com>
References: <20090915130023.A16204@sedona.ch.intel.com>
 <tip-5622f295b53fb60dbf9bed3e2c89d182490a8b7f@git.kernel.org>
In-Reply-To: <tip-5622f295b53fb60dbf9bed3e2c89d182490a8b7f@git.kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n8L7QG16009545

>-----Original Message-----
>From: tip tree robot [mailto:bounces.tip@hpa.at.zytor.com] On Behalf Of tip-bot for Markus Metzger
>Sent: Friday, September 18, 2009 9:19 PM
>To: linux-tip-commits@vger.kernel.org
>Cc: linux-kernel@vger.kernel.org; hpa@zytor.com; mingo@redhat.com; a.p.zijlstra@chello.nl; Metzger,
>Markus T; tglx@linutronix.de; mingo@elte.hu
>Subject: [tip:perfcounters/core] x86, perf_counter, bts: Optimize BTS overflow handling
>
>Commit-ID:  5622f295b53fb60dbf9bed3e2c89d182490a8b7f
>Gitweb:     http://git.kernel.org/tip/5622f295b53fb60dbf9bed3e2c89d182490a8b7f
>Author:     Markus Metzger <markus.t.metzger@intel.com>
>AuthorDate: Tue, 15 Sep 2009 13:00:23 +0200
>Committer:  Ingo Molnar <mingo@elte.hu>
>CommitDate: Fri, 18 Sep 2009 20:43:20 +0200
>
>x86, perf_counter, bts: Optimize BTS overflow handling
>
>Draining the BTS buffer on a buffer overflow interrupt takes too
>long resulting in a kernel lockup when tracing the kernel.
>
>Restructure perf_counter sampling into sample creation and sample
>output.
>
>Prepare a single reference sample for BTS sampling and update the
>from and to address fields when draining the BTS buffer. Drain the
>entire BTS buffer between a single perf_output_begin() /
>perf_output_end() pair.
>
>Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
>Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>LKML-Reference: <20090915130023.A16204@sedona.ch.intel.com>
>Signed-off-by: Ingo Molnar <mingo@elte.hu>


Ingo,

This change should speed up BTS overflow handling enough to support
branch tracing the kernel.
Would you please drop 1653192f510bd8114b7b133d7289e6e5c3e95046
that disabled kernel tracing to work around the issue.

thanks and regards,
markus.

---------------------------------------------------------------------Intel GmbHDornacher Strasse 185622 Feldkirchen/Muenchen GermanySitz der Gesellschaft: Feldkirchen bei MuenchenGeschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes SchwadererRegistergericht: Muenchen HRB 47456 Ust.-IdNr.VAT Registration No.: DE129385895Citibank Frankfurt (BLZ 502 109 00) 600119052
This e-mail and any attachments may contain confidential material forthe sole use of the intended recipient(s). Any review or distributionby others is strictly prohibited. If you are not the intendedrecipient, please contact the sender and delete all copies.ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
