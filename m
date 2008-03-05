Return-Path: <linux-kernel-owner+w=401wt.eu-S933988AbYCEAl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933988AbYCEAl6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 19:41:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760343AbYCEAlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 19:41:32 -0500
Received: from hs-out-0708.google.com ([64.233.178.247]:55905 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759624AbYCEAlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 19:41:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=Cn8hVdzOn5ZhbVVx52SERE9WOrlwL08rTxBaU6jApu3zULEfpuOcHRpN8wFgFIpUuB5Yo+p5l8OnB1GHWrSED5INjTPoqVg3YU8DYnZaXef7uvk5FaZU9tBLdJOWlNjT9Wi88ldjExbeJSxSuMOx6l0SFCn5z9wd8xaxmSsgTy0=
Message-ID: <47CDE925.9090503@gmail.com>
Date: Wed, 05 Mar 2008 09:28:21 +0900
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [patch 16/20] non-reclaimable mlocked pages
References: <20080304225157.573336066@redhat.com> <20080304225227.780021971@redhat.com>
In-Reply-To: <20080304225227.780021971@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
From: minchan Kim <minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Rik.

There is a some trivial mistake.
It can cause compile error.

 >@@ -665,7 +677,12 @@ static int prep_new_page(struct page *pa
 >
 > 	page->flags &= ~(1 << PG_uptodate | 1 << PG_error | 1 << PG_readahead |
 > 			1 << PG_referenced | 1 << PG_arch_1 |
 >-			1 << PG_owner_priv_1 | 1 << PG_mappedtodisk);
 >+			1 << PG_owner_priv_1 | 1 << PG_mappedtodisk |
 >+#ifdef CONFIG_NORECLAIM_MLOCK
 >+//TODO take care of it here, for now.
 >+			1 << PG_mlocked
 >+#endif
 >+			);
 > 	set_page_private(page, 0);
 > 	set_page_refcounted(page);

we need to fix it.

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 78c3f94..f6d535f 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -677,10 +677,10 @@ static int prep_new_page(struct page *page, int 
order, gfp_t gfp_flags)

   page->flags &= ~(1 << PG_uptodate | 1 << PG_error | 1 << PG_readahead |
       1 << PG_referenced | 1 << PG_arch_1 |
-     1 << PG_owner_priv_1 | 1 << PG_mappedtodisk |
+     1 << PG_owner_priv_1 | 1 << PG_mappedtodisk
  #ifdef CONFIG_NORECLAIM_MLOCK
  //TODO take care of it here, for now.
-     1 << PG_mlocked
+     | 1 << PG_mlocked
  #endif
       );
   set_page_private(page, 0);

Thanks,
barrios.
