Return-Path: <linux-kernel-owner+w=401wt.eu-S1755959AbZBFTHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959AbZBFTHA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 14:07:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbZBFTGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 14:06:49 -0500
Received: from mga01.intel.com ([192.55.52.88]:41231 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782AbZBFTGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 14:06:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,392,1231142400"; 
   d="scan'208";a="663512077"
From: "Luck, Tony" <tony.luck@intel.com>
To: Brian Gerst <brgerst@gmail.com>
CC: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 6 Feb 2009 11:06:41 -0800
Subject: RE: [PATCH 2/5] percpu: Refactor percpu.h
Thread-Topic: [PATCH 2/5] percpu: Refactor percpu.h
Thread-Index: AcmIS7IUAxOpGujLTu6Z45+9mpaRUAAQJbag
Message-ID: <57C9024A16AD2D4C97DC78E552063EA36121A4D5@orsmsx505.amr.corp.intel.com>
References: <73c1f2160901181651w3dff5e2co762b767168416c92@mail.gmail.com>
	 <1232326345-3534-1-git-send-email-brgerst@gmail.com>
	 <1232326345-3534-2-git-send-email-brgerst@gmail.com>
	 <12c511ca0902051430w78ca10d9rf96804748ce6ea79@mail.gmail.com>
 <73c1f2160902060311k4be188f5nd6a43d085d0c4e7d@mail.gmail.com>
In-Reply-To: <73c1f2160902060311k4be188f5nd6a43d085d0c4e7d@mail.gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by alpha id n16J75wM021638

> Why does IA64 still have a special percpu section on UP?  Is there a
> particular reason why it can't degenerate to regular .data like every
> other arch?

There are a few per-cpu variables that are accessed in the machine
check handlers with MMU turned off[1], so access is in physical mode.
We handle this with the GET_THIS_PADDR() macro which computes the
address of percpu objects based on offsets from a special register
(ar.k3) that has the base physical address of the .data.percpu
section for this processor.  The addressing mode used here has
a limited offset, so if percpu variables are scattered throughout
.data we get link errors.

-Tony

[1] The MMU may have been the cause of the machine check.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
