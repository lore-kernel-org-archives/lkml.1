Return-Path: <linux-kernel-owner+w=401wt.eu-S1759256AbYHFHXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759256AbYHFHXx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 03:23:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754665AbYHFHXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 03:23:45 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:18919 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbYHFHXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 03:23:44 -0400
Message-ID: <4899517D.2050208@de.ibm.com>
Date: Wed, 06 Aug 2008 09:23:41 +0200
From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org
Subject: Re: 2.6.27-rc1-mm1: unable to boot with gcov on x86_64
References: <20080731000354.24b55d5b.akpm@linux-foundation.org> <200808052226.36626.m.kozlowski@tuxland.pl>
In-Reply-To: <200808052226.36626.m.kozlowski@tuxland.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mariusz Kozlowski wrote:
> 	I'm seeing similar GCOV problems as with 2.6.26-rc5-mm1 that you fixed.
> This is the same x86_64 box and again it was unable to boot with gcov enabled.
> A quick look revealed that arch/x86/tsc_64.c and arch/x86/tsc_32.c code was
> unified. Unfortunately simple change of
> 
> GCOV_tsc_32.o := n
> GCOV_tsc_64.o := n
> 
> to
> 
> GCOV_tsc.o := n
> 
> did not help. Given the amount of combinations of which set of files with GCOV
> might cause failures I was rather fortunate and after a few hours I was able
> to pinpoint exactly two files which need GCOV disabled to make my x86_64 boot.
> 
> If you want to try to figure out what is wrong with them please feel free to send
> me patches to test. If not then how about this patch? Compile and run tested.

Your patch looks good. I don't think I will be able to refine those
list of files to be excluded any better than you already did so this
should go into -mm with the other gcov patches.

For future reference, there are other object files which "stand out" in
the respective Makefile, namely rtc.o, hpet.o and paravirt.o. Just like
the two files that you identified as causing problems with gcov
profiling, these are explicitly excluded from either FTRACE profiling
or stack-protector checks or both. If there should be further run-time
problems, these are good candidates to check, though I'd like to refrain
from removing them at this point in time without them causing any
apparent problems.


Regards,
  Peter
