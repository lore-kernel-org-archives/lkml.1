Return-Path: <linux-kernel-owner+w=401wt.eu-S1760168AbYGQBnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760168AbYGQBnq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 21:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754442AbYGQBnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 21:43:37 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:57623 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753106AbYGQBng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 21:43:36 -0400
To: a.p.zijlstra@chello.nl
Cc: kamezawa.hiroyu@jp.fujitsu.com, linux-mm@kvack.org, menage@google.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC] dirty balancing for cgroups
In-Reply-To: Your message of "Mon, 14 Jul 2008 15:49:04 +0200"
	<1216043344.12595.89.camel@twins>
References: <1216043344.12595.89.camel@twins>
X-Mailer: Cue version 0.8 (080625-0732/takashi)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Message-Id: <20080717014335.ED78A5A22@siro.lan>
Date: Thu, 17 Jul 2008 10:43:35 +0900 (JST)
From: yamamoto@valinux.co.jp (YAMAMOTO Takashi)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

> Now the problem this patch tries to address...
> 
> As you can see you'd need p_{bdi,cgroup,task} for it to work, and the
> obvious approximation p_bdi * p_cgroup * p_task will get even more
> coarse.
> 
> You could possibly attempt to do p_{bdi,cgroup} * p_task since the bdi
> and cgroup set are pretty static, but still that would be painful.

i chose min(p_bdi * p_cgroup, p_bdi * p_task) because i couldn't imagine
a case where p_bdi * p_cgroup * p_task is better.

> So, could you please give some more justification for this work, I'm not
> seeing the value in complicating all this just yet.

a simple example for which my patch can make some sense is:

	while :;do dd if=/dev/zero of=file conv=notrunc bs=4096 count=1;done

YAMAMOTO Takashi
