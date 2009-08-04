Return-Path: <linux-kernel-owner+w=401wt.eu-S1755130AbZHDDFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130AbZHDDFz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 23:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754809AbZHDDFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 23:05:55 -0400
Received: from mail-yw0-f177.google.com ([209.85.211.177]:57691 "EHLO
	mail-yw0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553AbZHDDFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 23:05:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=r9R6/kSk18+VU4qU/Vavck7JtDoiEUZGYixBp/Dsa/H3AIu5rxmL+L38OoUAvAHBlH
         gc7O9GRbJyel0z20LoP05oagkirB/lxVPTGwRl39CQUvlzky0PbCyIVfdgX9Gn975JoF
         t6wwoz2byMNTu2A4DFcH5YQhXFbP2S+WRGCWw=
MIME-Version: 1.0
In-Reply-To: <4A773FFF.7050106@gmail.com>
References: <1249238465-4929-1-git-send-email-kilroyd@googlemail.com> 
	<tip-8d19bd347e1073e7f1ef9f8057c560a5f6be63d7@git.kernel.org> 
	<20090803113929.GA25828@elte.hu> <4A773FFF.7050106@gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 3 Aug 2009 23:05:34 -0400
Message-ID: <8bd0f97a0908032005j5de90db6yf81cee2a28adfb1e@mail.gmail.com>
Subject: Re: [tip:core/locking] locking: Check spinlock_t/rwlock_t argument 
	type on non-SMP builds too
To: Dave <kilroyd@googlemail.com>
Cc: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 3, 2009 at 15:52, Dave wrote:
> The statistics (2.6.31-rc4ish) show a strong preference for static inline:
>
> $ find include -name "*.h" | xargs grep "static inline" | wc -l
> 6461
>
> $ find include -name "*.h" | xargs grep "extern inline" | wc -l
> 2
>
> $ find arch -name "*.h" | xargs grep "extern inline" | wc -l
> 125
>
> $ find arch -name "*.h" | xargs grep "static inline" | wc -l
> 7058
>
> $ find arch -name "*.h" | xargs grep "extern inline" | sed
> "s?^\(.*\):.*\$?\1?" | sort | uniq
> arch/blackfin/include/asm/string.h

we do want 'extern inline' (i.e. gnu_inline) semantics with the
Blackfin string functions, but the current nest of defines (making all
forms of "inline" expand to "always_inline") makes it hard to do at
the moment.
-mike
