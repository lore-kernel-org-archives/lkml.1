Return-Path: <linux-kernel-owner+w=401wt.eu-S1755676AbZE2ADI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676AbZE2ADI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 20:03:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754949AbZE2ABy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 20:01:54 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:52422 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754856AbZE2ABu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 20:01:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=VBKYwp5p7jPl+gIWzJXa8leLTLLjO1Rtkt8L/O4n/HZD65VTCUViLJZHX/pHxXHAtB
         AdMCilxGmdSWO+vjG+jXGf/6Wj9kns/Ozl70Lo6FIDGRLvijO3nS58Iiao6NyfC5ge+3
         KSYGn30FapWntOKPovr1OSbCCmmtaO9L3DX0Q=
MIME-Version: 1.0
In-Reply-To: <E1LerUo-0000NE-Q3@mailer.emlix.com>
References: <E1LerUo-0000NE-Q3@mailer.emlix.com>
Date: Fri, 29 May 2009 10:01:51 +1000
X-Google-Sender-Auth: 92f2c65c32d6f3ec
Message-ID: <9e6f3dfd0905281701y6141e5d2xbbfb37e495cba8d9@mail.gmail.com>
Subject: Re: [patch -v2] flat: fix data sections alignment
From: John Williams <jwilliams@itee.uq.edu.au>
To: Johannes Weiner <jw@emlix.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>,
       Russell King <rmk@arm.linux.org.uk>, Bryan Wu <cooloney@kernel.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Paul Mundt <lethal@linux-sh.org>, Greg Ungerer <gerg@uclinux.org>,
       linux-kernel@vger.kernel.org, michal.simek@petalogix.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Mar 4, 2009 at 11:51 PM, Johannes Weiner <jw@emlix.com> wrote:
> From: Oskar Schirmer <os@emlix.com>
>
> The flat loader uses an architecture's flat_stack_align() to align the
> stack but assumes word-alignment is enough for the data sections.
>
> However, on the Xtensa S6000 we have registers up to 128bit width
> which can be used from userspace and therefor need userspace stack and
> data-section alignment of at least this size.
>
> This patch drops flat_stack_align() and uses the same alignment that
> is required for slab caches, ARCH_SLAB_MINALIGN, or wordsize if it's
> not defined by the architecture.
>
> It also fixes m32r which was obviously kaput, aligning an
> uninitialized stack entry instead of the stack pointer.
>

> ---
>  arch/arm/include/asm/flat.h      |    3 ---
>  arch/blackfin/include/asm/flat.h |    1 -
>  arch/h8300/include/asm/flat.h    |    1 -
>  arch/m68k/include/asm/flat.h     |    1 -
>  arch/sh/include/asm/flat.h       |    1 -
>  fs/binfmt_flat.c                 |   37 ++++++++++++++++++++++---------------
>  include/asm-m32r/flat.h          |    1 -
>  7 files changed, 22 insertions(+), 23 deletions(-)

Can you please cross-check this patch for MicroBlaze as well, we are
another active nommu architecture.

Thanks,

John
