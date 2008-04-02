Return-Path: <linux-kernel-owner+w=401wt.eu-S932278AbYDBVzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932278AbYDBVzg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 17:55:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932186AbYDBVxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 17:53:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:23295 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932180AbYDBVxr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 17:53:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,595,1199692800"; 
   d="scan'208";a="266632195"
X-MIMEOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [RFC 00/21] Generic show_mem()
Date: Wed, 2 Apr 2008 14:53:45 -0700
Message-ID: <1FE6DD409037234FAB833C420AA843ECF9DFC4@orsmsx424.amr.corp.intel.com>
In-reply-to: <12071682142640-git-send-email-hannes@saeurebad.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [RFC 00/21] Generic show_mem()
Thread-Index: AciVCbNLmh3h030/QRSKVAf7aZR2mAAAUIyw
References: <12071682142640-git-send-email-hannes@saeurebad.de>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Johannes Weiner" <hannes@saeurebad.de>, <linux-kernel@vger.kernel.org>
Cc: <linux-mm@kvack.org>, <mingo@elte.hu>, <davem@davemloft.net>,
       <hskinnemoen@atmel.com>, <cooloney@kernel.org>, <starvik@axis.com>,
       <dhowells@redhat.com>, <ysato@users.sourceforge.net>,
       <takata@linux-m32r.org>, <geert@linux-m68k.org>, <ralf@linux-mips.org>,
       <kyle@parisc-linux.org>, <paulus@samba.org>, <schwidefsky@de.ibm.com>,
       <lethal@linux-sh.org>, <jdike@addtoit.com>, <miles@gnu.org>,
       <chris@zankel.net>, <rmk@arm.linux.org.uk>
X-OriginalArrivalTime: 02 Apr 2008 21:53:46.0466 (UTC) FILETIME=[06B3EC20:01C8950C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Tony, as far as I understand, ia64 jumps holes in the memory map with
> vmemmap_find_next_valid_pfn().  Any idea if and how this could be
> built into the generic show_mem() version?

Perhaps it might be worth looking at this when ia64 slims down to
just one memory model (using sparse virtual mem map).  But I don't
think anyone is actively working on this.  Right now we have two
very different show_mem() functions for the contig and discontig
cases.

This whole function sends shivers down my spine for a large
system though ... that inner loop looks at every single page
structure ... on a multi-terabyte machine that could run to
billions of cache misses.  Hope the users aren't in a hurry
to see the answer ... or doing something painful like:

	# watch -n 1 cat /proc/meminfo

-Tony
