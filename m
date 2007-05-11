Return-Path: <linux-kernel-owner+w=401wt.eu-S1762278AbXEKXs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762278AbXEKXs0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 19:48:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755449AbXEKXsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 19:48:19 -0400
Received: from styx.suse.cz ([82.119.242.94]:35071 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754923AbXEKXsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 19:48:18 -0400
Date: Sat, 12 May 2007 01:50:16 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kratochvil <honza@jikos.cz>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RESEND] PIE randomization
In-Reply-To: <20070511133651.63f8a14d.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0705120048230.11493@jikos.suse.cz>
References: <alpine.LRH.0.98.0705111338230.22353@twin.jikos.cz>
 <20070511125629.3df919cf.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705112211440.16923@twin.jikos.cz>
 <20070511133651.63f8a14d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2007, Andrew Morton wrote:

> I could reverse-engineer that info from the patch, I guess, but I'd 
> prefer to go in the opposite direction: you tell us what the patch is 
> trying to do, then we look at it and see if we agree that it is in fact 
> doing that.

I've just quickly looked at the patch and it seems fine - it's using 
mmap()'s randomization functionality in such a way that it maps the the 
main executable of (specially compiled/linked) ET_DYN binaries onto a 
random address (in cases in which mmap() is allowed to perform a 
randomization). Which is what we want, I'd guess.

Jan, would you care to update the patch with proper Changelog entry?


However, I seem to get "soft" hang on boot with this patch, approximately 
at the time the init should be executed. The system is not completely 
stuck - interrupts are delivered, keyboard is working, alt-sysrq-t dumps 
proper output, but userspace doesn't seem to get started. This happens on 
i386, didn't try on other archs.

-- 
Jiri Kosina
