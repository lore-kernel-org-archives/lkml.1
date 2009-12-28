Return-Path: <linux-kernel-owner+w=401wt.eu-S1751466AbZL1DWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466AbZL1DWk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 22:22:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751111AbZL1DWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 22:22:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50394 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048AbZL1DWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 22:22:39 -0500
Message-ID: <4B38246C.3020209@redhat.com>
Date: Sun, 27 Dec 2009 22:22:20 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH -mmotm-2009-12-10-17-19] Prevent churning of zero page
 in LRU list.
References: <20091228115315.76b1ecd0.minchan.kim@barrios-desktop>
In-Reply-To: <20091228115315.76b1ecd0.minchan.kim@barrios-desktop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/27/2009 09:53 PM, Minchan Kim wrote:
>
> VM doesn't add zero page to LRU list.
> It means zero page's churning in LRU list is pointless.
>
> As a matter of fact, zero page can't be promoted by mark_page_accessed
> since it doesn't have PG_lru.
>
> This patch prevent unecessary mark_page_accessed call of zero page
> alghouth caller want FOLL_TOUCH.
>
> Signed-off-by: Minchan Kim<minchan.kim@gmail.com>

The code looks correct, but I wonder how frequently we run into
the zero page in this code, vs. how much the added cost is of
having this extra code in follow_page.

What kind of problem were you running into that motivated you
to write this patch?

-- 
All rights reversed.
