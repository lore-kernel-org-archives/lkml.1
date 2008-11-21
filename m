Return-Path: <linux-kernel-owner+w=401wt.eu-S1757475AbYKUScR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475AbYKUScR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 13:32:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751445AbYKUScD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 13:32:03 -0500
Received: from mga11.intel.com ([192.55.52.93]:18042 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026AbYKUScC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 13:32:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,645,1220252400"; 
   d="scan'208";a="642118383"
From: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
To: Matthew Wilcox <matthew@wil.cx>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@osdl.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Yinghai Lu <yhlu.kernel@gmail.com>
Date: Fri, 21 Nov 2008 10:31:59 -0800
Subject: RE: [PATCH] x86: Fix interrupt leak due to migration
Thread-Topic: [PATCH] x86: Fix interrupt leak due to migration
Thread-Index: AclLVq48YYkR2c1US1mBi/iiNwjw5QAsHeiQ
Message-ID: <F169D4F5E1F1974DBFAFABF47F60C10A0EC28107@orsmsx507.amr.corp.intel.com>
References: <20081120210932.GW1617@parisc-linux.org>
In-Reply-To: <20081120210932.GW1617@parisc-linux.org>
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

Matthew Wilcox wrote:
> When we migrate an interrupt from one CPU to another, we set the
> move_in_progress flag and clean up the vectors later once they're not
> being used.  If you're unlucky and call destroy_irq() before the
> vectors become un-used, the move_in_progress flag is never cleared,
> which causes the interrupt to become unusable.
> 
> This was discovered by Jesse Brandeburg for whom it manifested as an
> MSI-X device refusing to use MSI-X mode when the driver was unloaded
> and reloaded repeatedly.
> 
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

We did some other quick testing on this and it seems good.  Thanks 
and good work Matthew!

Acked-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
