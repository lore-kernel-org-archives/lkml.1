Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934303Ab0BZLIh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 06:08:37 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:46448 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933799Ab0BZLIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 06:08:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=ECesNUrzLjrRnKhmKkyioiYyKC5zAXRv2PR80UAJ5ccmtzkiR7hoypJENLLVLbCbcF
         +SqLNmN72ytUGNaohNLAA6LU8Mhw+13YkHuIdK9BRVFcUAZY+B/cIyKOraq0E/uk5imI
         jjC8QeWaW2S/8tuSxLwm+xuy37SOr+YDZeics=
MIME-Version: 1.0
In-Reply-To: <20100226101423.GA25641@elte.hu>
References: <1266600404-16402-1-git-send-email-luca@luca-barbieri.com>
	 <4B845AEE.5080604@zytor.com>
	 <ff13bc9a1002240156x27e28764mb6ba24da0b125d81@mail.gmail.com>
	 <20100226101423.GA25641@elte.hu>
Date: Fri, 26 Feb 2010 12:08:34 +0100
X-Google-Sender-Auth: 19d66da4a4e2656a
Message-ID: <ff13bc9a1002260308k319d34b5y4757fcfb36106278@mail.gmail.com>
Subject: Re: [PATCH 0/5] x86-32: improve atomic64_t functions (v2)
From: Luca Barbieri <luca@luca-barbieri.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> FYI, it triggered build failures in -tip testing:
>
> lib/atomic64_test.c: In function 'test_atomic64':
> lib/atomic64_test.c:116: error: implicit declaration of function 'atomic64_dec_if_positive'

This was on x86-64 right?

That function is implemented in the generic atomic64 implementation
and my x86-32 version, but not in the x86-64 implementation.

There is a similar problem with the 32-bt atomic_dec_if_positive, that
is implemented by ppc, mips, microblaze and avr32 but not in x86-32
and asm-generic.
Currently the 64-bit version seems unused, while the 32-bit one seems
to be only used by ppc-only drivers (IBM pSeries virtual SCSI and
PlayStation3 drivers).

I'll send a couple of patches to fix this shortly.
