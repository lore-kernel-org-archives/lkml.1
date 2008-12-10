Return-Path: <linux-kernel-owner+w=401wt.eu-S1756408AbYLJRVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756408AbYLJRVh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 12:21:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755357AbYLJRV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 12:21:29 -0500
Received: from mga03.intel.com ([143.182.124.21]:28395 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754916AbYLJRV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 12:21:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,748,1220252400"; 
   d="scan'208";a="88682945"
From: "Graham, David" <david.graham@intel.com>
To: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       Jiri Slaby <jirislaby@gmail.com>,
       "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
       David Miller <davem@davemloft.net>
CC: "Allan, Bruce W" <bruce.w.allan@intel.com>,
       "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
       "Ronciak, John" <john.ronciak@intel.com>,
       "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Date: Wed, 10 Dec 2008 09:21:10 -0800
Subject: RE: mmotm 2008-12-09-15-24: e1000e mutex contention
Thread-Topic: mmotm 2008-12-09-15-24: e1000e mutex contention
Thread-Index: AclayVzRRuSJcVBeTUeScPZ+h1lkUQAHVkJwAADQWEA=
Message-ID: <13830B75AD5A2F42848F92269B11996F0461C06A@orsmsx509.amr.corp.intel.com>
References: <493FC0C5.2070004@gmail.com>
 <F169D4F5E1F1974DBFAFABF47F60C10A175A6379@orsmsx507.amr.corp.intel.com>
In-Reply-To: <F169D4F5E1F1974DBFAFABF47F60C10A175A6379@orsmsx507.amr.corp.intel.com>
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
X-MIME-Autoconverted: from base64 to 8bit by alpha id mBAHLidq010070

Yes we've got a lot (about 150 on kernelmoops last time I looked), of these reports now, all warnings. They are different than the double-release of a mutex that was found & fixed Yesterday by Andrew Morton, as these are in-e1000e-driver warnings from a mutex_trylock(), and have not, as far as I know, been flagged by LOCKDEP. I am reviewing all the reports to see if the total set of warnings show that driver is at risk for a deadlock. If so, obviously we'll fix it. If not, we might just remove the trylock warning. 

Dave

-----Original Message-----
From: Brandeburg, Jesse 
Sent: Wednesday, December 10, 2008 8:50 AM
To: Jiri Slaby; Kirsher, Jeffrey T; David Miller
Cc: Allan, Bruce W; Waskiewicz Jr, Peter P; Ronciak, John; e1000-devel@lists.sourceforge.net; Andrew Morton; Linux kernel mailing list; Graham, David
Subject: RE: mmotm 2008-12-09-15-24: e1000e mutex contention

Jiri Slaby wrote:
> during bootup, I got ton of these:
>
> WARNING: at drivers/net/e1000e/ich8lan.c:413
> e1000_acquire_swflag_ich8lan+0x43/0xf0()
> Hardware name: To Be Filled By O.E.M.
> e1000e mutex contention. Owned by pid -1

I think these are probably due to akpm's patches yesterday.  I think 
they've already been dropped.  The original issue still exists however, as 
reported by Arjan (kerneloops) and others.

We have Dave Graham here working on this, he is not done yet but he is 
making progress.  We hope to have something to post soon.

Jesse
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
