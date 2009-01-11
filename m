Return-Path: <linux-kernel-owner+w=401wt.eu-S1753446AbZAKNGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbZAKNGm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 08:06:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751617AbZAKNGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 08:06:33 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:32916 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbZAKNGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 08:06:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=jOfS+UPZOGFcpRAT0ZSknBGG8PjokZWe8+mnN60tZaPRYlgAunjysCOstrIIB4wp82
         LaMq9AUzsbuHtFd/Z/AaoAu0KXIJAszpuA5QI3aVoS1cuM+J/lJ/MaP2xw950F2c1XZR
         +HMpCHZ8WPT1HXvXqR6pEucwySp8uM+Li6qPU=
Message-ID: <3f9a31f40901110506v646bd599q863be03accbfd8b2@mail.gmail.com>
Date: Sun, 11 Jan 2009 18:36:31 +0530
From: "Jaswinder Singh Rajput" <jaswinderlinux@gmail.com>
To: "Petr Titera" <P.Titera@century.cz>
Subject: Re: Build error on latest git
Cc: linux-kernel@vger.kernel.org,
       "Jaswinder Singh Rajput" <jaswinder@infradead.org>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <4969DEA0.5020301@century.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4969C096.9060909@century.cz> <4969DEA0.5020301@century.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2009 at 5:27 PM, Petr Titera <P.Titera@century.cz> wrote:
> Going through source it seems to me (still building) that it is caused by
> including asm/smp.h only if build with CONFIG_SMP. This patch seems to fix
> this
>
> diff --git a/include/linux/smp.h b/include/linux/smp.h
> index b824669..fd51bb9 100644
> --- a/include/linux/smp.h
> +++ b/include/linux/smp.h
> @@ -11,6 +11,8 @@
> #include <linux/list.h>
> #include <linux/cpumask.h>
>
> +#include <asm/smp.h>
> +
> extern void cpu_idle(void);
>

No, this is wrong.

asm/smp.h should only be included when CONFIG_SMP is defined.

I will send fix of this.

--
JSR
