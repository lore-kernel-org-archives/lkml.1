Return-Path: <linux-kernel-owner+w=401wt.eu-S1753762AbYH0Ebj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762AbYH0Ebj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 00:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752932AbYH0Eb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 00:31:29 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62343 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750904AbYH0Eb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 00:31:28 -0400
Message-ID: <48B4D81D.2040200@cn.fujitsu.com>
Date: Wed, 27 Aug 2008 12:29:17 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH] cgroup(fix critical bug): new handling for tasks file
References: <48B360CE.2010501@cn.fujitsu.com>	 <6599ad830808251929p10dfc9d2ub11e4db0cd4f9f3@mail.gmail.com>	 <48B39319.7070403@cn.fujitsu.com> <6599ad830808261544w308a850m865ac0c0a1552c77@mail.gmail.com>
In-Reply-To: <6599ad830808261544w308a850m865ac0c0a1552c77@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Mon, Aug 25, 2008 at 10:22 PM, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
>> It's complicated than necessary and change too much code IMO.
> 
> What about the problem that maintaining a single pid array can still
> fail for a really large cgroup? I guess we could just say "don't
> create such large cgroups" but someone's bound to want to do that.
> Perhaps use an array of pages rather than a single large kmalloc?
> 

Actually, I had a plan to write such a patch:
[RFC PATCH] cgroup,cpuset: use alternative malloc instead of kmalloc

The main idea is: when allocate size >= PAGE_SIZE, vmalloc will be used
instead. This will reduce the stress when continuous pages are few.
Alternative malloc is used for cgroup_tasks_open() and update_tasks_nodemask().


And vmalloc can malloc larger memory than kmalloc, is vmalloc() enough?
If not, I think using an array of pages is the best choice.

[There are several subsystem who use alternative malloc. kernel/relay.c
for example. relay.c is also using an array of pages for relay buffer. ]


   Lai

