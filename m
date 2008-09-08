Return-Path: <linux-kernel-owner+w=401wt.eu-S1755296AbYIHSEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296AbYIHSEv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 14:04:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753229AbYIHSEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 14:04:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38777 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752387AbYIHSEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 14:04:40 -0400
Date: Mon, 8 Sep 2008 11:04:30 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: x86 maintainers <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] x86 fixes
In-Reply-To: <200809081752.m88Hq6tn005080@askone.hos.anvin.org>
Message-ID: <alpine.LFD.1.10.0809081056350.3117@nehalem.linux-foundation.org>
References: <200809081752.m88Hq6tn005080@askone.hos.anvin.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 8 Sep 2008, H. Peter Anvin wrote:
>  
>  config X86_GENERIC
> -	bool "Generic x86 support"
> +	bool "Generic x86 support" if EMBEDDED

Ok, so after having realized that this seems to be more about a bug with 
gcc, I'm really not as convinced any more.

As far as I can tell, there are three issues:

 - "-mtune=core/core2/pentium4/.." is buggy in some gas/gcc versions on 
   x86-32, and makes architectural choices.

   Any actual _released_ versions? Maybe it's just a current SVN issue?

   Workaround: don't use it. And yes, X86_GENERIC=y will do that, although 
   quite frankly that seems to be dubious in itself. But quite frankly, 
   it's a gcc bug, and we should see it as such.

   The better workaround may well be "-Wa,-mtune=generic" as you pointed 
   out.

 - We do the CONFIG_P6_NOPL thing ourselves, and we should just stop 
   doing that on 32-bit. There simply isn't a good enough reason to do so. 
   I already posteed the Kconfig.cpu patch to just stop doing it.

 - X86_GENERIC means _other_ things too, like doing a 128-bit cacheline 
   just so that it won't suck horribly on P4's even if it's otherwise 
   tuned for a good microarchitecture.

And they really do seem to be _separate_ issues. Do we really want to tie 
these things together under X86_GENERIC? 

		Linus
