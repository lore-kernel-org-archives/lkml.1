Return-Path: <linux-kernel-owner+w=401wt.eu-S1760658AbXEQEZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760658AbXEQEZa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 00:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754870AbXEQEZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 00:25:24 -0400
Received: from vms042pub.verizon.net ([206.46.252.42]:60130 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276AbXEQEZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 00:25:23 -0400
Date: Wed, 16 May 2007 21:24:53 -0700
From: "Kok, Auke" <sofar@foo-projects.org>
Subject: Re: PROBLEM: 2.6.21 - "make modules" with GREP_OPTIONS="-C1" (and
 other)
In-reply-to: <464BCB66.2090205@da7a.de>
To: Martin Christoph <mail@da7a.de>
Cc: linux-kernel@vger.kernel.org
Message-id: <464BD915.7090209@foo-projects.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <464BCB66.2090205@da7a.de>
User-Agent: Thunderbird 2.0.0.0 (X11/20070420)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Christoph wrote:
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

While I admit that this will break the build, I think it's safe to say that 
there are hundreds of environment variables that will influence the kbuild 
system and makefiles. It's going to be an uphill battle if you want to fix each 
and every occurrence of a *possible* build breakage due to an environment 
variable being set wrongly.

I think it's perfectly fine for the kbuild system to expect a reasonably sane 
and clean build system. Those who want to set specific variables to influence 
their build should be able to do so as well, without getting settings removed.

In your case, I would suggest not setting this option by default in your shell ;)

Cheers,

Auke


