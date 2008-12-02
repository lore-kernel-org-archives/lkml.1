Return-Path: <linux-kernel-owner+w=401wt.eu-S1754081AbYLBJPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081AbYLBJPP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 04:15:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751233AbYLBJOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 04:14:55 -0500
Received: from smtp.nokia.com ([192.100.122.233]:26787 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbYLBJOy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 04:14:54 -0500
Subject: Re: [PATCH] UBIFS: endian handling fixes and annotations
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20081122192747.GB21433@Chamillionaire.breakpoint.cc>
References: <1227287970-14684-1-git-send-email-dedekind@infradead.org>
	 <1227287970-14684-3-git-send-email-dedekind@infradead.org>
	 <20081122192747.GB21433@Chamillionaire.breakpoint.cc>
Content-Type: text/plain; charset=utf-8
Date: Tue, 02 Dec 2008 11:12:35 +0200
Message-Id: <1228209155.5029.30.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 02 Dec 2008 09:14:29.0840 (UTC) FILETIME=[61A17500:01C9545E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-11-22 at 20:27 +0100, Sebastian Andrzej Siewior wrote:
> >index 9ee6508..3f1f16b 100644
> >--- a/fs/ubifs/key.h
> >+++ b/fs/ubifs/key.h
> >@@ -345,7 +345,7 @@ static inline int key_type_flash(const struct ubifs_info *c, const void *k)
> > {
> > 	const union ubifs_key *key = k;
> > 
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

Well, I think stuff like this should be done by either GCC or by a PPC-specific
'le32_to_cpu()' implementation.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

