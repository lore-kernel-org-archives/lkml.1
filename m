Return-Path: <linux-kernel-owner+w=401wt.eu-S932554AbYF0XTH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932554AbYF0XTH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 19:19:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760754AbYF0XSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 19:18:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40308 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759336AbYF0XSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 19:18:53 -0400
Message-ID: <48657524.4020307@kernel.org>
Date: Fri, 27 Jun 2008 16:17:56 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Glauber Costa <gcosta@redhat.com>
CC: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
       x86@kernel.org
Subject: Re: [PATCH 08/39] don't use word-size specifiers
References: <1214602486-17080-1-git-send-email-gcosta@redhat.com> <1214602486-17080-2-git-send-email-gcosta@redhat.com> <1214602486-17080-3-git-send-email-gcosta@redhat.com> <1214602486-17080-4-git-send-email-gcosta@redhat.com> <1214602486-17080-5-git-send-email-gcosta@redhat.com> <1214602486-17080-6-git-send-email-gcosta@redhat.com> <1214602486-17080-7-git-send-email-gcosta@redhat.com> <1214602486-17080-8-git-send-email-gcosta@redhat.com> <1214602486-17080-9-git-send-email-gcosta@redhat.com>
In-Reply-To: <1214602486-17080-9-git-send-email-gcosta@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber Costa wrote:
> since the instructions refer to registers, they'll be able
> to figure it out.
> 
> Signed-off-by: Glauber Costa <gcosta@redhat.com>

> diff --git a/arch/x86/lib/getuser_32.S b/arch/x86/lib/getuser_32.S
> index 6d84b53..8200fde 100644
> --- a/arch/x86/lib/getuser_32.S
> +++ b/arch/x86/lib/getuser_32.S
> @@ -29,44 +29,44 @@
>  ENTRY(__get_user_1)
>  	CFI_STARTPROC
>  	GET_THREAD_INFO(%edx)
> -	cmpl TI_addr_limit(%edx),%eax
> +	cmp TI_addr_limit(%edx),%eax
>  	jae bad_get_user
> -1:	movzbl (%eax),%edx
> -	xorl %eax,%eax
> +1:	movzb (%eax),%edx
> +	xor %eax,%eax
>  	ret
>  	CFI_ENDPROC

I hate to say it, but I really think this is a step backwards in 
readability.  Consistency is a good thing, and with the suffixes in 
place we are consistent between instructions that refer to memory and 
instructions that refer to registers.  We also get one more check on 
things, where the assembler can tell the programmer he probably typoed.

So I would prefer if we *didn't* go down this route, except for explicit 
unification, but that's not the case here (since the size is still 
explicit in the register names.)

	-hpa
