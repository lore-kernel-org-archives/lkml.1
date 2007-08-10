Return-Path: <linux-kernel-owner+w=401wt.eu-S1764395AbXHJW77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764395AbXHJW77 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 18:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753650AbXHJW7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 18:59:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:12452 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752095AbXHJW7q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 18:59:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,246,1183359600"; 
   d="scan'208";a="279420569"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH 9/24] make atomic_read() behave consistently on ia64
Date: Fri, 10 Aug 2007 15:59:44 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A0224C8D7@scsmsx411.amr.corp.intel.com>
In-Reply-To: <46BCE9F8.4060009@redhat.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 9/24] make atomic_read() behave consistently on ia64
Thread-Index: Acfbn9UhFk01w3aqTHeIYAbo/zeVAgAAM7AQ
References: <20070809135107.GA15985@shell.boston.redhat.com><617E1C2C70743745A92448908E030B2A02213B3C@scsmsx411.amr.corp.intel.com><46BCC1AF.5050204@redhat.com><617E1C2C70743745A92448908E030B2A0224C777@scsmsx411.amr.corp.intel.com> <jewsw3oyl8.fsf@sykes.suse.de> <617E1C2C70743745A92448908E030B2A0224C88B@scsmsx411.amr.corp.intel.com> <46BCE9F8.4060009@redhat.com>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Chris Snook" <csnook@redhat.com>
Cc: "Andreas Schwab" <schwab@suse.de>, <linux-kernel@vger.kernel.org>,
       <linux-arch@vger.kernel.org>, <torvalds@linux-foundation.org>,
       <netdev@vger.kernel.org>, <akpm@linux-foundation.org>, <ak@suse.de>,
       <heiko.carstens@de.ibm.com>, <davem@davemloft.net>,
       <schwidefsky@de.ibm.com>, <wensong@linux-vs.org>, <horms@verge.net.au>,
       <wjiang@resilience.com>, <cfriesen@nortel.com>, <zlynx@acm.org>,
       <rpjday@mindspring.com>, <jesper.juhl@gmail.com>
X-OriginalArrivalTime: 10 Aug 2007 22:59:45.0551 (UTC) FILETIME=[250359F0:01C7DBA2]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Possibly.  Either that or we've uncovered some latent bugs.  Maybe a 
> combination of the two.  Can you list those 19 changes so we can 
evaluate them?

Here are the functions in which they occur in the object file. You
may have to chase down some inlining to find the function that
actually uses atomic_*().

freeque
do_msgrcv
sk_free
sock_wfree
sock_rfree
sock_kmalloc
sock_kfree_s
sock_setsockopt
skb_release_data
__sk_stream_mem_reclaim
sk_tream_mem_schedule
sk_stream_rfree
sk_attach_filter
ip_frag_destroy * 2
ip_frag_queue * 2
ip_frag_reasm * 2

-Tony

