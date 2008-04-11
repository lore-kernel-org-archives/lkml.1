Return-Path: <linux-kernel-owner+w=401wt.eu-S1761330AbYDKU7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761330AbYDKU7A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 16:59:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760114AbYDKU6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 16:58:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35423 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759539AbYDKU6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 16:58:52 -0400
Date: Fri, 11 Apr 2008 13:58:12 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bongani Hlope <bonganilinux@mweb.co.za>
cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Shutdown and Reboot Regression 2.6.25-rc[78]
In-Reply-To: <200804112241.44626.bonganilinux@mweb.co.za>
Message-ID: <alpine.LFD.1.00.0804111352390.3143@woody.linux-foundation.org>
References: <200804112241.44626.bonganilinux@mweb.co.za>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 11 Apr 2008, Bongani Hlope wrote:
> 
> I found a regression in version 2.6.25-rc7, which causes my computer not to 
> shutdown or reboot. I get a complete lock up (no keyboard and Sys-Rq) just 
> before it normally shuts down the alsa service.
> 
> I did a git bisect and it points to this reversion: 
> [266c2e0abeca649fa6667a1a427ad1da507c6375] Make printk() console semaphore 
> accesses sensible

Interesting. That commit _should_ have just moved code around with no 
actual semantic changes.

Can you verify that undoing just that one commit makes current git (-rc9) 
work for you? Ie just try a

	git revert 266c2e0abeca649fa6667a1a427ad1da507c6375

on top of the current tree. I just want to check, because even after 
looking at that diff again, I'm not seeing what it could actually change.

		Linus
