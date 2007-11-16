Return-Path: <linux-kernel-owner+w=401wt.eu-S934464AbXKPAlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934464AbXKPAlT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 19:41:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753550AbXKPAlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 19:41:05 -0500
Received: from holomorphy.com ([66.93.40.71]:40103 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762592AbXKPAlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 19:41:04 -0500
Date: Thu, 15 Nov 2007 16:40:12 -0800
From: William Lee Irwin III <wli@holomorphy.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Why preallocate pmd in x86 32-bit PAE?
Message-ID: <20071116004012.GE1806@holomorphy.com>
References: <473CC0AC.3020500@goop.org> <alpine.LFD.0.9999.0711151403000.4260@woody.linux-foundation.org> <473CCB66.2080601@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <473CCB66.2080601@zytor.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
>> IIRC, the present bit is ignored in the magic 4-entry PGD.  All entries 
>> have to be present.

On Thu, Nov 15, 2007 at 02:42:46PM -0800, H. Peter Anvin wrote:
> This is true, although you could point a PGD to an all-zero page if you 
> really wanted to.  You have to re-load CR3 after modifying the top-level 
> entries.

There may be bigger fish to fry in terms of per-process overhead, if
you're trying to cut that down. The trouble with trying to address
some of those is that there is mutual antagonism between compactness
and expansibility in the process address space layout, so you'll end
up instantiating a lot more than you want barring some sort of provision
for a compact address space layout. Pagetable sharing is a far more
powerful resource scalability method, though it also needs cooperation
in user address space layout to reap its gains.

There are other overheads, of course, though they're more typically
per-something besides processes.


-- wli
