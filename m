Return-Path: <linux-kernel-owner+w=401wt.eu-S1761623AbXEKN5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761623AbXEKN5q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 09:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755477AbXEKN5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 09:57:40 -0400
Received: from hu-out-0506.google.com ([72.14.214.237]:56496 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbXEKN5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 09:57:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=NyelER5Yoxw36RgJFGTCefRxlAAtzWv5tXxRKaavbUJLBx8mGo4/xikfAi2bnMgZP8MTiafNi47TAWeo1mp/aQCdn/npjFNAh+kwaBFkj7OB00ql+bbgI7UFval2Mj4Xu/AluDZbet/zsuGVp2XxBc5Crc+jguDyx995oT0VrVs=
Date: Fri, 11 May 2007 15:56:18 +0200
From: Frederik Deweerdt <deweerdt@free.fr>
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] make csum_and_copy_from_user arch independent
Message-ID: <20070511135618.GE23638@slug>
References: <20070509012322.199f292b.akpm@linux-foundation.org> <20070511082738.GA23560@slug> <20070511.021443.41636409.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070511.021443.41636409.davem@davemloft.net>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2007 at 02:14:43AM -0700, David Miller wrote:
> From: Frederik Deweerdt <deweerdt@free.fr>
> Date: Fri, 11 May 2007 10:27:38 +0200
> 
> > ERROR: "csum_partial_copy_from_user" [net/rxrpc/af-rxrpc.ko] undefined!
> > 
> > Linking on ARM fails because albeit a generic csum_and_copy_from_user()
> > function is provided in the case ! _HAVE_ARCH_COPY_AND_CSUM_FROM_USER, the
> > generic function uses csum_partial_copy_from_user() which is i386 only.
> 
> On what planet is csum_partial_copy_from_user() i386 only?
> Every single platform provides that function.
Er, my bad, I've changed my cscope bindings and I saw no results except
i386.
> The issue more-so appears to be that ARM simply fails to
> export the symbol to modules like the other platforms do.
Indeed, here's the fix.

Thanks,
Frederik

Signed-off-by: Frederik Deweerdt <frederik.deweerdt@gmail.com>

diff --git a/arch/arm/kernel/armksyms.c b/arch/arm/kernel/armksyms.c
index 4779f47..9179e82 100644
--- a/arch/arm/kernel/armksyms.c
+++ b/arch/arm/kernel/armksyms.c
@@ -76,6 +76,7 @@ EXPORT_SYMBOL(__const_udelay);
 
 	/* networking */
 EXPORT_SYMBOL(csum_partial);
+EXPORT_SYMBOL(csum_partial_copy_from_user);
 EXPORT_SYMBOL(csum_partial_copy_nocheck);
 EXPORT_SYMBOL(__csum_ipv6_magic);
 
