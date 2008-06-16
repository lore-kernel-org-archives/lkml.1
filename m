Return-Path: <linux-kernel-owner+w=401wt.eu-S1757138AbYFPJF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757138AbYFPJF2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 05:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756397AbYFPJFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 05:05:12 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60438 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbYFPJFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 05:05:11 -0400
From: kamezawa.hiroyu@jp.fujitsu.com
Message-ID: <400765.1213607050433.kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 16 Jun 2008 18:04:10 +0900 (JST)
To: balbir@linux.vnet.ibm.com
Subject: Re: Re: [PATCH 1/6] res_counter:  handle limit change
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>, menage@google.com,
       xemul@openvz.org, yamamoto@valinux.co.jp, nishimura@mxp.nes.nec.co.jp,
       lizf@cn.fujitsu.com
In-Reply-To: <48562AFF.9050804@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: @nifty Webmail 2.0
References: <48562AFF.9050804@linux.vnet.ibm.com>
 <20080613182714.265fe6d2.kamezawa.hiroyu@jp.fujitsu.com> <20080613182924.c73fe9eb.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
>KAMEZAWA Hiroyuki wrote:
>> Add a support to shrink_usage_at_limit_change feature to res_counter.
>> memcg will use this to drop pages.
>> 
>> Change log: xxx -> v4 (new file.)
>>  - cut out the limit-change part from hierarchy patch set.
>>  - add "retry_count" arguments to shrink_usage(). This allows that we don't
>>    have to set the default retry loop count.
>>  - res_counter_check_under_val() is added to support subsystem.
>>  - res_counter_init() is res_counter_init_ops(cnt, NULL)
>> 
>> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> 
>
>Does shrink_usage() really belong to res_counters? Could a task limiter, a
>CPU/IO bandwidth controller use this callback? Resource Counters were designe
d
>to be generic and work across controllers. Isn't the memory controller a bett
er
>place for such ops.
>
Definitely No. I think counters which cannot be shrink should return -EBUSY
by shrink_usage() when it cannot do it. 

Thanks,
-Kame



