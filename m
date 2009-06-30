Return-Path: <linux-kernel-owner+w=401wt.eu-S1753574AbZF3Lm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574AbZF3Lm0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 07:42:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbZF3LmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 07:42:17 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:55142 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751508AbZF3LmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 07:42:16 -0400
Message-Id: <1246362139.20020.1322822615@webmail.messagingengine.com>
X-Sasl-Enc: kucQUJI79RAaalNf3kZ5uCe+WK+RjPaJyRSz7irN4eNc 1246362139
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Mike Galbraith" <efault@gmx.de>, "LKML" <linux-kernel@vger.kernel.org>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Cyrill Gorcunov" <gorcunov@gmail.com>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <1246359240.6103.34.camel@marge.simson.net>
Subject: Re: [patch] x86: fix arch/x86/lib/clear_page_64.S::clear_page_c
 annotation
In-Reply-To: <1246359240.6103.34.camel@marge.simson.net>
Date: Tue, 30 Jun 2009 13:42:19 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

I agree with the code, but I do have a remark...

The ENTRY() macro already includes the ALIGN, so you could get
rid of the preceding ALIGN. But it's just a neatness thing, because
two consecutive ALIGNS don't change the resulting binary.

At any rate:

Acked-by: Alexander van Heukelum <heukelum@fastmail.fm>

(maybe the x86-committer feels comfortable enough to remove the ALIGN ;)
)

On Tue, 30 Jun 2009 12:54:00 +0200, "Mike Galbraith" <efault@gmx.de>
said:
> x86: fix arch/x86/lib/clear_page_64.S::clear_page_c annotation.
> 
> Signed-off-by: Mike Galbraith <efault@gmx.de>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Alexander van Heukelum <heukelum@mailshack.com>
> Cc: Cyrill Gorcunov <gorcunov@gmail.com>
> LKML-Reference: <new-submission>
> 
> ---
>  arch/x86/lib/clear_page_64.S |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/arch/x86/lib/clear_page_64.S
> ===================================================================
> --- linux-2.6.orig/arch/x86/lib/clear_page_64.S
> +++ linux-2.6/arch/x86/lib/clear_page_64.S
> @@ -6,14 +6,14 @@
>   * rdi	page
>   */			
>  	ALIGN
> -clear_page_c:
> +ENTRY(clear_page_c)
>  	CFI_STARTPROC
>  	movl $4096/8,%ecx
>  	xorl %eax,%eax
>  	rep stosq
>  	ret
>  	CFI_ENDPROC
> -ENDPROC(clear_page)
> +ENDPROC(clear_page_c)
>  
>  ENTRY(clear_page)
>  	CFI_STARTPROC
> 
> 
