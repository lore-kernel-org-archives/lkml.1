Return-Path: <linux-kernel-owner+w=401wt.eu-S936513AbXG3AtJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936513AbXG3AtJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 20:49:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758203AbXG3As5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 20:48:57 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:32700 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758076AbXG3As5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 20:48:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fdkLmS80QCUgE1ce3OSo69tFuSCzLUkndhoTqpfCjVRcV3dukSVWXQRTd6KVNqNRDOjLUme8I0EJiwgr7+jOxmEIUOonXqhdHbUUkI9xmfAMuXOkRuXfjS1Jj9qXm8gVZXdOPPlEEXOnHx9qv+WNL59MaGFntg2I73aijiDKqD8=
Message-ID: <a781481a0707291748x5a70c2d3i83ef54d7f2336b33@mail.gmail.com>
Date: Mon, 30 Jul 2007 06:18:56 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Rusty Russell" <rusty@rustcorp.com.au>
Subject: Re: [PATCH] Make lguest compile with CONFIG_BLOCK=n and CONFIG_NET=n
Cc: "Gabriel C" <nix.or.die@googlemail.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       virtualization@lists.osdl.org
In-Reply-To: <1185755123.12151.102.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46ACAFBF.6060609@googlemail.com>
	 <1185755123.12151.102.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/30/07, Rusty Russell <rusty@rustcorp.com.au> wrote:
> [...]
> Gabriel C reports lguest doesn't compile with CONFIG_BLOCK=n.  Fix
> this by introducing a config var for the block device, which depends
> on LGUEST && BLOCK.  Do the same for the net driver, rather then
> depending gratuitously on CONFIG_NET.
> [...]
> diff -r 9e987fcabb16 drivers/lguest/Kconfig
> --- a/drivers/lguest/Kconfig    Mon Jul 30 09:47:25 2007 +1000
> +++ b/drivers/lguest/Kconfig    Mon Jul 30 10:03:39 2007 +1000
> @@ -1,6 +1,6 @@ config LGUEST
>  config LGUEST
>         tristate "Linux hypervisor example code"
> -       depends on X86 && PARAVIRT && NET && EXPERIMENTAL && !X86_PAE
> +       depends on X86 && PARAVIRT && EXPERIMENTAL && !X86_PAE
>         select LGUEST_GUEST
>         select HVC_DRIVER
>         ---help---
> @@ -18,3 +18,11 @@ config LGUEST_GUEST
>           The guest needs code built-in, even if the host has lguest
>           support as a module.  The drivers are tiny, so we build them
>           in too.
> +
> +config LGUEST_NET
> +       tristate
> +       depends on LGUEST_GUEST && NET

default y ?

> +
> +config LGUEST_BLOCK
> +       tristate
> +       depends on LGUEST_GUEST && BLOCK

default y ?

I /think/ the default "y" would also automatically become "m" if any of the
dependencies are modules ... probably need to test this, though.


Satyam
