Return-Path: <linux-kernel-owner+w=401wt.eu-S1758406AbZBLLvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758406AbZBLLvu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 06:51:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756201AbZBLLvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 06:51:41 -0500
Received: from cmpxchg.org ([85.214.51.133]:37972 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755349AbZBLLvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 06:51:41 -0500
Message-Id: <20090212113609.351980834@cmpxchg.org>
User-Agent: quilt/0.47-1
Date: Thu, 12 Feb 2009 12:36:09 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [patch 0/2] vmscan: one cleanup, one bugfix
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

the first patch is from KOSAKI Motohiro, it moves the suspend-to-disk memory
shrinking functions to use sc.nr_reclaimed all over instead of maintaining
an extra local variable.

The second patch is a bugfix for shrink_all_memory() which currently does
reclaim more than requested because of setting swap_cluster_max once to our
overall reclaim goal but failing to decrease it while we go and reclaim is
making progress.  Added Nigel Cunningham to Cc because ISTR he complained
about exactly this behaviour.  Well, this patch seems to fix it, I even
added some shiny numbers coming from real tests!

	Hannes

 mm/vmscan.c |   51 ++++++++++++++++++++++++---------------------------
 1 files changed, 24 insertions(+), 27 deletions(-)

