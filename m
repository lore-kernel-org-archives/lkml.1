Return-Path: <linux-kernel-owner+w=401wt.eu-S1754895AbYKVDDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895AbYKVDDu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 22:03:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbYKVDDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 22:03:40 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58976 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750794AbYKVDDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 22:03:40 -0500
Message-ID: <492775ED.1040803@cn.fujitsu.com>
Date: Sat, 22 Nov 2008 11:01:01 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH] cpuset: rcu_read_lock() to protect task_cs() even we
 	don't dereference to task_cs()'s return value
References: <49267624.70305@cn.fujitsu.com>	 <6599ad830811211105p711aebc3v85ffffbc399bdd6e@mail.gmail.com> <6599ad830811211107n141e6cb5n2abf14e59110d764@mail.gmail.com>
In-Reply-To: <6599ad830811211107n141e6cb5n2abf14e59110d764@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Fri, Nov 21, 2008 at 11:05 AM, Paul Menage <menage@google.com> wrote:
>> Wouldn't this be fixed by your patch that adds an rcu_read_lock() to
>> task_subsys_state() ?
>>
> 
> Sorry, your other patch actually adds the rcu_read_lock() to
> task_cgroup(). But adding an rcu_read_lock() to task_subsys_state()
> would also help here.

Adding an rcu_read_lock() to task_subsys_state() also help here.
But task_subsys_state() is used in fast path.

If we add an implicit rcu_read_lock() in task_subsys_state(),
we still need rcu_read_lock()/task_lock() for using it,
so it's redundant rcu_read_lock(), and slower the fast path a little.

Lai.

