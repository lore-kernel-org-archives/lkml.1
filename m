Return-Path: <linux-kernel-owner+w=401wt.eu-S1755806AbZGJQDK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806AbZGJQDK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 12:03:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753322AbZGJQC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 12:02:59 -0400
Received: from mga11.intel.com ([192.55.52.93]:31551 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752214AbZGJQC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 12:02:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,378,1243839600"; 
   d="scan'208";a="473702349"
From: "Lu, Hongjiu" <hongjiu.lu@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Pavel Machek <pavel@ucw.cz>
CC: "John A. Gregor" <john.gregor@qlogic.com>,
       "ralph.campbell@qlogic.com" <ralph.campbell@qlogic.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "johng@diamond.mv.qlogic.com" <johng@diamond.mv.qlogic.com>
Date: Fri, 10 Jul 2009 09:02:54 -0700
Subject: RE: [PATCH] x86_64/__iowrite32_copy: don't use string move for PIO
 writes
Thread-Topic: [PATCH] x86_64/__iowrite32_copy: don't use string move for PIO
 writes
Thread-Index: AcoBcCavZ8o65Q1dTf2YKHQpF0myJwAB5bWQ
Message-ID: <8EA2C2C4116BF44AB370468FBF85A777FDC8066C@orsmsx504.amr.corp.intel.com>
References: <1246907224-22758-1-git-send-email-john.gregor@qlogic.com>
 <4A526CE6.30200@zytor.com>
 <4a526e77.IPiyTZWRWfll2+00%john.gregor@qlogic.com>
 <4A527EE4.1080102@zytor.com> <20090709231957.GC1469@ucw.cz>
 <4A575921.9030501@zytor.com>
In-Reply-To: <4A575921.9030501@zytor.com>
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
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n6AG3DXx026557

> Pavel Machek wrote:
> >> - the current code is fine as long as it doesn't cross from cached to
> >>   uncached memory, which it never should in any kind of sensible driver;
> >
> > Should we add a comment somewhere saying that is not permitted (and why)?
> 
> It sounds like what we should do is simply remove
> arch/x86/lib/iomap_copy_64.S, and probably add a comment to
> lib/iomap_copy.c stating that rep string instructions have been reported
> to cause anomalies when accessing WC memory, and that we rely on gcc not
> generating them due thanks to the volatiles in the implementation of
> __raw_writel().  H.J. Lu tells me that gcc will not generate string
> instructions for volatiles, and that the x86 gcc team considers that
> part of the definition for volatile.  (HJL: please correct if I got that
> incorrect.)
> 

That is correct. If it isn't the case, please open a gcc bug report.


H.J.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
