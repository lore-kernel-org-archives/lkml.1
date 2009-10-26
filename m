Return-Path: <linux-kernel-owner+w=401wt.eu-S1754827AbZJZXfJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827AbZJZXfJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 19:35:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753675AbZJZXfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 19:35:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:63475 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984AbZJZXfG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 19:35:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,628,1249282800"; 
   d="scan'208";a="507744901"
From: "Luck, Tony" <tony.luck@intel.com>
To: Tejun Heo <tj@kernel.org>, Randy Dunlap <randy.dunlap@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, Jes Sorensen <jes@sgi.com>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Date: Mon, 26 Oct 2009 16:35:07 -0700
Subject: RE: [PATCH -next] ia64/sn: fix percpu warnings
Thread-Topic: [PATCH -next] ia64/sn: fix percpu warnings
Thread-Index: AcpWaYPNbj8x7szjQ+Gc3gJXRuuLTQAKtzXg
Message-ID: <57C9024A16AD2D4C97DC78E552063EA3E345953E@orsmsx505.amr.corp.intel.com>
References: <20091014163445.f0441473.sfr@canb.auug.org.au>
	 <20091014151003.0ef42973.randy.dunlap@oracle.com>
	 <4AD67C05.2030201@kernel.org>
 <12c511ca0910261124p64f2ad5emc88d00b9957482b3@mail.gmail.com>
In-Reply-To: <12c511ca0910261124p64f2ad5emc88d00b9957482b3@mail.gmail.com>
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

> WARNING: "per_cpu____sn_cnodeid_to_nasid" [drivers/misc/sgi-xp/xpc.ko] has no CRC!


Note that this warning goes away if I fix the mismatch declaration so
that we have:

DECLARE_PER_CPU(short, __sn_cnodeide_to_nasid[MAX_COMPACT_NODES]);
in arch.h

and

DEFINE_PER_CPU(short, __sn_cnodeide_to_nasid[MAX_COMPACT_NODES]);
in setup.c


-Tony
