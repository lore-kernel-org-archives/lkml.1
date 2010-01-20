Return-Path: <linux-kernel-owner+w=401wt.eu-S1751951Ab0ATSk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951Ab0ATSk4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 13:40:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751645Ab0ATSk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 13:40:56 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:54406 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524Ab0ATSkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 13:40:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=v+dA7C20oUmZRqXXKyb/oa8FvvCf7gQ+ep3mBSRwrub46doY3ZkplYybin/cv7e5cL
         5U7vZQgVFNsDtnATV8ZUTJ/RYfc3PAlMNDCKCDNa0gpaT9ZMyEBUSqdo3wlW7UA5TbWE
         6DFwnKAhMWLE39MLLPu2JjpTWUxp1ud3kB/GQ=
Date: Wed, 20 Jan 2010 19:40:50 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/6] tracing: Change trace_seq to use separate buffer
Message-ID: <20100120184046.GA6194@nowhere>
References: <4B556078.7000004@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B556078.7000004@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 19, 2010 at 03:34:16PM +0800, Lai Jiangshan wrote:
> @@ -3124,6 +3126,8 @@ waitagain:
>  	if (cnt >= PAGE_SIZE)
>  		cnt = PAGE_SIZE - 1;
>  
> +	trace_seq_reset(&iter->seq);
> +



So we actually add a trace_seq_reset here.
This should have been in the first patch, which drops
the memset, and eventually modified here, just to avoid
breaking things in the middle of a patchset.

Things were already broken though before the memset dropping
patch though in other ways, so it's not that important I guess...


The patch looks good.

