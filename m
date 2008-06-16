Return-Path: <linux-kernel-owner+w=401wt.eu-S1761183AbYFPI6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761183AbYFPI6A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 04:58:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755359AbYFPI5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 04:57:51 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:57079 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755092AbYFPI5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 04:57:50 -0400
Message-ID: <48562AFF.9050804@linux.vnet.ibm.com>
Date: Mon, 16 Jun 2008 14:27:35 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "menage@google.com" <menage@google.com>,
       "xemul@openvz.org" <xemul@openvz.org>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 1/6] res_counter:  handle limit change
References: <20080613182714.265fe6d2.kamezawa.hiroyu@jp.fujitsu.com> <20080613182924.c73fe9eb.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080613182924.c73fe9eb.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> Add a support to shrink_usage_at_limit_change feature to res_counter.
> memcg will use this to drop pages.
> 
> Change log: xxx -> v4 (new file.)
>  - cut out the limit-change part from hierarchy patch set.
>  - add "retry_count" arguments to shrink_usage(). This allows that we don't
>    have to set the default retry loop count.
>  - res_counter_check_under_val() is added to support subsystem.
>  - res_counter_init() is res_counter_init_ops(cnt, NULL)
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 

Does shrink_usage() really belong to res_counters? Could a task limiter, a
CPU/IO bandwidth controller use this callback? Resource Counters were designed
to be generic and work across controllers. Isn't the memory controller a better
place for such ops.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
