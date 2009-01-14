Return-Path: <linux-kernel-owner+w=401wt.eu-S1758481AbZANWVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758481AbZANWVt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 17:21:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752182AbZANWVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 17:21:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58619 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbZANWVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 17:21:39 -0500
Message-ID: <496E6585.8050505@zytor.com>
Date: Wed, 14 Jan 2009 14:21:57 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>,
       Markus Metzger <markus.t.metzger@intel.com>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org, harvey.harrison@gmail.com,
       sam@ravnborg.org, jaswinderrajput@gmail.com,
       Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Re: [patch 3/5] x86: headers cleanup - ptrace-abi.h
References: <20090114203745.285473388@gmail.com>> <496e4e23.0c07560a.5e4e.529c@mx.google.com>
In-Reply-To: <496e4e23.0c07560a.5e4e.529c@mx.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Okay, this one really looks wrong to me.

Markus, could you confirm if this was ever intended to be exported to 
userspace?  I suspect The Right Thing is simply to remove the #ifdef 
CONFIG_X86_TRACE_BTS here...

	-hpa


Cyrill Gorcunov wrote:
> Impact: cleanup
> 
> 'make headers_check' warn us about leaking of kernel private
> (mostly compile time vars) data to userspace in headers. Fix it.
> 
> ptrace_bts_config struct is wrapped by __KERNEL__ --
> not sure if it was ever proposed for userland. On the
> other hand branch tracing is really anxious for userland
> developers.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> ---
>  arch/x86/include/asm/ptrace-abi.h |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6.git/arch/x86/include/asm/ptrace-abi.h
> ===================================================================
> --- linux-2.6.git.orig/arch/x86/include/asm/ptrace-abi.h
> +++ linux-2.6.git/arch/x86/include/asm/ptrace-abi.h
> @@ -50,7 +50,7 @@
>  #define RSP 152
>  #define SS 160
>  #define ARGOFFSET R11
> -#endif /* __ASSEMBLY__ */
> +#endif /* __ASSEMBLY__ || __FRAME_OFFSETS */
>  
>  /* top of stack page */
>  #define FRAME_SIZE 168
> @@ -80,6 +80,7 @@
>  
>  #define PTRACE_SINGLEBLOCK	33	/* resume execution until next branch */
>  
> +#ifdef __KERNEL__
>  #ifdef CONFIG_X86_PTRACE_BTS
>  
>  #ifndef __ASSEMBLY__
> @@ -141,5 +142,6 @@ struct ptrace_bts_config {
>     Returns number of BTS records drained.
>  */
>  #endif /* CONFIG_X86_PTRACE_BTS */
> +#endif /* __KERNEL__ */
>  
>  #endif /* _ASM_X86_PTRACE_ABI_H */
> 
