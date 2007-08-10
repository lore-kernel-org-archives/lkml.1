Return-Path: <linux-kernel-owner+w=401wt.eu-S933747AbXHJBHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933747AbXHJBHX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 21:07:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764616AbXHJBHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 21:07:05 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:47968 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764262AbXHJBHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 21:07:03 -0400
Date: Thu, 9 Aug 2007 20:06:59 -0500
From: Dean Nelson <dcn@sgi.com>
To: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, tony.luck@intel.com, jes@sgi.com
Subject: [RFC 0/3] SGI Altix cross partition memory (XPMEM)
Message-ID: <20070810010659.GA25427@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
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

