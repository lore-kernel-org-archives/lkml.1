Return-Path: <linux-kernel-owner+w=401wt.eu-S1754215AbZG0Sk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbZG0Sk0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 14:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754186AbZG0SkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 14:40:25 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:38351 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073AbZG0SkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 14:40:23 -0400
Date: Mon, 27 Jul 2009 20:40:23 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Hannes Eder <heder@google.com>
cc: lvs-devel@vger.kernel.org, netdev@vger.kernel.org,
       netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 5/5] libxt_ipvs: user space lib for netfilter matcher
 xt_ipvs
In-Reply-To: <20090727134852.13319.39035.stgit@jazzy.zrh.corp.google.com>
Message-ID: <alpine.LSU.2.00.0907272037500.20984@fbirervta.pbzchgretzou.qr>
References: <20090727134457.12897.272.stgit@jazzy.zrh.corp.google.com> <20090727134852.13319.39035.stgit@jazzy.zrh.corp.google.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday 2009-07-27 15:48, Hannes Eder wrote:
>+
>+	switch (c) {
>+	case '0': /* --ipvs */
>+		/* Nothing to do here. */

		Then why add it?

>+	char buf[BUFSIZ];
>+
>+	if (family == NFPROTO_IPV4) {
>+		if (!numeric && addr->ip == 0) {
>+			printf("anywhere ");
>+			return;
>+		}
>+		if (numeric)
>+			strcpy(buf, xtables_ipaddr_to_numeric(&addr->in));
>+		else
>+			strcpy(buf, xtables_ipaddr_to_anyname(&addr->in));
>+		strcat(buf, xtables_ipmask_to_numeric(&mask->in));
>+		printf("%s ", buf);

There is no need to use the strcpy/strcat hacks. Just directly printf it.

>--- /dev/null
>+++ b/extensions/libxt_ipvs.man
>@@ -0,0 +1,7 @@
>+ipvs tests where the packet was modified by IPVS, i.e. is the
>+skb_buff->ipvs_property set.
>+.TP
>+[\fB!\fP] \fB--ipvs
>+Does the packet have to IPVS property?
>+
>+TODO: Write proper documentation.

Yes.
