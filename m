Return-Path: <linux-kernel-owner+w=401wt.eu-S1760595AbYBAUr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760595AbYBAUr4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 15:47:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759789AbYBAUro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 15:47:44 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34885 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759780AbYBAUrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 15:47:43 -0500
Message-ID: <47A3856D.70906@redhat.com>
Date: Fri, 01 Feb 2008 15:47:41 -0500
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Gene Heskett <gene.heskett@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: log spamming
References: <200802011044.42919.gene.heskett@gmail.com>
In-Reply-To: <200802011044.42919.gene.heskett@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gene Heskett wrote:
> Greetings;
> 
> I just rebooted to a new config of 2.6.24, basically trying to strip out the 
> building of modules I don't use.  And I enabled a couple of checks that 
> weren't checked in the kernel-hacking menu.  .config posted on request.
> 
> Now the messages log is being spammed at 2-5 second intervals by these:
> Feb  1 10:41:08 coyote kernel: [ 3085.501037] MCE: The hardware reports a non 
> fatal, correctable incident occurred on CPU 0.
> Feb  1 10:41:08 coyote kernel: [ 3085.501042] Bank 1: d400400000000152
> Feb  1 10:41:08 coyote kernel: [ 3085.501045] MCE: The hardware reports a non 
> fatal, correctable incident occurred on CPU 0.
> Feb  1 10:41:08 coyote kernel: [ 3085.501048] Bank 2: d40040000000017a
> 
> Always the same 2 addresses.  Is this telling me I should be running memtest86 
> for a couple of cycles?

Those two addresses are in the same cache line, but they are *not* in the same 
128-bit ECC block.  This is probably a northbridge problem, not a RAM problem. 
It's not necessarily a hardware problem.  I wouldn't be surprised if you swapped 
CPUs and still got the same result, due to BIOS misconfiguration.

	-- Chris
