Return-Path: <linux-kernel-owner+w=401wt.eu-S1760566AbYFECwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760566AbYFECwN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 22:52:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472AbYFECv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 22:51:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53246 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750769AbYFECv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 22:51:57 -0400
Date: Wed, 4 Jun 2008 19:51:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [-mmotm] build failure: undefined reference to
 `wakeup_preempt_entity'
Message-Id: <20080604195101.12206292.akpm@linux-foundation.org>
In-Reply-To: <48475117.9070508@cn.fujitsu.com>
References: <48475117.9070508@cn.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Jun 2008 10:36:07 +0800 Li Zefan <lizf@cn.fujitsu.com> wrote:

> kernel/built-in.o: In function `pick_next':
> /home/lizf/linux-2.6.26-rc4/kernel/sched_fair.c:738: undefined reference to `wakeup_preempt_entity'
> kernel/built-in.o: In function `check_preempt_wakeup':
> /home/lizf/linux-2.6.26-rc4/kernel/sched_fair.c:1194: undefined reference to `wakeup_preempt_entity'
> 
> This patch:
> 	sched-delete-dead-stuff.patch
> 
> 	------------------------------------------------
> 	From: Andrew Morton <akpm@linux-foundation.org>
> 
> 	kernel/sched_fair.c:1170: warning: 'wakeup_preempt_entity' defined but not used
> 
> 	Cc: Ingo Molnar <mingo@elte.hu>
> 	Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 
> But I can see this function is used in sched_fair.c.

OK, thanks, that function must have become undead since I last did a
test build.

wakeup_gran() also seems to have been resurrected, so
sched-delete-dead-stuff-2.patch is no longer needed either.

