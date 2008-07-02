Return-Path: <linux-kernel-owner+w=401wt.eu-S1762706AbYGBGiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762706AbYGBGiZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 02:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755586AbYGBGiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 02:38:17 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:53848 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755546AbYGBGiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 02:38:17 -0400
Date: Wed, 2 Jul 2008 08:38:16 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Benoit Boissinot <bboissin@gmail.com>
cc: linux-kernel@vger.kernel.org, Jack Lloyd <lloyd@randombit.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Bug in random32.c: all-zero outputs with probability 1/2^32,
 other seeding bugs
In-Reply-To: <20080701231927.GW7647@pirzuine>
Message-ID: <alpine.LNX.1.10.0807020835200.20393@fbirervta.pbzchgretzou.qr>
References: <20080619153045.GC1455@randombit.net> <20080701231927.GW7647@pirzuine>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday 2008-07-02 01:19, Benoit Boissinot wrote:
>@@ -122,7 +122,7 @@
[ int i ]
>
> 	for_each_possible_cpu(i) {
> 		struct rnd_state *state = &per_cpu(net_rand_state,i);
>-		__set_random32(state, i + jiffies);
>+		__set_random32(state, (u32) i + jiffies);
> 	}
> 	return 0;
> }

This cast does not make sense since
 (int)i + jiffies ≡ i + jiffies ≡ (u32)i + jiffies          mod 2^32
