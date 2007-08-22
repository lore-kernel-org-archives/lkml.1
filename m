Return-Path: <linux-kernel-owner+w=401wt.eu-S933745AbXHVWQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933745AbXHVWQh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 18:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761396AbXHVWQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 18:16:28 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48681 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761367AbXHVWQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 18:16:27 -0400
Date: Wed, 22 Aug 2007 15:16:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Linux Containers <containers@lists.osdl.org>, devel@openvz.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Use helpers to obtain task pid in printks
Message-Id: <20070822151610.bcf60574.akpm@linux-foundation.org>
In-Reply-To: <46CC02E2.4020700@openvz.org>
References: <46CC02E2.4020700@openvz.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Aug 2007 13:33:22 +0400
Pavel Emelyanov <xemul@openvz.org> wrote:

> The task_struct->pid member is going to be deprecated, so start
> using the helpers (task_pid_nr/task_pid_vnr/task_pid_nr_ns) in 
> the kernel.
> 
> The first thing to start with is the pid, printed to dmesg - in 
> this case we may safely use task_pid_nr(). Besides, printks produce
> more (much more) than a half of all the explicit pid usage.
> 
> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
> 
> ---
> 
> Andrew, this patch changes many code in drivers and file systems,
> so it may cause many conflicts with other fixes in -mm tree. Is
> there any way I can help with it, e.g. split it into pieces, wait
> till another -mm tree or something else?

I think we just slam it all into the tree as-is.  There will be a few
places which ended up getting missed, but we can pick those up on a second
round and then we rename task_struct.pid to
task_struct.dont_use_me_directly_pid so that any remaining, future or
out-of-tree usages of ->pid get reliably broken.

