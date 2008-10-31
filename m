Return-Path: <linux-kernel-owner+w=401wt.eu-S1753208AbYJaUXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208AbYJaUXS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 16:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbYJaUXB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 16:23:01 -0400
Received: from mga14.intel.com ([143.182.124.37]:9968 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174AbYJaUXA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 16:23:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,524,1220252400"; 
   d="scan'208";a="68594236"
From: "Luck, Tony" <tony.luck@intel.com>
To: Petr Tesarik <ptesarik@suse.cz>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>
Date: Fri, 31 Oct 2008 13:22:56 -0700
Subject: RE: [PATCH V2 0/2] enable irqs when waiting for rwlocks
Thread-Topic: [PATCH V2 0/2] enable irqs when waiting for rwlocks
Thread-Index: Ack7NgGmtI+/4bD9SKmaNAF+AkUyuwAX6sfA
Message-ID: <57C9024A16AD2D4C97DC78E552063EA35A7ED9D3@orsmsx505.amr.corp.intel.com>
References: <1224777451.11530.52.camel@elijah.suse.cz>
 <1225443142.6825.4.camel@elijah.suse.cz>
In-Reply-To: <1225443142.6825.4.camel@elijah.suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Any comments on my second patch series? Not even an Acked-by? Dislike of
> the concept? Should I post it again?

Better response to interrupts is good, but it comes at the
cost of longer latency acquiring the lock (in the case where
an interrupt happens while we are waiting for the lock, and
the lock is freed while we are off executing the interrupt
handler).

Any suggestions on how to measure the trade-off here?  Possibly
it doesn't matter because this may only be significant when
the lock is heavily contended and you are probably aleady
hosed in this case.

-Tony
