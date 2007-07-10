Return-Path: <linux-kernel-owner+w=401wt.eu-S1760573AbXGJQ0H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760573AbXGJQ0H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 12:26:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759008AbXGJQZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 12:25:50 -0400
Received: from gw.goop.org ([64.81.55.164]:52964 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758607AbXGJQZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 12:25:48 -0400
Message-ID: <4693B2D4.2070000@goop.org>
Date: Tue, 10 Jul 2007 09:24:52 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       andi@firstfloor.org, akpm@linux-foundation.org
Subject: Re: x86 setup code rewrite in C
References: <11840359321823-git-send-email-hpa@zytor.com>
In-Reply-To: <11840359321823-git-send-email-hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> This patch set replaces the x86 setup code, which is currently all in
> assembly, with a version written in C, using the ".code16gcc" feature
> of binutils (which has been present since at least 2001.)
>
> The new code is vastly easier to read, and, I hope, debug.  It should
> be noted that I found a fair number of minor bugs while going through
> this code, and have attempted to correct them.
>
> In the process of doing so, it introduces several cleanups, in
> particular:
>
> - Obsoletes the hd_info field in the boot_params structure; they are
>   only ever used for ST-506 (pre-IDE) drives and are pretty much
>   guaranteed to be wrong on current BIOSes;
> - Unifies the CPU feature bits between i386 and x86-64.  In the
>   future, it should be possible to use arch/i386/boot/cpucheck.c to do
>   the post-invocation CPU check currently done in
>   arch/x86_64/kernel/trampoline.S, although this patch set doesn't
>   introduce that change.
> - boot_params is now a proper structure.
>
> This code has been tested in -mm since early in the 2.6.22 cycle.
>   

This stuff is good.  I haven't read through this series in detail, but I 
have been working on the code in -mm and its a clear improvement.

Acked-by: Jeremy Fitzhardinge <jeremy@xensource.com>

    J
