Return-Path: <linux-kernel-owner+w=401wt.eu-S1753279Ab0ARCQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279Ab0ARCQ2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 21:16:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751405Ab0ARCQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 21:16:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37192 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358Ab0ARCQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 21:16:27 -0500
Message-ID: <4B53C466.4010103@redhat.com>
Date: Sun, 17 Jan 2010 21:16:06 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 2/3][v2] vmstat: add anon_scan_ratio field to zoneinfo
References: <20100118100359.AE22.A69D9226@jp.fujitsu.com>	 <28c262361001171747w450c8fd8j4daf84b72fb68e1a@mail.gmail.com>	 <20100118104910.AE2D.A69D9226@jp.fujitsu.com> <28c262361001171810w544614b7rdd3df0f984692f35@mail.gmail.com>
In-Reply-To: <28c262361001171810w544614b7rdd3df0f984692f35@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2010 09:10 PM, Minchan Kim wrote:

> Absoultely right. I missed that. Thanks.
> get_scan_ratio used lru_lock to get reclaim_stat->recent_xxxx.
> But, it doesn't used lru_lock to get ap/fp.
>
> Is it intentional? I think you or Rik know it. :)
> I think if we want to get exact value, we have to use lru_lock until
> getting ap/fp.
> If it isn't, we don't need lru_lock when we get the reclaim_stat->recent_xxxx.
>
> What do you think about it?

This is definately not intentional.

Getting race conditions in this code could throw off the
statistics by a factor 2.  I do not know how serious that
would be for the VM or whether (and how quickly) it would
self correct.

-- 
All rights reversed.
