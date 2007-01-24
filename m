Return-Path: <linux-kernel-owner+w=401wt.eu-S965635AbXAXE2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965635AbXAXE2X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 23:28:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965647AbXAXE2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 23:28:23 -0500
Received: from smtp.osdl.org ([65.172.181.24]:50741 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965635AbXAXE2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 23:28:22 -0500
Date: Tue, 23 Jan 2007 20:26:37 -0800
From: Andrew Morton <akpm@osdl.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ingo Molnar <mingo@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       ltt-dev@shafik.org, "Martin J. Bligh" <mbligh@mbligh.org>,
       Douglas Niehaus <niehaus@eecs.ku.edu>, systemtap@sources.redhat.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Richard J Moore <richardj_moore@uk.ibm.com>
Subject: Re: [PATCH 1/2] lockdep missing barrier()
Message-Id: <20070123202637.970e467b.akpm@osdl.org>
In-Reply-To: <20070116175624.GA16022@Krystal>
References: <20061220235216.GA28643@Krystal>
	<OFAB3D8A6C.1643F2D3-ON80257262.000581E4-80257262.00088F04@uk.ibm.com>
	<20070116175624.GA16022@Krystal>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jan 2007 12:56:24 -0500
Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> This patch adds a barrier() to lockdep.c lockdep_recursion updates. This
> variable behaves like the preemption count and should therefore use similar
> memory barriers.
> 
> This patch applies on 2.6.20-rc4-git3.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> 
> --- a/kernel/lockdep.c
> +++ b/kernel/lockdep.c
> @@ -166,12 +166,14 @@ static struct list_head chainhash_table[CHAINHASH_SIZE];
>  void lockdep_off(void)
>  {
>  	current->lockdep_recursion++;
> +	barrier();
>  }
>  
>  EXPORT_SYMBOL(lockdep_off);
>  
>  void lockdep_on(void)
>  {
> +	barrier();
>  	current->lockdep_recursion--;
>  }

I am allergic to undocumented barriers.  It is often unobvious what the
barrier is supposed to protect against, yielding mystifying code.  This is
one such case.

Please add code comments.
