Return-Path: <linux-kernel-owner+w=401wt.eu-S1765517AbXJZUlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765517AbXJZUlf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 16:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765292AbXJZUkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 16:40:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:56365 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753325AbXJZUkn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 16:40:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,335,1188802800"; 
   d="scan'208";a="256419592"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [RFC PATCH 0/2] Fix linux/swap.h build wart
Date: Fri, 26 Oct 2007 13:38:12 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A02C9D4B6@scsmsx411.amr.corp.intel.com>
In-Reply-To: <20071026192548.GA9174@c2.user-mode-linux.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [RFC PATCH 0/2] Fix linux/swap.h build wart
Thread-Index: AcgYC3aj/sIWVb66SROq7DEjvjtONQAAh3fg
References: <20071026192548.GA9174@c2.user-mode-linux.org>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Jeff Dike" <jdike@addtoit.com>, "LKML" <linux-kernel@vger.kernel.org>,
       <linux-fsdevel@vger.kernel.org>, <linux-arch@vger.kernel.org>
X-OriginalArrivalTime: 26 Oct 2007 20:38:13.0055 (UTC) FILETIME=[20E60CF0:01C81810]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> These patches propose to break the recursion instead by removing the
> linux/pagemap.h -> linux/highmem.h inclusion.  I'd like to know
> whether there are any fundamental reasons that this include should be
> preserved.

Not fundamental reasons, but these patches break the ia64 build for most
configs with:

In file included from kernel/futex.c:59:
include/asm/futex.h: In function `futex_atomic_op_inuser':
include/asm/futex.h:62: error: implicit declaration of function `pagefault_disable'
include/asm/futex.h:86: error: implicit declaration of function `pagefault_enable'
make[1]: *** [kernel/futex.o] Error 1

Adding an include of <linux/uaccess.h> to kernel/futex.c is sufficient (but
not necessarily right) to unbreak this.

A few configs also fail with:
mm/migrate.c: In function `migrate_page_copy':
mm/migrate.c:359: error: implicit declaration of function `copy_highpage'
make[1]: *** [mm/migrate.o] Error 1

Making mm/migrate.c include <linux/highmem.h> fixes this one.

-Tony
