Return-Path: <linux-kernel-owner+w=401wt.eu-S1765602AbXGWQSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765602AbXGWQSb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 12:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760005AbXGWQSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 12:18:06 -0400
Received: from ns.suse.de ([195.135.220.2]:41990 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758065AbXGWQSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 12:18:05 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Subject: Re: [PATCH 7/8] i386: bitops: Kill needless usage of __asm__ __volatile__
Date: Mon, 23 Jul 2007 18:18:00 +0200
User-Agent: KMail/1.9.6
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in> <20070723160603.22137.16516.sendpatchset@cselinux1.cse.iitk.ac.in>
In-Reply-To: <20070723160603.22137.16516.sendpatchset@cselinux1.cse.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707231818.00547.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 July 2007 18:06:03 Satyam Sharma wrote:
> From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
> 
> [7/8] i386: bitops: Kill needless usage of __asm__ __volatile__
> 
> Another oddity I noticed in this file. The semantics of __volatile__
> when used to qualify inline __asm__ are that the compiler will not
> (1) elid, or, (2) reorder, or, (3) intersperse, our inline asm with
> the rest of the generated code.
> 
> However, we do not want these guarantees in the unlocked variants of the
> bitops functions. 

I thought so too and did a similar transformation while moving
some string functions out of line. After that recent misadventure
I would be very very careful with this.

Overall I'm sorry to say, but the risk:gain ratio of this
patch is imho totally out of whack.

It took a long time to get bitops.h correct and as far as we know
it is compiled correctly currently. You risk all at for very dubious
improvements.

-Andi



