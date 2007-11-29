Return-Path: <linux-kernel-owner+w=401wt.eu-S1763959AbXK2Vvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763959AbXK2Vvd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 16:51:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763820AbXK2VvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 16:51:19 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:50131 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763725AbXK2VvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 16:51:18 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: Cedric Le Goater <clg@fr.ibm.com>, Pavel Emelyanov <xemul@openvz.org>,
       Linux Containers <containers@lists.osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch -mm 2/4] mqueue namespace : add unshare support
References: <20071128163728.177495768@fr.ibm.com>
	<20071128164349.196734045@fr.ibm.com> <474DA61B.5030301@openvz.org>
	<474E944C.4020809@fr.ibm.com> <474F1D96.3060606@cs.columbia.edu>
Date: Thu, 29 Nov 2007 14:49:40 -0700
In-Reply-To: <474F1D96.3060606@cs.columbia.edu> (Oren Laadan's message of
	"Thu, 29 Nov 2007 15:14:14 -0500")
Message-ID: <m1d4tsbu2z.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oren Laadan <orenl@cs.columbia.edu> writes:

> Two comments:
>
> 1) Does it ever make any sense to clone the IPC namespace *without* doing
> so also for the MQ namespace or vice versa ?  Unless there is a good
> reason for doing so, a single CLONE_IPCMQ flag would suffice.

SYSVIPC and POSIX IPC are different, and I don't see any argument for why
they would be in the same namespace.  So for maintenance, testing, and
the fact that we have already shipped a stable version of the IPC
namespace and we would be breaking the ABI if we were to add messages
queues into it now.

Frankly I find it a shame that we had to do more then implement multiple
mounts of the mq filesystem to make this work.

In general when we use the filesystem namespace for new global objects
visible to user space is a design bug.

> 2) Before coming up with a new clone2() or other solution, what about the
> proposed (and debated) sys_indrect() -- if it gets merged it can provide
> the solution.

Bleh.  We have to have the flag parameters and modify all of the code anyway
so I'm not quite certain that sys_indirect make sense.

Certainly in this case if we have namespaces that can not be combined with
CLONE_THREAD we could double assign a field really easily.  Trouble is that
is just a bit icky.

Eric
