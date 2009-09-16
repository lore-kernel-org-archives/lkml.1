Return-Path: <linux-kernel-owner+w=401wt.eu-S1760180AbZIPXE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760180AbZIPXE7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 19:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755313AbZIPXE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 19:04:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45651 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755307AbZIPXEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 19:04:55 -0400
Date: Wed, 16 Sep 2009 16:03:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: mingo@elte.hu, rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] stop_machine: disable preempt in stop machine path
Message-Id: <20090916160358.7faadb5f.akpm@linux-foundation.org>
In-Reply-To: <4AB0933E.8020901@cn.fujitsu.com>
References: <4AB0933E.8020901@cn.fujitsu.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Sep 2009 15:26:54 +0800
Xiao Guangrong <xiaoguangrong@cn.fujitsu.com> wrote:

> We can disable preempt in stop_cpu(), It can reduce the cpu's waiting time
> and make stop_machine path faster.
> 

"it can"?  But does it?  Are there any measurements or observations to
back this up?

The kstop threads are already created with create_rt_workqueue() (which
has super-secret undocumented semantics which I have cleverly
discovered mean "use SCHED_FIFO").

So we won't be getting preempted here anyway?
