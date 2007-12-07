Return-Path: <linux-kernel-owner+w=401wt.eu-S1757294AbXLGVYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757294AbXLGVYQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 16:24:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755010AbXLGVXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 16:23:49 -0500
Received: from lixom.net ([66.141.50.11]:45188 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754532AbXLGVXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 16:23:47 -0500
Date: Fri, 7 Dec 2007 15:28:17 -0600
From: Olof Johansson <olof@lixom.net>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linuxppc-dev@ozlabs.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fake NUMA emulation for PowerPC
Message-ID: <20071207212817.GA391@lixom.net>
References: <20071207211425.10223.91240.sendpatchset@balbir-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071207211425.10223.91240.sendpatchset@balbir-laptop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Dec 08, 2007 at 02:44:25AM +0530, Balbir Singh wrote:

> Comments are as always welcome!

Care to explain what this is useful for? (Not saying it's a stupid idea,
just wondering what the reason for doing it is).

> diff -puN arch/powerpc/mm/numa.c~ppc-fake-numa-easy arch/powerpc/mm/numa.c
> --- linux-2.6.24-rc4-mm1/arch/powerpc/mm/numa.c~ppc-fake-numa-easy	2007-12-07 21:25:55.000000000 +0530
> +++ linux-2.6.24-rc4-mm1-balbir/arch/powerpc/mm/numa.c	2007-12-08 02:36:02.000000000 +0530
> @@ -24,6 +24,8 @@
>  
>  static int numa_enabled = 1;
>  
> +char *cmdline __initdata;
> +

Looks like this should be static.

> @@ -702,6 +744,9 @@ static int __init early_numa(char *p)
>  	if (strstr(p, "debug"))
>  		numa_debug = 1;
>  
> +	if (strstr(p, "fake="))
> +		cmdline = p + 5;	/* 5 is faster than strlen("fake=") */

This doesn't look right.

You check if it contains fake=, not if it starts with it. So if someone
did: "numa=foo,fake=bar", or even "numa=debug,fake=", things wouldn't
work right.


-Olof
