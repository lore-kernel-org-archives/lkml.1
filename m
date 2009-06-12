Return-Path: <linux-kernel-owner+w=401wt.eu-S1762902AbZFLPo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762902AbZFLPo2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 11:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755578AbZFLPoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 11:44:01 -0400
Received: from mail-fx0-f216.google.com ([209.85.220.216]:38253 "EHLO
	mail-fx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096AbZFLPoA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 11:44:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=pONhEZIqFb7K5Qz3NLzdLBMCm08xpnlX0xtgBRwJXdpg8R9aRm16GHxctCLz6ktgfl
         LMKZ8QaX7KMWrN2JcN3L+izwnuQWV7p7YCiBnDa84VEsUBw59ItRp1/Jmh9fnhm3GScY
         JLmdwCKec0MlXaayeJot1PaR9paJQq71+t5p4=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0906121840550.5491@melkki.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0906121840550.5491@melkki.cs.Helsinki.FI>
Date: Fri, 12 Jun 2009 18:44:01 +0300
X-Google-Sender-Auth: 3399e06369f6d7e1
Message-ID: <84144f020906120844p1bdead66r509c7d3ec5d024ac@mail.gmail.com>
Subject: Re: [PATCH 2/3] slab,slub: don't enable interrupts during early boot
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, torvalds@linux-foundation.org,
       cl@linux-foundation.org, akpm@linux-foundation.org, npiggin@suse.de,
       benh@kernel.crashing.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 6:41 PM, Pekka J Enberg<penberg@cs.helsinki.fi> wrote:
> @@ -3237,6 +3251,10 @@ retry:
>        }
>
>        if (!obj) {
> +               /* Lets avoid crashing in early boot code. */
> +               if (WARN_ON_ONCE((local_flags & ~slab_gfp_mask) != 0))
> +                       local_flags &= slab_gfp_mask;
> +

Argh! This hunk should not be here.

                               Pekka
