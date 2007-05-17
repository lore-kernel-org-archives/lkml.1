Return-Path: <linux-kernel-owner+w=401wt.eu-S1763482AbXEQHKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763482AbXEQHKs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 03:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755980AbXEQHKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 03:10:40 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:47816 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755809AbXEQHKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 03:10:39 -0400
Date: Thu, 17 May 2007 09:11:36 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Martin Christoph <mail@da7a.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: 2.6.21 - "make modules" with GREP_OPTIONS="-C1" (and other)
Message-ID: <20070517071136.GB3690@uranus.ravnborg.org>
References: <464BCB66.2090205@da7a.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464BCB66.2090205@da7a.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2007 at 05:26:30AM +0200, Martin Christoph wrote:
> [1] Summary:
> If i have some GREP_OPTIONS set (like -C1 or other) i get several errors
> while trying to do "make modules".
> 
> [2] Full description:
> With some GREP_OPTIONS set "make modules" drops several errors like that:
> 
> root@spot /usr/src/linux # GREP_OPTIONS="-C1" make modules
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   Building modules, stage 2.
> [...]
> WARNING: "aes_enc_blk" [arch/i386/crypto/aes.ko] undefined!
> WARNING: "aes_dec_blk" [arch/i386/crypto/aes.ko] undefined!
> [...]
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2
> 
> [3] Keywords:
> "make modules", "GREP_OPTIONS", "WARNING", "undefined"
> 
> [X.] Suggestion to fix:
> Unset GREP_OPTIONS within make process.

Thanks for reporting this - I gues this took some time to
find the root cause of the problem.

Albeit fixing it seems simple I will consider it for a
while. In the kernel we use several tools like:
awk, grep, perl, ls, rm, mv, cmp etc and then
we should audit all of these to check if similar
things could occur.

If someone steps up to do the check (including
all the tools I missed) I would be very grateful.

	Sam
