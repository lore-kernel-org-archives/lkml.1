Return-Path: <linux-kernel-owner+w=401wt.eu-S1753700AbXK0Gp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700AbXK0Gp1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 01:45:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751043AbXK0GpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 01:45:17 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58433 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750923AbXK0GpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 01:45:15 -0500
Date: Mon, 26 Nov 2007 22:44:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pierre Peiffer <pierre.peiffer@bull.net>
Cc: linux-kernel@vger.kernel.org, containers@lists.osdl.org
Subject: Re: [PATCH 2.6.24-rc3-mm1] IPC: consolidate sem_exit_ns(),
 msg_exit_ns and shm_exit_ns()
Message-Id: <20071126224438.df547263.akpm@linux-foundation.org>
In-Reply-To: <20071123175250.0f584913.pierre.peiffer@bull.net>
References: <20071123175250.0f584913.pierre.peiffer@bull.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Nov 2007 17:52:50 +0100 Pierre Peiffer <pierre.peiffer@bull.net> wrote:

> sem_exit_ns(), msg_exit_ns() and shm_exit_ns() are all called when an ipc_namespace is
> released to free all ipcs of each type.
> But in fact, they do the same thing: they loop around all ipcs to free them
> individually by calling a specific routine.
> 
> This patch proposes to consolidate this by introducing a common function, free_ipcs(),
> that do the job. The specific routine to call on each individual ipcs is passed as
> parameter. For this, these ipc-specific 'free' routines are reworked to take a
> generic 'struct ipc_perm' as parameter.

This conflicts in more-than-trivial ways with Pavel's
move-the-ipc-namespace-under-ipc_ns-option.patch, which was in
2.6.24-rc3-mm1.

