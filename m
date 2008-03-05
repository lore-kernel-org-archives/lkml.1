Return-Path: <linux-kernel-owner+w=401wt.eu-S1764422AbYCEAsF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764422AbYCEAsF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 19:48:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760739AbYCEArk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 19:47:40 -0500
Received: from wr-out-0506.google.com ([64.233.184.238]:51540 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757915AbYCEAri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 19:47:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=R+g1fseRoCQc3zjEam9nPlB6Rn21oIdkz16izeXEouM1SknUJqXV9oB2bhdAdlJP+xKVYzgvRvmH3gLp8+RW8hyPklsx2WQQqWrctTg50spvv184bIFi4GMIZu1SCeD5tL8v8F3nXhABYykFyV5ZqEQntn39/467ZTa/IYHwOQQ=
Message-ID: <47CDEA95.9050507@gmail.com>
Date: Wed, 05 Mar 2008 09:34:29 +0900
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [patch 11/20] No Reclaim LRU Infrastructure
References: <20080304225157.573336066@redhat.com> <20080304225227.455963956@redhat.com>
In-Reply-To: <20080304225227.455963956@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
From: minchan Kim <minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Rik.

This is another trivial thing.

 > /*
 >  * Drain pages out of the cpu's pagevecs.
 >  * Either "cpu" is the current CPU, and preemption has already been
 >@@ -353,6 +375,8 @@ void release_pages(struct page **pages,
 >
 > 		if (PageLRU(page)) {
 > 			struct zone *pagezone = page_zone(page);
 >+			int is_lru_page;
 >+
 > 			if (pagezone != zone) {
 > 				if (zone)
 > 					spin_unlock_irqrestore(&zone->lru_lock,

We don't use is_lru_page any more.
It cause warning at compile time.

We can remove is_lru_page local variable.
