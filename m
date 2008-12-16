Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1758869AbYLPWja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758869AbYLPWja (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 17:39:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758603AbYLPWjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 17:39:15 -0500
Received: from mtagate2.de.ibm.com ([195.212.17.162]:54622 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758597AbYLPWjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 17:39:13 -0500
Date: Tue, 16 Dec 2008 23:39:09 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: Kyle McMartin <kyle@infradead.org>, Ralf Baechle <ralf@linux-mips.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH v3 0/3] preadv & pwritev syscalls.
Message-ID: <20081216223909.GB5584@osiris.boeblingen.de.ibm.com>
References: <1229340977-24345-1-git-send-email-kraxel@redhat.com> <20081215160311.GA23153@linux-mips.org> <4946C4B4.1020605@redhat.com> <20081216160502.GA15331@linux-mips.org> <4947DBFA.9050108@redhat.com> <20081216170209.GC410@bombadil.infradead.org> <49481EF9.3090304@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49481EF9.3090304@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2008 at 10:34:49PM +0100, Gerd Hoffmann wrote:
> Kyle McMartin wrote:
> > On Tue, Dec 16, 2008 at 05:48:58PM +0100, Gerd Hoffmann wrote:
> >> i.e. the ordering of the splitted argument depends on the os endianness?
> >> What is the reason for this?
> > 
> > Eh? The splitting will occur at the C ABI level, not as a result of
> > glibc (though, it could be done that way if you really wanted, but then
> > you're just moving the wrapper up the chain.)
> 
> Ah, ok.  You'll just declare 64bit arg for userspace, gcc splits it into
> two 32bit in native byte order, and then the kernel picks up the two
> 32bit values and has to reassemble them correctly, right?
> 
> The application-visible API must be compatible to the existing
> implementations, i.e. this ...
> 
>    pread(long fd, struct iovec *vec, long vlen, off_t pos);
> 
> ... prototype with the unaligned 64bit pos argument (in 32compat case).
> 
> Looks like there is no way around wrapping stuff then for the archs
> wanting aligned 64bit values.  The only choice we have is to do the
> wrap-o-magic in glibc or in the kernel.
> 
> I'd tend handle the wrapping in kernel space then because it is less
> confusing and we have to wrap only in case the ABI for $arch requires it.
> 
> Comments?

Please do it just the way that Arnd suggested: explicitly pass the upper
and lower part of loff_t as separate arguments.
It's the most simple approach.
