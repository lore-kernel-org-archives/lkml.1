Return-Path: <linux-kernel-owner+w=401wt.eu-S1766653AbXEBT2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766653AbXEBT2Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 15:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993147AbXEBT2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 15:28:24 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:60195 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993144AbXEBT2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 15:28:23 -0400
X-Originating-Ip: 72.143.66.196
Date: Wed, 2 May 2007 15:27:58 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: dead CONFIG variables:  first in a series
Message-ID: <Pine.LNX.4.64.0705021524070.14127@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00, RCVD_IN_SORBS_DUL 20.00,
	UPPERCASE_25_50 0.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  and now, courtesy of my handy-dandy dead CONFIG variable spotter, we
have the first in a series of posts identifying CONFIG_ variables that
don't appear to be set anywhere in the configuration process, along
with a recursive grep showing where they're referenced.

  as a first example, restricting the search to the mm/ directory:

$ ../dead_config.sh mm
========== MAX_ACTIVE_REGIONS ==========
mm/page_alloc.c:  #ifdef CONFIG_MAX_ACTIVE_REGIONS
mm/page_alloc.c:    #define MAX_ACTIVE_REGIONS CONFIG_MAX_ACTIVE_REGIONS
mm/page_alloc.c:   * MAX_ACTIVE_REGIONS determines the maxmimum number of distinct
mm/page_alloc.c:    /* Allow an architecture to set MAX_ACTIVE_REGIONS to save memory */
mm/page_alloc.c:    #define MAX_ACTIVE_REGIONS CONFIG_MAX_ACTIVE_REGIONS
mm/page_alloc.c:      #define MAX_ACTIVE_REGIONS (MAX_NUMNODES*50)
mm/page_alloc.c:      #define MAX_ACTIVE_REGIONS 256
mm/page_alloc.c:  struct node_active_region __initdata early_node_map[MAX_ACTIVE_REGIONS];
mm/page_alloc.c:                          nr_nodemap_entries, MAX_ACTIVE_REGIONS);
mm/page_alloc.c:        if (i >= MAX_ACTIVE_REGIONS) {
mm/page_alloc.c:                                              MAX_ACTIVE_REGIONS);

  is it fair to say there's something strange going on here before i
run any more tests?

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
