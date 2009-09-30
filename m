Return-Path: <linux-kernel-owner+w=401wt.eu-S1754528AbZI3Wqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbZI3Wqr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 18:46:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754293AbZI3Wqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 18:46:46 -0400
Received: from borg.medozas.de ([188.40.89.202]:51699 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753022AbZI3Wqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 18:46:45 -0400
Date: Thu, 1 Oct 2009 00:46:48 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Joe Perches <joe@perches.com>
cc: Patrick McHardy <kaber@trash.net>, "David S. Miller" <davem@davemloft.net>,
       Simon Horman <horms@verge.net.au>, Julian Anastasov <ja@ssi.bg>,
       netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       lvs-devel@vger.kernel.org
Subject: Re: [PATCH 1/2] net/netfilter/ipvs: Move #define KMSG_COMPONENT to
 Makefile
In-Reply-To: <0026bcf5aad9ae5036e68fc2dcda9c778d30dc47.1254349375.git.joe@perches.com>
Message-ID: <alpine.LSU.2.00.0910010042540.782@obet.zrqbmnf.qr>
References: <cover.1254349374.git.joe@perches.com> <0026bcf5aad9ae5036e68fc2dcda9c778d30dc47.1254349375.git.joe@perches.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday 2009-10-01 00:37, Joe Perches wrote:

>This centralizes the definition and removes the
>replicated #defines from all files

And increases the length of the command line. Not that Linux does not
support long command lines (in fact, configure often determines huge
possible values on the max length test), but sometimes, developers
have to inspect the command lines anyway for bugs, or something. It
is already pretty long due to all the compiler flags. Oh what were
the days of DOS programs that allowed to pass in arguments in a
so-called "response file", wish we had that in gcc.

>+ccflags-y += -D "KMSG_COMPONENT=\"IPVS\""
>+ccflags-y += -D "pr_fmt(fmt)=KMSG_COMPONENT \": \" fmt"
>+
> # IPVS transport protocol load balancing support
> ip_vs_proto-objs-y :=
> ip_vs_proto-objs-$(CONFIG_IP_VS_PROTO_TCP) += ip_vs_proto_tcp.o
>diff --git a/net/netfilter/ipvs/ip_vs_app.c b/net/netfilter/ipvs/ip_vs_app.c
>index 3c7e427..a5283d8 100644
>--- a/net/netfilter/ipvs/ip_vs_app.c
>+++ b/net/netfilter/ipvs/ip_vs_app.c
>@@ -18,9 +18,6 @@
>  *
>  */
> 
>-#define KMSG_COMPONENT "IPVS"
>-#define pr_fmt(fmt) KMSG_COMPONENT ": " fmt

How about an #include file for the ipvs private things?
