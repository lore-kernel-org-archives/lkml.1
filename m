Return-Path: <linux-kernel-owner+w=401wt.eu-S1761659AbXIJWEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761659AbXIJWEW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 18:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759539AbXIJWEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 18:04:13 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:46609 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755331AbXIJWEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 18:04:12 -0400
Date: Tue, 11 Sep 2007 00:04:10 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipconfig.c: De-clutter IP configuration report
In-Reply-To: <Pine.LNX.4.64N.0709101249230.25038@blysk.ds.pg.gda.pl>
Message-ID: <Pine.LNX.4.64.0709102351090.5368@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64N.0709101249230.25038@blysk.ds.pg.gda.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 10 2007 13:09, Maciej W. Rozycki wrote:
> The new code builds fine; no semantic changes.
>
> Please apply,
>
>  Maciej
>
>patch-mips-2.6.23-rc5-20070904-ipconfig-printk-2
>diff -up --recursive --new-file linux-mips-2.6.23-rc5-20070904.macro/net/ipv4/ipconfig.c linux-mips-2.6.23-rc5-20070904/net/ipv4/ipconfig.c
>--- linux-mips-2.6.23-rc5-20070904.macro/net/ipv4/ipconfig.c	2007-09-04 04:56:22.000000000 +0000
>+++ linux-mips-2.6.23-rc5-20070904/net/ipv4/ipconfig.c	2007-09-10 11:53:19.000000000 +0000
>@@ -1364,17 +1364,17 @@ static int __init ip_auto_config(void)
> 	/*
> 	 * Clue in the operator.
> 	 */
>-	printk("IP-Config: Complete:");
>-	printk("\n      device=%s", ic_dev->name);
>-	printk(", addr=%u.%u.%u.%u", NIPQUAD(ic_myaddr));
>-	printk(", mask=%u.%u.%u.%u", NIPQUAD(ic_netmask));
>-	printk(", gw=%u.%u.%u.%u", NIPQUAD(ic_gateway));
>-	printk(",\n     host=%s, domain=%s, nis-domain=%s",
>-	       utsname()->nodename, ic_domain, utsname()->domainname);
>-	printk(",\n     bootserver=%u.%u.%u.%u", NIPQUAD(ic_servaddr));
>-	printk(", rootserver=%u.%u.%u.%u", NIPQUAD(root_server_addr));
>-	printk(", rootpath=%s", root_server_path);
>-	printk("\n");
>+	pr_info("IP-Config: Complete:\n");
>+	pr_info("      device=%s, addr=%u.%u.%u.%u, "
>+		"mask=%u.%u.%u.%u, gw=%u.%u.%u.%u,\n",
>+		ic_dev->name, NIPQUAD(ic_myaddr),
>+		NIPQUAD(ic_netmask), NIPQUAD(ic_gateway));
>+	pr_info("      host=%s, domain=%s, nis-domain=%s,\n",
>+		utsname()->nodename, ic_domain, utsname()->domainname);
>+	pr_info("      bootserver=%u.%u.%u.%u, "
>+		"rootserver=%u.%u.%u.%u, rootpath=%s\n",
>+		NIPQUAD(ic_servaddr),
>+		NIPQUAD(root_server_addr), root_server_path);
> #endif /* !SILENT */
> 
> 	return 0;

It should really be done in userspace. And ripped from the kernel.



	Jan
-- 
