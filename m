Return-Path: <linux-kernel-owner+w=401wt.eu-S1759211AbXH0QBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759211AbXH0QBq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 12:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758058AbXH0P40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 11:56:26 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:48818 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758135AbXH0P4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 11:56:23 -0400
Date: Mon, 27 Aug 2007 10:56:22 -0500
From: Dean Nelson <dcn@sgi.com>
To: tony.luck@intel.com, akpm@linux-foundation.org
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, jes@sgi.com
Subject: [PATCH 0/4] SGI Altix cross partition memory (XPMEM)
Message-ID: <20070827155622.GA25589@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


    Terminology

The term 'partition', adopted by the SGI hardware designers and which
perculated up into the software, is used in reference to a single SSI
when multiple SSIs are running on a single Altix. An Altix running
multiple SSIs is said to be 'partitioned', whereas one that is running
only a single SSI is said to be 'unpartitioned'.

The term '[a]cross partition' refers to a functionality that spans between
two SSIs on a multi-SSI Altix. ('XP' is its abbreviation.)

    Introduction

This feature provides cross partition access to user memory (XPMEM) when
running multiple partitions on a single SGI Altix. XPMEM, like XPNET,
utilizes XPC to communicate between the partitions.

XPMEM allows a user process to identify portion(s) of its address space
that other user processes can attach (i.e. map) into their own address
spaces. These processes can be running on the same or a different
partition from the one whose memory they are attaching.

    Known Issues

XPMEM is not currently using the kthread API (which is also true for XPC)
because it was in the process of being changed to require a kthread_stop()
be done for every kthread_create() and the kthread_stop() couldn't be called
for a thread that had already exited. In talking with Eric Biederman, there
was some thought of creating a kthread_orphan() which would eliminate the
need for a call to kthread_stop() being required.
