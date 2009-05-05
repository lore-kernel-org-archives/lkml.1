Return-Path: <linux-kernel-owner+w=401wt.eu-S1759282AbZEEXvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759282AbZEEXvp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 19:51:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754075AbZEEXvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 19:51:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55269 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759061AbZEEXva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 19:51:30 -0400
Date: Tue, 5 May 2009 16:47:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: chrisw@sous-sol.org, roland@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] ptrace: ptrace_attach: check PF_KTHREAD +
 exit_state instead of ->mm
Message-Id: <20090505164733.54cd4ca4.akpm@linux-foundation.org>
In-Reply-To: <20090505224722.GA954@redhat.com>
References: <20090505224722.GA954@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 May 2009 00:47:22 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> - Add PF_KTHREAD check to prevent attaching to the kernel thread
>   with a borrowed ->mm.
> 
>   With or without this change we can race with daemonize() which
>   can set PF_KTHREAD or clear ->mm after ptrace_attach() does the
>   check, but this doesn't matter because reparent_to_kthreadd()
>   does ptrace_unlink().
> 
> - Kill "!task->mm" check. We don't really care about ->mm != NULL,
>   and the task can call exit_mm() right after we drop task_lock().
>   What we need is to make sure we can't attach after exit_notify(),
>   check task->exit_state != 0 instead.
> 

These patches make a mess of utrace-core.patch.  Do we really want to do that?
