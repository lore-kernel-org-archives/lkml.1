Return-Path: <linux-kernel-owner+w=401wt.eu-S1758737AbYDAQUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758737AbYDAQUY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 12:20:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755830AbYDAQT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 12:19:56 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:41151 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317AbYDAQTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 12:19:55 -0400
Message-ID: <47F25F8D.7080102@linux.vnet.ibm.com>
Date: Tue, 01 Apr 2008 21:45:09 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Paul Menage <menage@google.com>, Pavel Emelianov <xemul@openvz.org>,
       Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC][-mm] Add an owner to the mm_struct (v4)
References: <20080401124312.23664.64616.sendpatchset@localhost.localdomain> <84144f020804010900s5335988ai58546874a6a2f8bd@mail.gmail.com>
In-Reply-To: <84144f020804010900s5335988ai58546874a6a2f8bd@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> Hi,
> 
> On Tue, Apr 1, 2008 at 3:43 PM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>>  @@ -227,8 +227,9 @@ struct mm_struct {
>>         /* aio bits */
>>         rwlock_t                ioctx_list_lock;
>>         struct kioctx           *ioctx_list;
>>  -#ifdef CONFIG_CGROUP_MEM_RES_CTLR
>>  -       struct mem_cgroup *mem_cgroup;
>>  +#ifdef CONFIG_MM_OWNER
>>  +       struct task_struct *owner;      /* The thread group leader that */
>>  +                                       /* owns the mm_struct.          */
>>   #endif
> 
> Yes, please. This is useful for the revokeat() patches as well. I
> currently need a big ugly loop to scan each task so I can break COW of
> private pages.

Hi, Pekka,

It's good to know that this will be useful. I think understand your use case of
having to walk the entire tasklist to break COW of private pages, having the
owner information right in the mm_struct is definitely useful.


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
