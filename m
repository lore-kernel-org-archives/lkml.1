Return-Path: <linux-kernel-owner+w=401wt.eu-S1753536AbYKMCrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbYKMCrf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 21:47:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750874AbYKMCr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 21:47:27 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:44389 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbYKMCr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 21:47:26 -0500
Date: Wed, 12 Nov 2008 21:47:25 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Pekka Paalanen <pq@iki.fi>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/1] ftrace: do not update max buffer with no users
In-Reply-To: <20081112183745.07af124d.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0811122145360.7458@gandalf.stny.rr.com>
References: <20081113013041.086583690@goodmis.org> <20081113013247.974941878@goodmis.org> <20081112183745.07af124d.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 12 Nov 2008, Andrew Morton wrote:
> 
> 
> This sort of thing:
> 
> +#ifdef CONFIG_TRACER_MAX_TRACE
>  	if (current_trace && current_trace->print_max)
>  		iter->tr = &max_tr;
>  	else
> +#endif
>  		iter->tr = inode->i_private;
> 
> is particularly regrettable.

Another answer is to not allocate it and check for NULL before using it. 
But this would mean that I would have to find all the places that touch it 
(the same as the ifdefs) and make sure they are safe.

The reason I picked the ifdefs was to guarantee that there were no users 
if it was not being used.

-- Steve

