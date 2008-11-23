Return-Path: <linux-kernel-owner+w=401wt.eu-S1758444AbYKWKFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758444AbYKWKFu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 05:05:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755662AbYKWKFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 05:05:40 -0500
Received: from mail2.shareable.org ([80.68.89.115]:44259 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbYKWKFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 05:05:40 -0500
Date: Sun, 23 Nov 2008 10:05:34 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Artem Bityutskiy <dedekind@infradead.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UBIFS: endian handling fixes and annotations
Message-ID: <20081123100534.GB29843@shareable.org>
References: <1227287970-14684-1-git-send-email-dedekind@infradead.org> <1227287970-14684-3-git-send-email-dedekind@infradead.org> <20081122192747.GB21433@Chamillionaire.breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081122192747.GB21433@Chamillionaire.breakpoint.cc>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian Andrzej Siewior wrote:
> >-	return le32_to_cpu(key->u32[1]) >> UBIFS_S_KEY_BLOCK_BITS;
> >+	return le32_to_cpu(key->j32[1]) >> UBIFS_S_KEY_BLOCK_BITS;
> 
> If you would change such references to something like
> |return le32_to_cpup(&key->j32[1]) >> UBIFS_S_KEY_BLOCK_BITS;
> then on powerpc
> 
>   text    data     bss     dec     hex filename
> 155384    1284      24  156692   26414 ubifs-b4.ko
> 155372    1284      24  156680   26408 ubifs-after.ko
> 
> because now it is possible to load the value as LE from memory instead
> of loading it BE and swapping it afterwads.

If le32_to_cpu used __builtin_bswap32 (a GCC builtin), wouldn't
GCC do this trivial optimisation itself?

-- Jamie
