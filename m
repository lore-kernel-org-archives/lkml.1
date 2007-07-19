Return-Path: <linux-kernel-owner+w=401wt.eu-S938263AbXGSOmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938263AbXGSOmY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 10:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764546AbXGSOmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 10:42:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35786 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762435AbXGSOmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 10:42:07 -0400
Message-ID: <469F7838.9000201@redhat.com>
Date: Thu, 19 Jul 2007 10:42:00 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [2/58] x86_64: Tell gcc to only align stack to 8 bytes
References: <200707191154.642492000@suse.de> <20070719095445.DC94514E04@wotan.suse.de>
In-Reply-To: <20070719095445.DC94514E04@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2007 05:54 AM, Andi Kleen wrote:
> Don't need 16 byte alignment because kernel doesn't use SSE2
> 
> Signed-off-by: Andi Kleen <ak@suse.de>
> 
> ---
>  arch/x86_64/Makefile |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: linux/arch/x86_64/Makefile
> ===================================================================
> --- linux.orig/arch/x86_64/Makefile
> +++ linux/arch/x86_64/Makefile
> @@ -55,6 +55,7 @@ cflags-y += $(call cc-option,-mno-sse -m
>  # this works around some issues with generating unwind tables in older gccs
>  # newer gccs do it by default
>  cflags-y += -maccumulate-outgoing-args
> +cflags-y += -mpreferred-stack-boundary=4

Should be:

+cflags-y += -mpreferred-stack-boundary=3

>  
>  # do binutils support CFI?
>  cflags-y += $(call as-instr,.cfi_startproc\n.cfi_endproc,-DCONFIG_AS_CFI=1,)
