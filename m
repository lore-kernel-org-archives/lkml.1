Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673Ab0BVSgP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 13:36:15 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:46122 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554Ab0BVSgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 13:36:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LO2pLFAFBwH/73oasVPBNMDgL/GrSCvPUbXCQ6g+wkmsUMOdT79VLEymEU6GVl10h2
         c4Q8ofwPB4zBwdqqHeSxpVDyDG7QU2QL3ekkaFWkoIe4qOM5BpcsLAnU0ucajbYseAqA
         U6ZZrRjxH5ND9y2yUZ5uwetMSoeEpan4zDW+Q=
Date: Mon, 22 Feb 2010 19:36:09 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Rabin Vincent <rabin@rab.in>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH 03/10] ftrace: allow building without frame pointers
Message-ID: <20100222183607.GG5055@nowhere>
References: <1266090518-31120-1-git-send-email-rabin@rab.in> <1266090518-31120-4-git-send-email-rabin@rab.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266090518-31120-4-git-send-email-rabin@rab.in>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 14, 2010 at 01:18:31AM +0530, Rabin Vincent wrote:
> With current gcc, compiling with both -pg and -fomit-frame-pointer is
> not allowed.  However, -pg can be used to build without actually
> specying -fno-omit-frame-pointer, upon which the defaut behaviour for
> the target will be used.


Doh!....


 
> On ARM, it is not possible to build a Thumb-2 kernel with
> -fno-omit-frame-pointer (FRAME_POINTERS depends on !THUMB2_KERNEL). In
> order to support ftrace for Thumb-2, we need to be able to allow a
> combination of FUNCTION_TRACER and !FRAME_POINTER.  We do this by
> omitting -fomit-frame-pointer if ftrace is enabled.
> 
> Signed-off-by: Rabin Vincent <rabin@rab.in>



I might be missing something subtle on this one, but it looks
good to me.

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>



> ---
>  Makefile |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index 67d6cff..72d90de 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -546,8 +546,11 @@ endif
>  ifdef CONFIG_FRAME_POINTER
>  KBUILD_CFLAGS	+= -fno-omit-frame-pointer -fno-optimize-sibling-calls
>  else
> +ifndef CONFIG_FUNCTION_TRACER
> +# -fomit-frame-pointer is incompatible with -pg
>  KBUILD_CFLAGS	+= -fomit-frame-pointer
>  endif
> +endif
>  ifdef CONFIG_DEBUG_INFO
>  KBUILD_CFLAGS	+= -g
> -- 
> 1.6.6
> 

