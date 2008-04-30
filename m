Return-Path: <linux-kernel-owner+w=401wt.eu-S1761190AbYD3QhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761190AbYD3QhV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 12:37:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757670AbYD3QhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 12:37:07 -0400
Received: from rv-out-0708.google.com ([209.85.198.246]:23782 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757301AbYD3QhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 12:37:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=yH7WQuWFXABkKTJI6yrw2ugFRzUcAafTj1n0rs13bgK17uxJcbU/BoIvVYc75UMEhx/IONzVv/Y0oZmYEnc+JwWixit/fLSUo3HMayV3w+0xciGtabsee9wHk/3O3imO0/walnoYvK8GNruXnYbLP9zavZiRwabgUGnqvncMqNA=
Message-ID: <19f34abd0804300937k637e0308r36d4fa20899ff6bc@mail.gmail.com>
Date: Wed, 30 Apr 2008 18:37:03 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Roland Dreier" <rdreier@cisco.com>
Subject: Re: [git pull] kmemcheck
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Christoph Lameter" <clameter@sgi.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <adazlrb8fxq.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080429203446.GA18314@elte.hu> <adazlrb8fxq.fsf@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Apr 30, 2008 at 6:29 PM, Roland Dreier <rdreier@cisco.com> wrote:
>  >       kmemcheck: enable in the x86 Kconfig
>
>  This patch does:
>
>
>   > +config KMEMCHECK
>   > +    bool "kmemcheck: trap use of uninitialized memory"
>   > +    depends on X86_32
>
>  So it's only possible to select kmemcheck on 32-bit builds, But you also
>  seem to have 64-bit stuff, eg
>
>
>   >       kmemcheck: support for 64-bit
>   >       kmemcheck: add missing pte_hidden() for x86-64
>
>  so is the Kconfig patch slightly out-of-date?

We don't officially support 64-bit yet, that is why it is disabled in
the Kconfig. The 64-bit parts are preliminaries, and as with 32-bit,
should have no impact when CONFIG_KMEMCHECK=n (as is the case for all
64-bit builds as you pointed out). It is largely untested, but
according to Pekka it at least boots in qemu with kmemcheck enabled
even for 64-bit.

So the 64-bit parts we have is basically to make it _compile_ even if
you force KMEMCHECK=y on a 64-bit build.

(The main obstacle standing in the way of fully supporting 64-bit is
the opcode decoding. I don't really know how the 64-bit registers
works, so I will have to read about it first :-))

Thank you for looking over!

Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
