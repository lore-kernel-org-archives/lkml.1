Return-Path: <linux-kernel-owner+w=401wt.eu-S1756051AbXJAQCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbXJAQCT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 12:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbXJAQCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 12:02:07 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:44540 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbXJAQCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 12:02:05 -0400
Message-ID: <470119F6.2090104@fr.ibm.com>
Date: Mon, 01 Oct 2007 18:01:58 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Pavel Emelyanov <xemul@openvz.org>
CC: Andrew Morton <akpm@osdl.org>, Serge Hallyn <serue@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: Re: [PATCH 3/5] Move the IPC namespace under the option
References: <470112C7.8000803@openvz.org> <47011478.9030405@openvz.org>
In-Reply-To: <47011478.9030405@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelyanov wrote:
> Currently all the IPC namespace management code is in 
> ipc/util.c. I moved this code into ipc/namespace.c file
> which is compiled out when needed.
> 
> The linux/ipc_namespace.h file is used to store the
> prototypes of the functions in namespace.c and the stubs
> for NAMESPACES=n case. This is done so, because the stub
> for copy_ipc_namespace requires the knoweledge of the
> CLONE_NEWIPC flag, which is in sched.h. But the linux/ipc.h
> file itself in included into many many .c files via the
> sys.h->sem.h sequence so adding the sched.h into it will
> make all these .c depend on sched.h which is not that good.
> On the other hand the knowledge about the namespaces stuff 
> is required in 4 .c files only.
> 
> Besides, this patch compiles out some auxiliary functions
> from ipc/sem.c, msg.c and shm.c files. It turned out that
> moving these functions into namespaces.c is not that easy
> because they use many other calls and macros from the original
> file. Moving them would make this patch complicated. On the
> other hand all these functions can be consolidated, so I
> will make it separately a bit later.
> 
> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

Fine with me.

Acked-by: Cedric Le Goater <clg@fr.ibm.com>

Thanks !

C.
