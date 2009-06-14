Return-Path: <linux-kernel-owner+w=401wt.eu-S1759502AbZFNMfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759502AbZFNMfa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 08:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759167AbZFNMez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 08:34:55 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:49795 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758962AbZFNMex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 08:34:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Dt3HnN1JKUlRGAHSny6jra3co/CudyCevfqNsqTpXaQ5jI3/L3+9usWwLjhmj1KmOG
         ILhBWAONwR2fCKAvGiIkbTZpEvD+ZYKit2kOjYi7480cCfY88R7Kna8gMu8fdLpOmcnK
         pmXD8uX9enJV11ye0EPwlCaFTbZyGRi22L+6A=
Date: Sun, 14 Jun 2009 14:34:52 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Wu Zhangjin <wuzhangjin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Linux-MIPS <linux-mips@linux-mips.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Ralf Baechle <ralf@linux-mips.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Wu Zhangjin <wuzj@lemote.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] tracing: fix undeclared 'PAGE_SIZE' in
	include/linux/trace_seq.h
Message-ID: <20090614123451.GA6039@nowhere>
References: <1244962350-28702-1-git-send-email-wuzhangjin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244962350-28702-1-git-send-email-wuzhangjin@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 14, 2009 at 02:52:30PM +0800, Wu Zhangjin wrote:
> From: Wu Zhangjin <wuzj@lemote.com>
> 
> when compiling linux-mips with kmemtrace enabled, there will be an
> error:
> 
> include/linux/trace_seq.h:12: error: 'PAGE_SIZE' undeclared here (not in
> 				a function)
> 
> I checked the source code and found trace_seq.h used PAGE_SIZE but not
> included the relative header file, so, fix it via adding the header file
> <asm/page.h>
> 
> Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
> Signed-off-by: Wu Zhangjin <wuzj@lemote.com>


Acked-by: Frederic Weisbecker <fweisbec@gmail.com>


> ---
>  include/linux/trace_seq.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/trace_seq.h b/include/linux/trace_seq.h
> index c68bccb..c134dd1 100644
> --- a/include/linux/trace_seq.h
> +++ b/include/linux/trace_seq.h
> @@ -3,6 +3,8 @@
>  
>  #include <linux/fs.h>
>  
> +#include <asm/page.h>
> +
>  /*
>   * Trace sequences are used to allow a function to call several other functions
>   * to create a string of data to use (up to a max of PAGE_SIZE.
> -- 
> 1.6.0.4
> 

