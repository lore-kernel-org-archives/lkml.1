Return-Path: <linux-kernel-owner+w=401wt.eu-S934548AbXHJVT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934548AbXHJVT6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 17:19:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932191AbXHJVTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 17:19:34 -0400
Received: from mga01.intel.com ([192.55.52.88]:39805 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764929AbXHJVTb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 17:19:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,246,1183359600"; 
   d="scan'208";a="279390258"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH 9/24] make atomic_read() behave consistently on ia64
Date: Fri, 10 Aug 2007 14:19:29 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A0224C777@scsmsx411.amr.corp.intel.com>
In-Reply-To: <46BCC1AF.5050204@redhat.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 9/24] make atomic_read() behave consistently on ia64
Thread-Index: Acfbh9QJtlFN9VLxTKq1o0TFtVPa0QAC+19A
References: <20070809135107.GA15985@shell.boston.redhat.com> <617E1C2C70743745A92448908E030B2A02213B3C@scsmsx411.amr.corp.intel.com> <46BCC1AF.5050204@redhat.com>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Chris Snook" <csnook@redhat.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
       <torvalds@linux-foundation.org>, <netdev@vger.kernel.org>,
       <akpm@linux-foundation.org>, <ak@suse.de>, <heiko.carstens@de.ibm.com>,
       <davem@davemloft.net>, <schwidefsky@de.ibm.com>, <wensong@linux-vs.org>,
       <horms@verge.net.au>, <wjiang@resilience.com>, <cfriesen@nortel.com>,
       <zlynx@acm.org>, <rpjday@mindspring.com>, <jesper.juhl@gmail.com>
X-OriginalArrivalTime: 10 Aug 2007 21:19:30.0959 (UTC) FILETIME=[240971F0:01C7DB94]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> That's distressing.  I'm about to resubmit with a volatile cast in 
> atomic_set as well, since people expect that behavior and I've been 
> shown a legitimate case where it could matter.  Does the assembly look 
> right with that cast in atomic_set() as well?

No.  With the casts to volatile in atomic_set and atomic64_set I
still see places where ld8 is changed to ld4 + sign-extend.

-Tony
