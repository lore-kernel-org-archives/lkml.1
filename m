Return-Path: <linux-kernel-owner+w=401wt.eu-S1752578AbYJVE5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578AbYJVE5i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 00:57:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751068AbYJVE53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 00:57:29 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34483
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751008AbYJVE52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 00:57:28 -0400
Date: Tue, 21 Oct 2008 21:57:05 -0700 (PDT)
Message-Id: <20081021.215705.201578406.davem@davemloft.net>
To: fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: [PATCH] sparc: correct section of current_pc()
From: David Miller <davem@davemloft.net>
In-Reply-To: <48FA0FAD.4010308@gmail.com>
References: <48FA0FAD.4010308@gmail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Sat, 18 Oct 2008 18:32:45 +0200

[ sparclinux@vger.kernel.org CC:'d ]

> Latest mainline gives this section mismatch on sparc:
> 
> The function current_pc() references
> the variable __init no_sun4u_here.
> This is often because current_pc lacks a __init 
> annotation or the annotation of no_sun4u_here is wrong.
> 
> Since current_pc() is used only in early time, it is correct to
> put it in .init section.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

Also applied, thanks.

> diff --git a/arch/sparc/kernel/head.S b/arch/sparc/kernel/head.S
> index 2d325fd..2fe2c11 100644
> --- a/arch/sparc/kernel/head.S
> +++ b/arch/sparc/kernel/head.S
> @@ -465,6 +465,7 @@ gokernel:
>  		mov	%o7, %g4		! Save %o7
>  
>  		/* Jump to it, and pray... */
> +		__INIT
>  current_pc:
>  		call	1f
>  		 nop
