Return-Path: <linux-kernel-owner+w=401wt.eu-S1753807AbYJCQZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807AbYJCQZk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 12:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbYJCQZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 12:25:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:20561 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645AbYJCQZ2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 12:25:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,357,1220252400"; 
   d="scan'208";a="343509848"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [regression] Latest git has WARN_ON storm with e1000e driver
Date: Fri, 3 Oct 2008 09:25:06 -0700
Message-ID: <36D9DB17C6DE9E40B059440DB8D95F520655F9A0@orsmsx418.amr.corp.intel.com>
In-Reply-To: <alpine.LFD.2.00.0810030901170.3185@nehalem.linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [regression] Latest git has WARN_ON storm with e1000e driver
Thread-Index: AcklclV1sMtMG7WzQQWNjqGz5mRJMQAASPtg
References: <200810031041.49350.borntraeger@de.ibm.com> <200810031720.53923.borntraeger@de.ibm.com> <alpine.LFD.2.00.0810030825190.3262@nehalem.linux-foundation.org> <200810031755.55931.borntraeger@de.ibm.com> <alpine.LFD.2.00.0810030901170.3185@nehalem.linux-foundation.org>
From: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Christian Borntraeger" <borntraeger@de.ibm.com>
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Arjan van de Ven" <arjan@infradead.org>
X-OriginalArrivalTime: 03 Oct 2008 16:25:26.0177 (UTC) FILETIME=[A46C6110:01C92574]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> So this whole bug is actually because that debug test is just
> _broken_. It shouldn't be WARN_ON(preempt_count()), it should be
> 'might_sleep()', which does it right.
> 
> The right thing to check is "in_atomic() || irqs_disabled()".

okay, do you want me to post a patch?  I think Thomas is probably
offline due to fridaynightitis.  Change the code to:?

WARN_ON(in_atomic() || irqs_disabled);
 
> Duh. That was wasted effort for a buggy test.

Apologies for not catching it.
