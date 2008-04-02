Return-Path: <linux-kernel-owner+w=401wt.eu-S1758822AbYDBT23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758822AbYDBT23 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 15:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757282AbYDBT2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 15:28:23 -0400
Received: from smtp-out.google.com ([216.239.33.17]:43146 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755091AbYDBT2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 15:28:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=lny9CpOEKbj/uFc/eMlc3He1UZn9zs1FrIGu11r2Qc4mTEQeLI4C5j9q0luHxgOCl
	Ry0RGGllMrrmRYtFdNnjg==
Message-ID: <6599ad830804021227od74be74j696105eae67bd22a@mail.gmail.com>
Date: Wed, 2 Apr 2008 12:27:38 -0700
From: "Paul Menage" <menage@google.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [RFC][-mm] Add an owner to the mm_struct (v4)
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Pavel Emelianov" <xemul@openvz.org>, "Hugh Dickins" <hugh@veritas.com>,
       "Sudhir Kumar" <skumar@linux.vnet.ibm.com>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       "David Rientjes" <rientjes@google.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <47F2FCAE.7070401@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080401124312.23664.64616.sendpatchset@localhost.localdomain>
	 <20080402093157.e445acfb.kamezawa.hiroyu@jp.fujitsu.com>
	 <47F2FCAE.7070401@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 1, 2008 at 8:25 PM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>
>  > +assign_new_owner:
>  > +     rcu_read_unlock();
>  > +     BUG_ON(c == p);
>  > +     task_lock(c);
>  > +     if (c->mm != mm) {
>  > +             task_unlock(c);
>  > +             goto retry;
>  > +     }
>  > +     cgroup_mm_owner_callbacks(mm->owner, c);
>  > +     mm->owner = c;
>  > +     task_unlock(c);
>  > +}
>  > Why rcu_read_unlock() before changing owner ? Is it safe ?
>  >
>
>  It should be safe, since we take task_lock(), but to be doubly sure, we can drop
>  rcu read lock after taking the task_lock().
>

I agree with Kamezawa - the task can technically disappear as soon as
we leave the RCU critical section. (In practice, it'll only happen
with CONFIG_PREEMPT).

Paul
