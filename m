Return-Path: <linux-kernel-owner+w=401wt.eu-S1752413AbYKGUiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413AbYKGUiK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 15:38:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752022AbYKGUh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 15:37:56 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:41796 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870AbYKGUhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 15:37:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZuV4FwQPwh/AtX2uOhMaL0vobieKGNy/pHsPcRMzeLlBKvLRVpzhEtjYb6G6RS6emy
         lX7xS/GZZfq4IZHvCUmC7kuVyRYaXzu9SizU321AnOry6xtzeA/Ydgub9oefh26KXQd+
         n0nEqmoReRXkxQrlgxd52CX2r5sLaXfhrxKXI=
Date: Fri, 7 Nov 2008 23:41:14 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Eduard Munteanu <eduard.munteanu@linux360.ro>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH-ugly] kmemtrace: casting a gfp_t requires __force
Message-ID: <20081107204114.GA4150@x200.localdomain>
References: <1226084321.11596.37.camel@brick> <20081107192029.GA4001@x200.localdomain> <1226085759.11596.43.camel@brick> <20081107193823.GA32761@Krystal> <1226087429.11596.53.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226087429.11596.53.camel@brick>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2008 at 11:50:29AM -0800, Harvey Harrison wrote:
> --- a/include/linux/kmemtrace.h
> +++ b/include/linux/kmemtrace.h
> @@ -31,10 +31,10 @@ static inline void kmemtrace_mark_alloc_node(enum kmemtrace_type_id type_id,
>  					     int node)
>  {
>  	trace_mark(kmemtrace_alloc, "type_id %d call_site %lu ptr %lu "
> -		   "bytes_req %lu bytes_alloc %lu gfp_flags %lu node %d",
> +		   "bytes_req %lu bytes_alloc %lu gfp_flags %u node %d",
>  		   type_id, call_site, (unsigned long) ptr,
>  		   (unsigned long) bytes_req, (unsigned long) bytes_alloc,
> -		   (unsigned long) gfp_flags, node);
> +		   gfp_flags, node);

All other casts are bogus too.
