Return-Path: <linux-kernel-owner+w=401wt.eu-S1757025AbYDYBBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757025AbYDYBBY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 21:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753864AbYDYBBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 21:01:14 -0400
Received: from mga11.intel.com ([192.55.52.93]:24935 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753353AbYDYBBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 21:01:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,706,1199692800"; 
   d="scan'208";a="321090920"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: [2.6 patch] ia64: let NUMA select SMP
Date: Thu, 24 Apr 2008 18:01:10 -0700
Message-ID: <1FE6DD409037234FAB833C420AA843EC012F9FAD@orsmsx424.amr.corp.intel.com>
In-Reply-To: <20080425004139.GE18854@cs181133002.pp.htv.fi>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [2.6 patch] ia64: let NUMA select SMP
Thread-Index: AcimbT+j2bK8f3QeSKOpVwApoWrRYgAARTag
References: <1FE6DD409037234FAB833C420AA843EC012F9EF0@orsmsx424.amr.corp.intel.com> <20080425001652.GD18854@cs181133002.pp.htv.fi> <1FE6DD409037234FAB833C420AA843EC012F9F55@orsmsx424.amr.corp.intel.com> <20080425004139.GE18854@cs181133002.pp.htv.fi>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Adrian Bunk" <bunk@kernel.org>
Cc: <torvalds@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       <linux-ia64@vger.kernel.org>, "Mike Travis" <travis@sgi.com>,
       "Russ Anderson" <rja@sgi.com>
X-OriginalArrivalTime: 25 Apr 2008 01:01:11.0873 (UTC) FILETIME=[DA935B10:01C8A66F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m3P11hEB023347

> CONFIG_NUMA=y, CONFIG_SMP=n isn't a useful combination, so let NUMA 
> select SMP.

Yup.  That looks good.  Means that my allnoconfig will now
have SMP=y though :-(  Root of that is selecting GENERIC,
and I'm not sure there is a better choice.

Doesn't change the need for the patch to delete the #if NUMA
clause inside the SMP=n path though (your patch would make my
build work by forcing SMP=y ... so the build error would go
away ... but that doesn't make it OK to have #if NUMA code
inside the SMP=n clause).

This does make we wonder how much dead code is hidden inside
impossibly nested #ifdefs elsewhere in the kernel.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
