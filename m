Return-Path: <linux-kernel-owner+w=401wt.eu-S1756361AbYF3IMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361AbYF3IMk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 04:12:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751872AbYF3IMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 04:12:30 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:40185 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbYF3IM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 04:12:29 -0400
Message-ID: <48689527.7070403@linux.vnet.ibm.com>
Date: Mon, 30 Jun 2008 13:41:19 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC 5/5] Memory controller soft limit reclaim on contention
References: <20080630161657.37E3.KOSAKI.MOTOHIRO@jp.fujitsu.com> <48688FCB.9040205@linux.vnet.ibm.com> <20080630165125.37E6.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20080630165125.37E6.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> yes, memcg used only one page.
> but mem_cgroup_reclaim_on_contention() reclaim for generic alloc_pages(), instead for memcg.
> we can't assume memcg usage.
> isn't it?

Yes, but the reclaim is from memcg pages (memcg groups that are over their soft
limit). I am not sure if I understand your point? If your claim is that we don't
free up pages of at-least order (as desired by __alloc_pages_internal()), that
is correct. We can ensure that we do a pass over memcg and generic zone LRU.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
