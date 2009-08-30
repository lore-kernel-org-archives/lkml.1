Return-Path: <linux-kernel-owner+w=401wt.eu-S1753632AbZH3Nfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632AbZH3Nfl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 09:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753621AbZH3Nfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 09:35:41 -0400
Received: from mail-gx0-f205.google.com ([209.85.217.205]:53256 "EHLO
	mail-gx0-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611AbZH3Nfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 09:35:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xRmhDpuY3oUYiWviOVsZaccHc00CjHvXjFfdm2Jp+Zycg76TAoMyTb1KdXRHOXgRzC
         Ucrb8V78kN726vOpaaiej3C+p05nQlC68zA9pziEzNYQ0s40WXnpytguUXyc/iMIQxBB
         aZ6wRM2PpRPJ+eBpMPn73pwXYJF6cpyZ+3ABY=
Date: Sun, 30 Aug 2009 21:39:00 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Michal Schmidt <mschmidt@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: detect stack protector for i386 builds on x86_64
Message-ID: <20090830133900.GA6295@hack>
References: <20090829182718.10f566b1@leela>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090829182718.10f566b1@leela>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 29, 2009 at 06:27:18PM +0200, Michal Schmidt wrote:
>Stack protector support was not detected when building with ARCH=i386
>on x86_64 systems:
>arch/x86/Makefile:80: stack protector enabled but no compiler support
>
>The "-m32" argument needs to be passed to the detection script.
>
>Signed-off-by: Michal Schmidt <mschmidt@redhat.com>

Looks fine.

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

>
>--
>diff --git a/arch/x86/Makefile b/arch/x86/Makefile
>index 1b68659..5e7db44 100644
>--- a/arch/x86/Makefile
>+++ b/arch/x86/Makefile
>@@ -72,7 +72,7 @@ endif
> 
> ifdef CONFIG_CC_STACKPROTECTOR
> 	cc_has_sp := $(srctree)/scripts/gcc-x86_$(BITS)-has-stack-protector.sh
>-        ifeq ($(shell $(CONFIG_SHELL) $(cc_has_sp) $(CC)),y)
>+        ifeq ($(shell $(CONFIG_SHELL) $(cc_has_sp) $(CC) $(biarch)),y)
>                 stackp-y := -fstack-protector
>                 stackp-$(CONFIG_CC_STACKPROTECTOR_ALL) += -fstack-protector-all
>                 KBUILD_CFLAGS += $(stackp-y)
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/

-- 
Live like a child, think like the god.
 
