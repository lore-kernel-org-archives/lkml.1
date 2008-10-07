Return-Path: <linux-kernel-owner+w=401wt.eu-S1756669AbYJGBpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669AbYJGBpm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 21:45:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753144AbYJGBpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 21:45:34 -0400
Received: from smtp.outflux.net ([198.145.64.163]:36270 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752722AbYJGBpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 21:45:33 -0400
Date: Mon, 6 Oct 2008 18:44:29 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Roland McGrath <roland@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, Jakub Jelinek <jakub@redhat.com>,
       libc-alpha@sourceware.org
Subject: Re: [PATCH] ELF: implement AT_RANDOM for future glibc use
Message-ID: <20081007014429.GU10357@outflux.net>
References: <20081001220948.GC32107@sunsite.ms.mff.cuni.cz> <20081001222706.68E7E1544B4@magilla.localdomain> <20081003001616.GN10632@outflux.net> <87ej2untze.fsf@basil.nowhere.org> <20081006175038.GF10357@outflux.net> <20081006192641.GI3180@one.firstfloor.org> <20081006220759.GM10357@outflux.net> <20081006235827.59306154271@magilla.localdomain> <20081007003119.GS10357@outflux.net> <48EAB40C.5010607@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48EAB40C.5010607@redhat.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2008 at 05:57:48PM -0700, Ulrich Drepper wrote:
> Kees Cook wrote:
> > It sounds like it's not very safe,
> 
> Then investigate it.

As was suspected, each int is the same.

> > but on the other hand, glibc doesn't really care?
> 
> Of course we care.  Especially for SUID and uid==0 binaries.

I meant based on what was said about "if it's as strong as the ASLR
randomness, it's good enough for this".  While the ultimate solution
would be to bolt a better PRNG into the kernel, is the following good
enough for now for glibc:

$ ./rands
0x2b 0x06 0xb7 0x53 0x2b 0x06 0xb7 0x53 0x2b 0x06 0xb7 0x53 0x2b 0x06 0xb7 0x53
$ ./rands
0xc2 0xb5 0x42 0xdc 0xc2 0xb5 0x42 0xdc 0xc2 0xb5 0x42 0xdc 0xc2 0xb5 0x42 0xdc
$ ./rands
0x5f 0x39 0xc6 0xc0 0x5f 0x39 0xc6 0xc0 0x5f 0x39 0xc6 0xc0 0x5f 0x39 0xc6 0xc0
$ ./rands
0xfb 0x4a 0x82 0xbd 0xfb 0x4a 0x82 0xbd 0xfb 0x4a 0x82 0xbd 0xfb 0x4a 0x82 0xbd

-Kees

-- 
Kees Cook
Ubuntu Security Team
