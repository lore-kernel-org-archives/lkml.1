Return-Path: <linux-kernel-owner+w=401wt.eu-S1753494AbYKRV6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbYKRV6q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 16:58:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751938AbYKRV6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 16:58:38 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:47113 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbYKRV6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 16:58:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent:sender;
        b=SWHY8TQFEgDpHRXwg1pk9KB89LfOz9a0AVH0jKfQKRiFzAm1CtWMjgGRB01JZWxyVA
         tjT4iLg2P6DbVUMxQ1lDHjWs58ZXltqlhMuzvPNZ7TKEy149YmhZKCtDdZbcteGWqw/e
         0nGwfw1/VEW5inBX6LlIPCufInirjBvsbf3Uw=
Date: Tue, 18 Nov 2008 23:58:51 +0200
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] kmemtrace: gfp_t is an unsigned int, not an unsigned
	long
Message-ID: <20081118215851.GA5246@localhost>
References: <1227043903.13182.4.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227043903.13182.4.camel@brick>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2008 at 01:31:43PM -0800, Harvey Harrison wrote:
> As a bonus, gets rid of all the sparse warnings as you are casting a
> restricted type (gfp_t) without __force.
> 
> include/linux/kmemtrace.h:33:2: warning: cast from restricted gfp_t
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  include/linux/kmemtrace.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/kmemtrace.h b/include/linux/kmemtrace.h
> index 5bea8ea..80e9a7a 100644
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
>  }
>  
>  static inline void kmemtrace_mark_free(enum kmemtrace_type_id type_id,
> -- 
> 1.6.0.4.994.g16bd3e
> 
>

This is incomplete, because marker format also needs to be changed,
along with va_arg stuff from the probe function.

But thanks, I'll fix it and forward it to Pekka.


	Cheers,
	Eduard

