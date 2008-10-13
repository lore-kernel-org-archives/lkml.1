Return-Path: <linux-kernel-owner+w=401wt.eu-S932139AbYJMT3B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139AbYJMT3B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 15:29:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757428AbYJMT2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 15:28:53 -0400
Received: from 220-133-139-86.HINET-IP.hinet.net ([220.133.139.86]:53529 "EHLO
	cooldavid.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756964AbYJMT2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 15:28:53 -0400
From: "Guo-Fu Tseng" <cooldavid@cooldavid.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Cc: apw@shadowen.org, jgarzik@redhat.com, ron.mercer@qlogic.com,
       scofeldm@cisco.com
Reply-To: cooldavid@cooldavid.org
Subject: Re: [PATCH] 2.6.27-git2 - fix build error at csum_ipv6_magic()
Date: Tue, 14 Oct 2008 03:28:14 +0800
Message-Id: <20081013192101.M74635@cooldavid.org>
In-Reply-To: <20081013121441.GB14372@linux.vnet.ibm.com>
References: <20081013121441.GB14372@linux.vnet.ibm.com>
X-Mailer: Open WebMail 2.51 20050228
X-OriginatingIP: 140.117.194.21 (cooldavid)
MIME-Version: 1.0
Content-Type: text/plain;
	charset=iso-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Oct 2008 17:44:41 +0530, Kamalesh Babulal wrote
> Hi,
>   2.6.27-git2 kernel build fails with allyesconfig on powerpc with 
> build error
> 
> <introduced by commit 01f2e4ead2c51226ed1283ef6a8388ca6f4cff8f>
> 
> CC    drivers/net/enic/enic_main.o
> drivers/net/enic/enic_main.c: In function `nic_queue_wq_skb_tso`:
> drivers/net/enic/enic_main.c:576: error: implicit declaration of function `sum_ipv6_magic`
> make[3]: *** [drivers/net/enic/enic_main.o] Error 1
> 
> <introduced by commit c4e84bde1d595d857d3c74b49b9c45cc770df792>
> 
> drivers/net/qlge/qlge_main.c: In function `l_tso`:
> drivers/net/qlge/qlge_main.c:1862: error: implicit declaration of function `sum_ipv6_magic`
> make[3]: *** [drivers/net/qlge/qlge_main.o] Error 1
> 
> <introduced by commit 95252236e73e789dd186ce796a2abc60b3a61ebe>
> 
> drivers/net/jme.c: In function `me_tx_tso`:
> drivers/net/jme.c:1784: error: implicit declaration of function `sum_ipv6_magic`
> make[2]: *** [drivers/net/jme.o] Error 1
> 
> The patch is build tested only.
> 
> Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> ---
Thank you Kamalesh.

But since <net/ip6_checksum.h> compensate the lack of
`csum_ipv6_magic` function defined in <asm/checksum.h>
of some architecture, should <net/ip6_checksum.h> be
included in <net/checksum.h> as well?

BTW, if there is a patch against jme driver which I maintain,
and I just simply agree with it, should I silently noticed that
and let someone like Jeff or David to review/apply it,
or should I reply an ack of it?

Guo-Fu Tseng

