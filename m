Return-Path: <linux-kernel-owner+w=401wt.eu-S1760322AbYAKG0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760322AbYAKG0A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 01:26:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759748AbYAKGZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 01:25:16 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58358 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759690AbYAKGZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 01:25:14 -0500
Date: Fri, 11 Jan 2008 15:24:34 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>
Subject: Re: [patch 05/19] split LRU lists into anon & file sets
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Lee Schermerhorn <Lee.Schermerhorn@hp.com>
In-Reply-To: <20080108210002.638347207@redhat.com>
References: <20080108205939.323955454@redhat.com> <20080108210002.638347207@redhat.com>
Message-Id: <20080111143627.FD64.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rik

> +static inline int is_file_lru(enum lru_list l)
> +{
> +	BUILD_BUG_ON(LRU_INACTIVE_FILE != 2 || LRU_ACTIVE_FILE != 3);
> +	return (l/2 == 1);
> +}

below patch is a bit cleanup proposal.
i think LRU_FILE is more clarify than "/2".

What do you think it?



Index: linux-2.6.24-rc6-mm1-rvr/include/linux/mmzone.h
===================================================================
--- linux-2.6.24-rc6-mm1-rvr.orig/include/linux/mmzone.h        2008-01-11 11:10:30.000000000 +0900
+++ linux-2.6.24-rc6-mm1-rvr/include/linux/mmzone.h     2008-01-11 14:40:31.000000000 +0900
@@ -147,7 +147,7 @@
 static inline int is_file_lru(enum lru_list l)
 {
        BUILD_BUG_ON(LRU_INACTIVE_FILE != 2 || LRU_ACTIVE_FILE != 3);
-       return (l/2 == 1);
+       return !!(l & LRU_FILE);
 }

 struct per_cpu_pages {



