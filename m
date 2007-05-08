Return-Path: <linux-kernel-owner+w=401wt.eu-S1032038AbXEHUOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032038AbXEHUOl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 16:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968245AbXEHUOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 16:14:38 -0400
Received: from mga03.intel.com ([143.182.124.21]:30796 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967660AbXEHUOg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 16:14:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,506,1170662400"; 
   d="scan'208";a="225796901"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH Resend] - SN: validate smp_affinity mask on intr redirect
Date: Tue, 8 May 2007 13:14:26 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A01719BB8@scsmsx411.amr.corp.intel.com>
In-Reply-To: <20070508121945.3e8d29c1.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH Resend] - SN: validate smp_affinity mask on intr redirect
Thread-Index: AceRpdf/Z01TFyTzRPauhif4ebTN5wAByxSw
From: "Luck, Tony" <tony.luck@intel.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
CC: "John Keller" <jpk@sgi.com>, <linux-kernel@vger.kernel.org>,
       <steiner@sgi.com>, <linux-ia64@vger.kernel.org>
X-OriginalArrivalTime: 08 May 2007 20:14:27.0884 (UTC) FILETIME=[7ACAF6C0:01C791AD]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> It had a dopey little bug:
>
> -#define is_affinity_mask_valid() 1
> +#define is_affinity_mask_valid(val) 1

That would fix warnings on non-ia64 systems (which is
a step in the right direction).  But on ia64 I have
the

#define is_affinity_mask_valid is_affinity_mask_valid

in play at that point, so I have a real function call
which doesn't have an in-scope declaration, so I get:

kernel/irq/proc.c:49: warning: implicit declaration of function `is_affinity_mask_valid'

-Tony
