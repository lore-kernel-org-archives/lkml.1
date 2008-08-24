Return-Path: <linux-kernel-owner+w=401wt.eu-S1756070AbYHXRtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070AbYHXRtV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 13:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752217AbYHXRtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 13:49:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56309 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752007AbYHXRtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 13:49:11 -0400
Date: Sun, 24 Aug 2008 10:48:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, David Greaves <david@dgreaves.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: 2.6.27-rc4-git1: Reported regressions from 2.6.26
In-Reply-To: <mzBsPw3QUOF.A.87F.wZGsIB@albercik>
Message-ID: <alpine.LFD.1.10.0808241030060.3363@nehalem.linux-foundation.org>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 23 Aug 2008, Rafael J. Wysocki wrote:
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11405
> Subject		: 2.6.27-rc3 segfault on cold boot; not on warm boot.
> Submitter	: David Greaves <david@dgreaves.com>
> Date		: 2008-08-21 9:45 (3 days old)
> References	: http://marc.info/?l=linux-kernel&m=121931198904777&w=4

It would be good to have some kind of bisection of this one, because it 
looks pretty odd. Also, google doesn't find anybody else seeing that 
"segfault at ffffffbf", even though it seems to be very consistent for 
David. So I don't think we'll be able to even _guess_ where it is without 
some more information about exactly when it started happening.

Since it's present in 2.6.26 too, it's clearly not a regression from that 
one, but perhaps more importantly, since it's apparently an old one I'd 
have expected more reports like this if it was some common problem. And 
the warm-vs-cold-boot thing makes me think it's some hardware setup issue. 

Possibly the disk controller, possibly the CPU (eg some MTRR/PAT 
setup issue or TLB thing). But the dmesg's are all from late enough at 
boot that I can't even tell what disk controller it is (except that it is 
SATA), nor can I tell what CPU it is.

But again, if it was some MTRR/PAT issue, I'd expect a _lot_ more reports 
of this. 

MD/XFS sounds unlikely, since they should have absolutely nothing that 
could possibly matter for cold/hot boot.

			Linus
