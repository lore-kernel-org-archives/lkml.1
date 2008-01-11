Return-Path: <linux-kernel-owner+w=401wt.eu-S1760264AbYAKMwH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760264AbYAKMwH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 07:52:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757921AbYAKMv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 07:51:56 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:34401 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755785AbYAKMv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 07:51:56 -0500
Date: Fri, 11 Jan 2008 18:21:09 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Nick Piggin <npiggin@suse.de>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>
Subject: Re: [patch 18/19] account mlocked pages
Message-ID: <20080111125109.GC19814@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: Rik van Riel <riel@redhat.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Nick Piggin <npiggin@suse.de>,
	Lee Schermerhorn <lee.schermerhorn@hp.com>
References: <20080108205939.323955454@redhat.com> <20080108210019.684039300@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20080108210019.684039300@redhat.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rik van Riel <riel@redhat.com> [2008-01-08 15:59:57]:

The following patch is required to compile the code with
CONFIG_NORECLAIM enabled and CONFIG_NORECLAIM_MLOCK disabled.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index c8ccf8f..fb08ee8 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -88,6 +88,8 @@ enum zone_stat_item {
 	NR_NORECLAIM,	/*  "     "     "   "       "         */
 #ifdef CONFIG_NORECLAIM_MLOCK
 	NR_MLOCK,		/* mlock()ed pages found and moved off LRU */
+#else
+	NR_MLOCK=NR_ACTIVE_FILE,	/* avoid compiler errors... */
 #endif
 #else
 	NR_NORECLAIM=NR_ACTIVE_FILE,	/* avoid compiler errors in dead code */

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
