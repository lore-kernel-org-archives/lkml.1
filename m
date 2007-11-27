Return-Path: <linux-kernel-owner+w=401wt.eu-S1755355AbXK0ITv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbXK0ITv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 03:19:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751106AbXK0ITo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 03:19:44 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:46592 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbXK0ITn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 03:19:43 -0500
Message-ID: <474BD316.3030709@bull.net>
Date: Tue, 27 Nov 2007 09:19:34 +0100
From: Pierre Peiffer <pierre.peiffer@bull.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, containers@lists.osdl.org
Subject: Re: [PATCH 2.6.24-rc3-mm1] IPC: consolidate sem_exit_ns(), msg_exit_ns
 and shm_exit_ns()
References: <20071123175250.0f584913.pierre.peiffer@bull.net>	<20071126224438.df547263.akpm@linux-foundation.org> <20071126224636.ca1ef92e.akpm@linux-foundation.org>
In-Reply-To: <20071126224636.ca1ef92e.akpm@linux-foundation.org>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 27/11/2007 09:27:01,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 27/11/2007 09:27:03,
	Serialize complete at 27/11/2007 09:27:03
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Andrew Morton wrote:
> On Mon, 26 Nov 2007 22:44:38 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:
> 
>> On Fri, 23 Nov 2007 17:52:50 +0100 Pierre Peiffer <pierre.peiffer@bull.net> wrote:
>>
>>> sem_exit_ns(), msg_exit_ns() and shm_exit_ns() are all called when an ipc_namespace is
>>> released to free all ipcs of each type.
>>> But in fact, they do the same thing: they loop around all ipcs to free them
>>> individually by calling a specific routine.
>>>
>>> This patch proposes to consolidate this by introducing a common function, free_ipcs(),
>>> that do the job. The specific routine to call on each individual ipcs is passed as
>>> parameter. For this, these ipc-specific 'free' routines are reworked to take a
>>> generic 'struct ipc_perm' as parameter.
>> This conflicts in more-than-trivial ways with Pavel's
>> move-the-ipc-namespace-under-ipc_ns-option.patch, which was in
>> 2.6.24-rc3-mm1.
>>
> 
> err, no, it wasn't that patch.  For some reason your change assumes that
> msg_exit_ns() (for example) doesn't have these lines:
> 
>         kfree(ns->ids[IPC_MSG_IDS]);
>         ns->ids[IPC_MSG_IDS] = NULL;
> 
> in it.

Yes, in fact, I've made this patch on top of this one:
http://lkml.org/lkml/2007/11/22/49

As the patch mentioned by this previous thread was acked by Cedric and Pavel,
I've assumed that you will take both. But I've not made this clear, sorry.

-- 
Pierre
