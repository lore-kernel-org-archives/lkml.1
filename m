Return-Path: <linux-kernel-owner+w=401wt.eu-S1758037AbZBDRie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758037AbZBDRie (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 12:38:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753474AbZBDRiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 12:38:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48378 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532AbZBDRiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 12:38:23 -0500
Message-ID: <4989D17F.4030406@zytor.com>
Date: Wed, 04 Feb 2009 09:33:51 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Herbert Xu <herbert@gondor.apana.org.au>, mingo@elte.hu, x86@kernel.org,
       sam@ravnborg.org, jirislaby@gmail.com, gregkh@suse.de,
       davem@davemloft.net, xyzzy@speakeasy.org, mchehab@infradead.org,
       jens.axboe@oracle.com, linux-media@vger.kernel.org,
       linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>
Subject: Re: [GIT PULL -tip] fix 22 make headers_check - 200901
References: <20090204064307.GA18415@gondor.apana.org.au> <1233734645.3198.2.camel@localhost.localdomain> <200902041255.53264.arnd@arndb.de>
In-Reply-To: <200902041255.53264.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> 
> I fear that the problem might be more widespread than just kvm.
> The problem is that <linux/types.h> without __KERNEL_STRICT_NAMES
> defines the standard types that glibc provides in its own <sys/types.h>,
> some of them even defined differently (e.g. the size of off_t depends
> __USE_FILE_OFFSET64).
> 
> Subject: introduce <linux/strict_types.h>
> 

Actually, if anything we should move the *non* __KERNEL_STRICT_NAMES out
of <linux/types.h> into something else, or completely deep-six them.  I
don't know of any libc which wants these anymore, and I think they're
just residual libc5 cruft.

However, if we want <linux/extra_types.h> that's fine with me; but
<linux/types.h> really should be clean, which means doing what
__KERNEL_STRICT_NAMES does now.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

