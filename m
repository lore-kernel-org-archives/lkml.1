Return-Path: <linux-kernel-owner+w=401wt.eu-S1753978AbYIAFpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbYIAFpR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 01:45:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751289AbYIAFpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 01:45:04 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57738 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750927AbYIAFpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 01:45:01 -0400
Message-ID: <48BB811D.6070106@cn.fujitsu.com>
Date: Mon, 01 Sep 2008 13:43:57 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelianov <xemul@openvz.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] res_counter: fix off-by-one bug in setting limit
References: <48BB78E7.5080001@cn.fujitsu.com> <20080901143007.9c623ef4.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080901143007.9c623ef4.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Mon, 01 Sep 2008 13:08:55 +0800
> Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
>> I found we can no longer set limit to 0 with 2.6.27-rcX:
>>  # mount -t cgroup -omemory xxx /mnt
>>  # mkdir /mnt/0
>>  # echo 0 > /mnt/0/memory.limit_in_bytes
>>  bash: echo: write error: Device or resource busy
>>
>> It turned out 'limit' can't be set to 'usage', which is wrong IMO.
>>
>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> 
> But setting limit to 0(usage) in memcg is buggy operation unless you want to see OOM..
> Hmm..
> 

I used to set 0 limit to test OOM in memcg. I don't think 0 limit is buggy, there's no
much difference with 0 limit and a very low limit.

And the real issue is, now we can set limit to > usage, but not >= usage. It's odd that
usage can reach to limit but limit can't be shrinked to usage.

