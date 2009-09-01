Return-Path: <linux-kernel-owner+w=401wt.eu-S1755381AbZIAXUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381AbZIAXUf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 19:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755354AbZIAXUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 19:20:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:21801 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755346AbZIAXUd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 19:20:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,314,1249282800"; 
   d="scan'208";a="444725074"
From: "Luck, Tony" <tony.luck@intel.com>
To: "Yu, Fenghua" <fenghua.yu@intel.com>, "'Jiri Bohac'" <jbohac@suse.cz>
CC: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "'linux-ia64@vger.kernel.org'" <linux-ia64@vger.kernel.org>
Date: Tue, 1 Sep 2009 16:20:34 -0700
Subject: RE: [RFC][PATCH] ia64: fix csum_ipv6_magic()
Thread-Topic: [RFC][PATCH] ia64: fix csum_ipv6_magic()
Thread-Index: AconWvEAa+4eQKLrQiy33kv/p2DeaQAyae7QAM1XKOA=
Message-ID: <57C9024A16AD2D4C97DC78E552063EA3E038D4AE@orsmsx505.amr.corp.intel.com>
References: <20090827211113.GA22793@midget.suse.cz>
 <A6AD88C3F2289247BE726C37303E1EB8B954B4A6@orsmsx505.amr.corp.intel.com>
In-Reply-To: <A6AD88C3F2289247BE726C37303E1EB8B954B4A6@orsmsx505.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>--- a/arch/ia64/lib/ip_fast_csum.S
>+++ b/arch/ia64/lib/ip_fast_csum.S
>@@ -96,20 +96,22 @@ END(ip_fast_csum)
> GLOBAL_ENTRY(csum_ipv6_magic)
> 	ld4	r20=[in0],4
> 	ld4	r21=[in1],4
>-	dep	r15=in3,in2,32,16
>+	zxt4	in3=in3

I think this zxt4 instruction have a typo.  You really want to zap the
high part on "in2" here (the "len") parameter.  "in3" contains the "proto"
argument, which is only 16-bits.  But any garbage in the high part on in3
will be dropped by the "dep" instruction later which only pulls out the low
16 bits from it.

So I think you meant to type:

	zxt4	in2=in2

Does this make sense?

-Tony
