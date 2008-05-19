Return-Path: <linux-kernel-owner+w=401wt.eu-S1760880AbYESMgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760880AbYESMgZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 08:36:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760312AbYESMfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 08:35:46 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:53734 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758490AbYESMfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 08:35:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=ujVYTiT8fNCMbsF843/YC59lEV/cZ9UujieH9Dcny88S7429NlYXHv/FO5GsDCAdVLIm8bOy4WZjD/ld89RGTwUnUSPKr7brqiXtynBRyh3INWdHdP6UyKBZG6j+WdjoSVy1dw/L5KAI3iBJycHbfjUncM4sO/cH2bU13BW95dM=
Message-ID: <4831741A.7090206@gmail.com>
Date: Mon, 19 May 2008 21:35:38 +0900
From: MinChan Kim <minchan.kim@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [patch 04/14] free swap space on swap-in/activation
References: <20080516183207.361608893@redhat.com> <20080516183224.259161900@redhat.com>
In-Reply-To: <20080516183224.259161900@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Rik.

I don't know where to send this patch. you or mm ?
I guess VM pageout patches didn't send mm-commits yet.

It made compile error in my system that didn't have swap device. 

----

Subject: [PATCH] Fix compile error about remove_exclusive_swap_page_ref

It happened compiled error when I removed CONFIG_SWAP in config file
It caused by new API that is 'remove_exclusive_swap_page_ref'.

Signed-off-by: MinChan Kim <minchan.kim@gmail.com>
---
 include/linux/swap.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 4c3a2ef..f34fdb6 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -390,6 +390,11 @@ static inline int remove_exclusive_swap_page(struct page *p)
 	return 0;
 }
 
+static inline int remove_exclusive_swap_page_ref(struct page *page)
+{
+	return 0;
+}
+
 static inline swp_entry_t get_swap_page(void)
 {
 	swp_entry_t entry;
-- 
1.5.4.3
