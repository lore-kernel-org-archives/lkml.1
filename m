Return-Path: <linux-kernel-owner+w=401wt.eu-S1761932AbYENIY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761932AbYENIY4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 04:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758259AbYENIYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 04:24:38 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55018 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758308AbYENIYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 04:24:37 -0400
Message-ID: <482AA16D.7060200@cn.fujitsu.com>
Date: Wed, 14 May 2008 16:23:09 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "xemul@openvz.org" <xemul@openvz.org>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>,
       "hugh@veritas.com" <hugh@veritas.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC/PATCH 4/6] memcg: shmem reclaim helper
References: <20080514170236.23c9ddd7.kamezawa.hiroyu@jp.fujitsu.com>	<20080514171025.2f0fb1ca.kamezawa.hiroyu@jp.fujitsu.com>	<482A9FB5.4020202@cn.fujitsu.com> <20080514172531.672e0447.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080514172531.672e0447.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Wed, 14 May 2008 16:15:49 +0800
> Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
>>> +	while(!progress && --retry) {
>>> +		progress = try_to_free_mem_cgroup_pages(mem, gfp_mask);
>>> +	}
>> This is wrong. How about:
>> 	do {
>> 		...
>> 	} while (!progress && --retry);
>>
> Ouch, or retry--....
> 

retry-- is still wrong, because then after while, retry will be -1, and then:

+	if (!retry)
+		return -ENOMEM;

> Thank you for catching.
> 

