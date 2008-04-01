Return-Path: <linux-kernel-owner+w=401wt.eu-S1760170AbYDAQAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760170AbYDAQAU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 12:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752805AbYDAQAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 12:00:05 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:60027 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbYDAQAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 12:00:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=bRQVQ38UTtWNUPVzJvNnWXF1pMKQ6Lfvkn+ZsHMdejNaGoYvpV5T4rMdL5svhvqEVmYzxUdGKcm5ohBn3mCkOcK9xxwBpY9q+a/KygzAxgxGSJKvIszAZ5DtqeN4alZC1I7rkqrDa9MnP8zOa5j8k3XAeAL9w+mdb5J0SgjU1M4=
Message-ID: <84144f020804010900s5335988ai58546874a6a2f8bd@mail.gmail.com>
Date: Tue, 1 Apr 2008 19:00:03 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Balbir Singh" <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC][-mm] Add an owner to the mm_struct (v4)
Cc: "Paul Menage" <menage@google.com>, "Pavel Emelianov" <xemul@openvz.org>,
       "Hugh Dickins" <hugh@veritas.com>,
       "Sudhir Kumar" <skumar@linux.vnet.ibm.com>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       "David Rientjes" <rientjes@google.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080401124312.23664.64616.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080401124312.23664.64616.sendpatchset@localhost.localdomain>
X-Google-Sender-Auth: 176494318ca95270
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Apr 1, 2008 at 3:43 PM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>  @@ -227,8 +227,9 @@ struct mm_struct {
>         /* aio bits */
>         rwlock_t                ioctx_list_lock;
>         struct kioctx           *ioctx_list;
>  -#ifdef CONFIG_CGROUP_MEM_RES_CTLR
>  -       struct mem_cgroup *mem_cgroup;
>  +#ifdef CONFIG_MM_OWNER
>  +       struct task_struct *owner;      /* The thread group leader that */
>  +                                       /* owns the mm_struct.          */
>   #endif

Yes, please. This is useful for the revokeat() patches as well. I
currently need a big ugly loop to scan each task so I can break COW of
private pages.
