Return-Path: <linux-kernel-owner+w=401wt.eu-S1756879AbYBRGsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879AbYBRGsq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 01:48:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752217AbYBRGsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 01:48:36 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62716 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752862AbYBRGsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 01:48:35 -0500
Message-ID: <47B929EE.7080202@cn.fujitsu.com>
Date: Mon, 18 Feb 2008 14:47:10 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: YAMAMOTO Takashi <yamamoto@valinux.co.jp>, akpm@linux-foundation.org,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] memcgroup: fix typo in VM_BUG_ON()
References: <47B9223C.9020106@linux.vnet.ibm.com> <20080218062209.DA59B1E3C58@siro.lan> <47B923C8.3090904@linux.vnet.ibm.com>
In-Reply-To: <47B923C8.3090904@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> YAMAMOTO Takashi wrote:
>>> Li Zefan wrote:
>>>> No need for VM_BUG_ON(pc), since 'pc' is the list entry. This should
>>>> be VM_BUG_ON(page).
>>>>
>>>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
>>>> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>>> pc is of type page_cgroup and we use list_for_each_entry_safe_reverse. Not sure
>>> why we can't bug on pc.
>> pc is dereferenced before this VM_BUG_ON.
>>
>> YAMAMOTO Takashi
>>
> 
> OK, so the VM_BUG_ON needs to move to an earlier location. Agreed.
> 

No, 'pc' has been dereferenced in list_for_each_entry_safe_reverse().


#define list_for_each_entry_safe_reverse(pos, n, head, member)		\
	for (pos = list_entry((head)->prev, typeof(*pos), member),	\
		n = list_entry(pos->member.prev, typeof(*pos), member);	\
                               ^^^^^^^^^^^
	     &pos->member != (head); 					\
              ^^^^^^^^^^^
	     pos = n, n = list_entry(n->member.prev, typeof(*n), member))

