Return-Path: <linux-kernel-owner+w=401wt.eu-S1754086AbYKXQqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086AbYKXQqW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 11:46:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753383AbYKXQqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 11:46:08 -0500
Received: from rn-out-0910.google.com ([64.233.170.188]:31167 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175AbYKXQqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 11:46:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=pVjKcNyTDkZvnVpVCYTN+yWIX8m6221wz3/nUMwh3Kpfbj3llxcG5aQBY3S7tA/xs6
         oc3m2yx08QwPdk+OUh9tVhsMaTs7On9z+mjwvB5KhK9m667rkc2gQoIbZAeA+rmQpRV5
         Vpd0XxmOx8n97xZ2bXWBtrThteC7w5fN0w8JE=
Subject: Re: [PATCH] UBIFS: endian handling fixes and annotations
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Adrian Hunter <ext-adrian.hunter@nokia.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
       Artem Bityutskiy <dedekind@infradead.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <492AB7F3.5020406@nokia.com>
References: <1227287970-14684-1-git-send-email-dedekind@infradead.org>
	 <1227287970-14684-3-git-send-email-dedekind@infradead.org>
	 <20081122192747.GB21433@Chamillionaire.breakpoint.cc>
	 <492AB7F3.5020406@nokia.com>
Content-Type: text/plain
Date: Mon, 24 Nov 2008 08:46:01 -0800
Message-Id: <1227545161.5511.2.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-11-24 at 16:19 +0200, Adrian Hunter wrote:
> Sebastian Andrzej Siewior wrote:
> > * Artem Bityutskiy | 2008-11-21 19:19:24 [+0200]:
> > 
> >> index 9ee6508..3f1f16b 100644
> >> --- a/fs/ubifs/key.h
> >> +++ b/fs/ubifs/key.h
> >> @@ -345,7 +345,7 @@ static inline int key_type_flash(const struct ubifs_info *c, const void *k)
> >> {
> >> 	const union ubifs_key *key = k;
> >>
> >> -	return le32_to_cpu(key->u32[1]) >> UBIFS_S_KEY_BLOCK_BITS;
> >> +	return le32_to_cpu(key->j32[1]) >> UBIFS_S_KEY_BLOCK_BITS;
> > 
> > If you would change such references to something like
> > |return le32_to_cpup(&key->j32[1]) >> UBIFS_S_KEY_BLOCK_BITS;
> > then on powerpc
> > 
> >   text    data     bss     dec     hex filename
> > 155384    1284      24  156692   26414 ubifs-b4.ko
> > 155372    1284      24  156680   26408 ubifs-after.ko
> > 
> > because now it is possible to load the value as LE from memory instead
> > of loading it BE and swapping it afterwads.
> 
> Wouldn't that be true for every le32_to_cpu of an lvalue?  Shame you can't
> do:
> 
> is_lvalue(x) ? le32_to_cpup(&(x)) : le32_to_cpu(x)
> 

No, you wouldn't want to do the above if the lvalue was on the stack as most
of the time the extra code to setup a pointer to a stack variable ends up
being more expensive than just using cpu_to_le32.

Cheers,

Harvey

