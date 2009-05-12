Return-Path: <linux-kernel-owner+w=401wt.eu-S1753957AbZELRBF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957AbZELRBF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 13:01:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754945AbZELRAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 13:00:40 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:50550 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754295AbZELRAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 13:00:39 -0400
Date: Tue, 12 May 2009 16:59:40 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Yinghai Lu <yinghai@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 2/3] x86: add numa_move_cpus_to_node
In-Reply-To: <4A089E53.8010106@kernel.org>
Message-ID: <alpine.DEB.1.10.0905121658140.14226@qirst.com>
References: <4A05269D.8000701@kernel.org> <4A052721.4010201@kernel.org> <alpine.DEB.1.10.0905112126410.28512@qirst.com> <4A089E53.8010106@kernel.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 May 2009, Yinghai Lu wrote:

> > This going to be fun for the allocators that have put their queues on the
> > respective nodes. How are the various OS structures that were allocated on
> > the node that is downed / upped relocated?
>
> NODE_DATA is new allocated on that node is backed on line for the first time.
>
> per_cpu will still stay with old near node. because per_cpu is somehow preallocated for all possible cpu.

Slab allocators and page allocator use neither NODE_DATA nor percpu

It may be best to bring the processors down and up again if the node
assignment changes. That will cause the allocators to reallocate the per
cpu resources on the right node.

