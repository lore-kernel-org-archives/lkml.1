Return-Path: <linux-kernel-owner+w=401wt.eu-S1755695AbYEEHuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695AbYEEHuQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 03:50:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754337AbYEEHuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 03:50:04 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55823
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753267AbYEEHuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 03:50:03 -0400
Date: Mon, 05 May 2008 00:50:03 -0700 (PDT)
Message-Id: <20080505.005003.69528106.davem@davemloft.net>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, samuel@sortiz.org, dtor_core@ameritech.net
Subject: Re: [patch] irda: fix !PNP support in drivers/net/irda/nsc-ircc.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080503193222.GA23373@elte.hu>
References: <20080503193222.GA23373@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Sat, 3 May 2008 21:32:23 +0200

> 
> x86.git testing found the following build failure in latest -git:
> 
>  drivers/built-in.o: In function `nsc_ircc_pnp_probe':
>  nsc-ircc.c:(.text+0xdf1b6): undefined reference to `pnp_get_resource'
>  nsc-ircc.c:(.text+0xdf1d4): undefined reference to `pnp_get_resource'
>  nsc-ircc.c:(.text+0xdf1ee): undefined reference to `pnp_get_resource'
>  nsc-ircc.c:(.text+0xdf237): undefined reference to `pnp_get_resource'
>  nsc-ircc.c:(.text+0xdf24c): undefined reference to `pnp_get_resource'
>  drivers/built-in.o:nsc-ircc.c:(.text+0xdf266): more undefined references to `pnp_get_resource' follow
>  make: *** [.tmp_vmlinux1] Error 1

I feel there is a better way to fix this and the other IRDA
pnp build failure.

linux/pnp.h provides erroring inlines when PNP is disabled, but it
does not provide a full set.  In order to be fully consistent it
should provide similar stub implementations for things like
pnp_get_flags() (which is what triggers the reference to
pnp_get_resource here), for example.

Either the whole API is provided with stubs when PNP is disabled, or
none should be.  If only some interfaces get the treatment, we get
messy ifdefs such as those seen in these patches we are discussing.
