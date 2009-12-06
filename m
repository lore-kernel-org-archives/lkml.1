Return-Path: <linux-kernel-owner+w=401wt.eu-S1757923AbZLFVBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757923AbZLFVBo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 16:01:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932165AbZLFVBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 16:01:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757743AbZLFVBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 16:01:43 -0500
Message-ID: <4B1C1BB8.9080301@redhat.com>
Date: Sun, 06 Dec 2009 16:01:44 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Larry Woodman <lwoodman@redhat.com>
Subject: Re: [PATCH 6/7] wipe_page_reference return SWAP_AGAIN if VM pressulre
 is low and lock contention is detected.
References: <20091204173233.5891.A69D9226@jp.fujitsu.com> <20091204174439.58A3.A69D9226@jp.fujitsu.com>
In-Reply-To: <20091204174439.58A3.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2009 03:45 AM, KOSAKI Motohiro wrote:
>  From 3fb2a585729a37e205c5ea42ac6c48d4a6c0a29c Mon Sep 17 00:00:00 2001
> From: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
> Date: Fri, 4 Dec 2009 12:54:37 +0900
> Subject: [PATCH 6/7] wipe_page_reference return SWAP_AGAIN if VM pressulre is low and lock contention is detected.
>
> Larry Woodman reported AIM7 makes serious ptelock and anon_vma_lock
> contention on current VM. because SplitLRU VM (since 2.6.28) remove
> calc_reclaim_mapped() test, then shrink_active_list() always call
> page_referenced() against mapped page although VM pressure is low.
> Lightweight VM pressure is very common situation and it easily makes
> ptelock contention with page fault. then, anon_vma_lock is holding
> long time and it makes another lock contention. then, fork/exit
> throughput decrease a lot.

It looks good to me.   Larry, does this patch series resolve
your issue?

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
