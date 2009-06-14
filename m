Return-Path: <linux-kernel-owner+w=401wt.eu-S1754938AbZFNIaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938AbZFNIaX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 04:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753712AbZFNIaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 04:30:11 -0400
Received: from mail-fx0-f207.google.com ([209.85.220.207]:33189 "EHLO
	mail-fx0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997AbZFNIaI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 04:30:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=vOdsEvgMJ2n5kXooPD1UqllRIVuFrceK3IEocCaEt3NJ9eciNhLvPABXSyYypUgyWp
         slvKLFRowdJfCXv/RhDhjSJpdOa0zdSDFYun6/glYI/iCnGZbAyyj7mLDOFtvRqVHmzd
         wkvc1hk5+3McfZgJLGl3wlGj94hw5VrHA1BZM=
MIME-Version: 1.0
In-Reply-To: <4A34B2E2.7080702@cs.helsinki.fi>
References: <20090614081052.GA9276@elte.hu> <4A34B2E2.7080702@cs.helsinki.fi>
Date: Sun, 14 Jun 2009 11:30:08 +0300
X-Google-Sender-Auth: 52a8500d1d2047d5
Message-ID: <84144f020906140130w189239c0l56dccad99529aa7@mail.gmail.com>
Subject: Re: tty_ldisc_try_get(): BUG kmalloc-8: Poison overwritten
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Vegard Nossum <vegard.nossum@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 14, 2009 at 11:20 AM, Pekka Enberg<penberg@cs.helsinki.fi> wrote:
> You could add something like
>
>  WARN_ON(ld->refcount == 0x6b)
>
> to tty_ldisc_deref() to see if that triggers.

Make that

    WARN_ON(ld->refcount == (int)0xa56b6b6b)

instead.
                                Pekka
