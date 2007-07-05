Return-Path: <linux-kernel-owner+w=401wt.eu-S1761808AbXGEUxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761808AbXGEUxf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 16:53:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759662AbXGEUx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 16:53:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59384 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758894AbXGEUx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 16:53:27 -0400
Message-ID: <468D5A3A.1010306@redhat.com>
Date: Thu, 05 Jul 2007 16:53:14 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Jakub Jelinek <jakub@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jan Kratochvil <honza@jikos.cz>, Ingo Molnar <mingo@elte.hu>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       Ernie Petrides <petrides@redhat.com>
Subject: Re: [PATCH][RESEND] PIE randomization
References: <alpine.LRH.0.98.0705111338230.22353@twin.jikos.cz> <20070511125629.3df919cf.akpm@linux-foundation.org> <Pine.LNX.4.64.0705112211440.16923@twin.jikos.cz> <20070511133651.63f8a14d.akpm@linux-foundation.org> <Pine.LNX.4.64.0705120048230.11493@jikos.suse.cz> <Pine.LNX.4.64.0705161851120.25986@twin.jikos.cz> <alpine.LRH.0.98.0705172221440.22353@twin.jikos.cz> <20070522161642.b71ddacb.akpm@linux-foundation.org> <Pine.LNX.4.64.0705231044540.22906@jikos.suse.cz> <20070704082554.GQ7012@devserv.devel.redhat.com> <Pine.LNX.4.64.0707041927090.11634@jikos.suse.cz>
In-Reply-To: <Pine.LNX.4.64.0707041927090.11634@jikos.suse.cz>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2007 01:35 PM, Jiri Kosina wrote:
> On Wed, 4 Jul 2007, Jakub Jelinek wrote:
> 
>> The above highlighted changes are the cause of random segfaults of PIE 
>> binaries.  See 
>> https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=246623 
> 
> Thanks a lot for pointing this out. Andrew, could this be folded into 
> pie-randomization.patch please?
> 
> 
> From: Jiri Kosina <jkosina@suse.cz>
> 
> pie randomization: fix BAD_ADDR macro
> 
> pie-randomization.patch makes the load_addr in load_elf_interp() the load 
> bias of ld.so (difference between the actual load base address and first 
> PT_LOAD segment's p_vaddr). If the difference equals (on x86) to 
> 0xfffff000 (which is valid [1]), SIGSEGV is incorrectly sent.
> 
> This patch changes the BAD_ADDR so that it catches the mappings to the 
> error-area properly.

But what about this patch that made the opposite change:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=ce51059be56f63762089412b3ece348067afda85

There was a reason for that change...

