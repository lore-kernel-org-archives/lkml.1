Return-Path: <linux-kernel-owner+w=401wt.eu-S1752866AbYL3MlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbYL3MlO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 07:41:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751041AbYL3Mk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 07:40:59 -0500
Received: from mx2.redhat.com ([66.187.237.31]:33456 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886AbYL3Mk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 07:40:58 -0500
Date: Tue, 30 Dec 2008 10:40:17 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] kmemtrace: Use tracepoints instead of markers.
Message-ID: <20081230124017.GH28520@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	Dipankar Sarma <dipankar@in.ibm.com>,
	Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@elte.hu>,
	linux-kernel@vger.kernel.org
References: <cover.1230622068.git.eduard.munteanu@linux360.ro> <51a70358bfd74d84c844260d9b5b3ad6ac189d7d.1230622069.git.eduard.munteanu@linux360.ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51a70358bfd74d84c844260d9b5b3ad6ac189d7d.1230622069.git.eduard.munteanu@linux360.ro>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Dec 30, 2008 at 09:41:28AM +0200, Eduard - Gabriel Munteanu escreveu:
> kmemtrace now uses tracepoints instead of markers. We no longer need to
> use format specifiers. Also dropped kmemtrace_mark_alloc_node(), since
> it's easy to pass -1 as the NUMA node without providing a needless and
> long-named variant of the same function.
> 
> Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
> diff --git a/include/linux/slab_def.h b/include/linux/slab_def.h
> index 7555ce9..fe3cea2 100644
> --- a/include/linux/slab_def.h
> +++ b/include/linux/slab_def.h
> @@ -76,8 +76,8 @@ found:
>  
>  		ret = kmem_cache_alloc_notrace(cachep, flags);
>  
> -		kmemtrace_mark_alloc(KMEMTRACE_TYPE_KMALLOC, _THIS_IP_, ret,
> -				     size, slab_buffer_size(cachep), flags);
> +		trace_kmalloc(_THIS_IP_, ret,
> +			      size, slab_buffer_size(cachep), flags, -1);

Is there a way for a tracepoint to get the caller without having to pass
it explicitely?

- Arnaldo
