Return-Path: <linux-kernel-owner+w=401wt.eu-S1755505AbYJUA0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbYJUA0T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 20:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752850AbYJUA0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 20:26:07 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:55102 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818AbYJUA0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 20:26:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=cWWG1oKwDIxMzG+AsbPsfpCOfE4/h2ElDAYlxXETkOGED9skC683t7sPHmKp8DVIpA
         GlNo22mvKh3mqGRuGqdR1KqQrTK93hMlvYw+zYdxDsDNJPFPX4RrSQbapxrVYaL/F8Xw
         bQX/FBa32I6uAScltgSbQaj77yK+cKKbRdppc=
Message-ID: <c62985530810201726w17ac4249h71c8feeb00fcd0e9@mail.gmail.com>
Date: Tue, 21 Oct 2008 02:26:04 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sparc: correct section of current_pc()
Cc: "William L. Irwin" <wli@holomorphy.com>,
       Sparc <sparclinux@vger.kernel.org>
In-Reply-To: <48FA0F7C.9040507@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48FA0F7C.9040507@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/18 Frederic Weisbecker <fweisbec@gmail.com>:
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
> ---
> diff --git a/arch/sparc/kernel/head.S b/arch/sparc/kernel/head.S
> index 2d325fd..2fe2c11 100644
> --- a/arch/sparc/kernel/head.S
> +++ b/arch/sparc/kernel/head.S
> @@ -465,6 +465,7 @@ gokernel:
>                mov     %o7, %g4                ! Save %o7
>
>                /* Jump to it, and pray... */
> +               __INIT
>  current_pc:
>                call    1f
>                 nop
>
>

(Adding William and sparclinux in cc)
