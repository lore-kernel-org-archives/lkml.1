Return-Path: <linux-kernel-owner+w=401wt.eu-S1759304AbZDUSqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759304AbZDUSqP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 14:46:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759207AbZDUSpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 14:45:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:26335 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759225AbZDUSpb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 14:45:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,225,1239001200"; 
   d="scan'208";a="683580498"
From: "Luck, Tony" <tony.luck@intel.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>, Christoph Lameter <cl@linux.com>
CC: Nick Piggin <npiggin@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "randy.dunlap_ocs10g@oracle.com" <randy.dunlap_ocs10g@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mundt <lethal@linux-sh.org>,
       "iwamatsu.nobuhiro@renesas.com" <iwamatsu.nobuhiro@renesas.com>
Date: Tue, 21 Apr 2009 11:45:28 -0700
Subject: RE: linux-next ia64 build problems in slqb
Thread-Topic: linux-next ia64 build problems in slqb
Thread-Index: AcnCrpAqjVCdfooqRiqcLPk1QqhODwAASCDQ
Message-ID: <57C9024A16AD2D4C97DC78E552063EA39EC57748@orsmsx505.amr.corp.intel.com>
References: <49ecf25e2378234eed@agluck-desktop.sc.intel.com>
	 <84144f020904202251n616f188k80c6ce7d974d8b00@mail.gmail.com>
	 <alpine.DEB.1.10.0904211034550.19969@qirst.com>
 <84144f020904211125v68b98df4ke1c04bc29df65fda@mail.gmail.com>
In-Reply-To: <84144f020904211125v68b98df4ke1c04bc29df65fda@mail.gmail.com>
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

> Interesting. What exactly is an UP NUMA machine?

UP + NUMA is a special case of memory-only nodes.  There are
some (crazy?) customers with problems that require very large
amounts of memory, but not very much cpu horse power.  They
buy large multi-node systems and populate all the nodes with
as much memory as they can afford, but most nodes get zero
cpus.

The limit case with only one cpu is becoming rare (since
multi-core gives you more than one cpu even if you only
fill a single cpu socket).

N.B. Note that memory only nodes mean that it is a poor
idea for the "free" code to just place returned remote
memory on a queue for the node that it belongs to, and
rely on a "local" cpu processing that queue ... there may
not be any local cpus to do so.

> Anyway, I'm more than
> happy to apply a tested patch to fix up SLQB. Nick?

I'm trying to check whether http://lkml.org/lkml/2009/4/20/30
fixes things.  It certainly solves the complilation problem,
but I'm running into apparently unrelated issues trying to
boot linux-next kernels.

-Tony
