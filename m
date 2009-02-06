Return-Path: <linux-kernel-owner+w=401wt.eu-S1756205AbZBFSmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205AbZBFSmc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 13:42:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752758AbZBFSmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 13:42:23 -0500
Received: from mga09.intel.com ([134.134.136.24]:51378 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752614AbZBFSmW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 13:42:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,392,1231142400"; 
   d="scan'208";a="487937208"
From: "Luck, Tony" <tony.luck@intel.com>
To: Alex Chiang <achiang@hp.com>
CC: "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
       "stable@kernel.org" <stable@kernel.org>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Date: Fri, 6 Feb 2009 10:42:07 -0800
Subject: RE: [PATCH] ia64: prevent irq migration race in __cpu_disable path
Thread-Topic: [PATCH] ia64: prevent irq migration race in __cpu_disable path
Thread-Index: AcmIdyLRu9kZvdXOSYeGPI+/zsIb1gAEylJQ
Message-ID: <57C9024A16AD2D4C97DC78E552063EA36121A469@orsmsx505.amr.corp.intel.com>
References: <20090206162213.GD8208@ldl.fc.hp.com>
In-Reply-To: <20090206162213.GD8208@ldl.fc.hp.com>
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

> This is wrong because fixup_irqs calls migrate_irqs, and in
> migrate_irqs, we use the cpu_online_map to:
>
>       1. look for interrupts on current CPU
>       2. if we find one, move it to the first available CPU in
>       the cpu_online_map
>
> This means we can potentially migrate an interrupt off ourself
> back to... ourself. Uh oh.

Should we make migrate_irqs smarter then ... does any caller really
expect that it would "migrate" the irq to the same cpu?

-Tony
