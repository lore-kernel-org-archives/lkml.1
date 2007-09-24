Return-Path: <linux-kernel-owner+w=401wt.eu-S1756180AbXIXGWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180AbXIXGWk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 02:22:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752146AbXIXGWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 02:22:33 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:56411 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbXIXGWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 02:22:32 -0400
Date: Mon, 24 Sep 2007 08:22:31 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Valdis.Kletnieks@vt.edu
cc: Alexey Dobriyan <adobriyan@gmail.com>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Uninline kcalloc()
In-Reply-To: <25045.1190612108@turing-police.cc.vt.edu>
Message-ID: <Pine.LNX.4.64.0709240821340.23305@fbirervta.pbzchgretzou.qr>
References: <20070922200349.GA2119@martell.zuzino.mipt.ru>
 <25045.1190612108@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 24 2007 01:35, Valdis.Kletnieks@vt.edu wrote:
>On Sun, 23 Sep 2007 00:03:49 +0400, Alexey Dobriyan said:
>
>> -static inline void *kcalloc(size_t n, size_t size, gfp_t flags)
>> -{
>> -	if (n != 0 && size > ULONG_MAX / n)
>> -		return NULL;
>> -	return __kmalloc(n * size, flags | __GFP_ZERO);
>> -}
>> +void *kcalloc(size_t n, size_t size, gfp_t flags);
>
>NAK.
>
>This busticates some pretty subtle code in mm/slab.c that uses
>uses __builtin_return_address() for debugging - if you do this, then
>the "calling function" gets listed as "kcalloc()" rather than the much more
>useful "function that called kcalloc()" (which is what you care about).
>
>(I remember going around and around multiple times getting those stupid
>inlines set up right, so that feature actually did something useful, otherwise
>kcalloc and kzalloc didn't report where they were called from).

Since 'inline' is only a hint , should not it be __always_inline,
so that __builtin_return_address() always works?

