Return-Path: <linux-kernel-owner+w=401wt.eu-S1765422AbZAOOQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765422AbZAOOQQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 09:16:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756346AbZAOOP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 09:15:59 -0500
Received: from ftp.linux-mips.org ([213.58.128.207]:52847 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755084AbZAOOP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 09:15:59 -0500
Date: Thu, 15 Jan 2009 14:15:56 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Jan-Benedict Glaw <jbglaw@lug-owl.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Jiri Kosina <jkosina@suse.cz>,
       Adam Osuchowski <adwol@zonk.pl>, linux-kernel@vger.kernel.org,
       Nick Piggin <npiggin@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Is 386 processor still supported?
In-Reply-To: <20090115133252.28c36adb@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.1.10.0901151353530.5737@ftp.linux-mips.org>
References: <20090108120338.6b8b4567@zonk.pl> <alpine.LRH.1.10.0901081359520.24105@twin.jikos.cz> <1231424025.11687.447.camel@twins> <alpine.LNX.1.10.0901081518070.5377@jikos.suse.cz> <1231424833.11687.452.camel@twins> <20090108150448.2393aeb0@lxorguk.ukuu.org.uk>
 <20090108151046.GK18120@elte.hu> <alpine.LFD.1.10.0901130047160.10547@ftp.linux-mips.org> <20090115123614.GR11087@lug-owl.de> <alpine.LFD.1.10.0901151309420.5737@ftp.linux-mips.org> <20090115133252.28c36adb@lxorguk.ukuu.org.uk>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2009, Alan Cox wrote:

> >  UP emulation of CMPXCHG and XADD for userland should be rather trivial, 
> > so why not include it like with LL/SC for MIPS?
> 
> Why not just ship an additional libc with the right options ?

 Does not work for MIPS as glibc has no equivalent code for pre-LL/SC CPUs 
and LL/SC is always used.  For the i386 the situation seems worse yet as 
for pre-i486 CPUs a generic C implementation of compare-and-exchange is 
used guaranteeing silent thread unsafety. :(

 IMO, a kernel emulation of CMPXCHG and XADD (both are used by 
sysdeps/i386/i486/bits/atomic.h in glibc) with an optional LOCK prefix, 
guaranteeing UP atomicity would be a cheap way to provide long-term i386 
userland support with little burden for both Linux and respective user 
software maintainers.  Certainly it adds some bloat to the kernel, but I 
think it is not an option that should be outright dismissed without 
consideration.

  Maciej
