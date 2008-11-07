Return-Path: <linux-kernel-owner+w=401wt.eu-S1753390AbYKGXGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbYKGXGY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 18:06:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752241AbYKGXGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 18:06:16 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:64208 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbYKGXGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 18:06:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent:sender;
        b=bDrXi7KZmUvBQ+rdr73ac8+AtrQG5lVkGVMmRJt8n476/CiR2OEpqSqDQn5yXKkKV8
         BczU0aAORJr60AE7CVw7sUaszcYV5hTXequB8MfylY+FBk6bqDtOz37Zb4nghlZBUquW
         X82eHhrY1mGb+d+T/bR4WwYfJtme078yb5vQg=
Date: Sat, 8 Nov 2008 01:06:29 +0200
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH-ugly] kmemtrace: casting a gfp_t requires __force
Message-ID: <20081107230629.GC5210@localhost>
References: <1226084321.11596.37.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226084321.11596.37.camel@brick>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2008 at 10:58:41AM -0800, Harvey Harrison wrote:
> gfp_t is a bitwise type, casting to unsigned long produces a
> warning.  Suppress it with __force.
> 
> Otherwise sparse complains thusly:
> include/linux/kmemtrace.h:33:2: warning: cast from restricted gfp_t
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
> Eduard, this is a local patch I've had sitting around in my sparse testing
> tree.  I'm really not sure what the appropriate format specifier is for a
> gfp_t, but I don't think the trace infrastructure has support for it
> anyway...so if you are going to keep casting to unsigned long you'll need
> this...perhaps with a comment why added.
> 
>  include/linux/kmemtrace.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/kmemtrace.h b/include/linux/kmemtrace.h
> index 5bea8ea..9d82085 100644
> --- a/include/linux/kmemtrace.h
> +++ b/include/linux/kmemtrace.h
> @@ -34,7 +34,7 @@ static inline void kmemtrace_mark_alloc_node(enum kmemtrace_type_id type_id,
>  		   "bytes_req %lu bytes_alloc %lu gfp_flags %lu node %d",
>  		   type_id, call_site, (unsigned long) ptr,
>  		   (unsigned long) bytes_req, (unsigned long) bytes_alloc,
> -		   (unsigned long) gfp_flags, node);
> +		   (__force unsigned long)gfp_flags, node);
>  }
>  
>  static inline void kmemtrace_mark_free(enum kmemtrace_type_id type_id,
> -- 
> 1.6.0.3.756.gb776d
> 
>

Sorry, the commit name is okay, my mistake.

