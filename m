Return-Path: <linux-kernel-owner+w=401wt.eu-S932586AbYEVE0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932586AbYEVE0a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 00:26:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765091AbYEVEZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 00:25:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39880 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760331AbYEVEZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 00:25:09 -0400
Date: Wed, 21 May 2008 21:24:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, Pavel Emelianov <xemul@openvz.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [-mm][PATCH 4/4] Add memrlimit controller accounting and
 control (v5)
Message-Id: <20080521212408.6f535259.akpm@linux-foundation.org>
In-Reply-To: <20080521153012.15001.96490.sendpatchset@localhost.localdomain>
References: <20080521152921.15001.65968.sendpatchset@localhost.localdomain>
	<20080521153012.15001.96490.sendpatchset@localhost.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008 21:00:12 +0530 Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> 
> This patch adds support for accounting and control of virtual address space
> limits. The accounting is done via the rlimit_cgroup_(un)charge_as functions.
> The core of the accounting takes place during fork time in copy_process(),
> may_expand_vm(), remove_vma_list() and exit_mmap(). 
> 
> Changelog v5->v4
> 
> Move specific hooks in code to insert_vm_struct
> Use mmap_sem to protect mm->owner from changing and mm->owner from
> changing cgroups.
> 
> ...
>
> + * brk(), sbrk()), stack expansion, mremap(), etc - called with
> + * mmap_sem held.
> + * decreasing - called with mmap_sem held.
> + * This callback is called with mmap_sem held

It's good to document the locking prerequisites but for rwsems, one
should specify whether it must be held for reading or for writing.

Of course, down_write() is a superset of down_read(), so if it's "held
for reading" then either mode-of-holding is OK.  But it's best to spell
all that out.

