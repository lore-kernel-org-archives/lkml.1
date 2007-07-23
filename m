Return-Path: <linux-kernel-owner+w=401wt.eu-S932367AbXGWQZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367AbXGWQZT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 12:25:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760413AbXGWQZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 12:25:01 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:54048 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760389AbXGWQZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 12:25:00 -0400
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	for Linux Server. For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
Date: Mon, 23 Jul 2007 21:56:18 +0530 (IST)
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
To: Andi Kleen <ak@suse.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 6/8] i386: bitops: Don't mark memory as clobbered
 unnecessarily
In-Reply-To: <200707231813.26859.ak@suse.de>
Message-ID: <Pine.LNX.4.64.0707232152250.22155@cselinux1.cse.iitk.ac.in>
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in>
 <20070723160558.22137.71943.sendpatchset@cselinux1.cse.iitk.ac.in>
 <200707231813.26859.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,


On Mon, 23 Jul 2007, Andi Kleen wrote:

> On Monday 23 July 2007 18:05:58 Satyam Sharma wrote:
> > From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
> > 
> > [6/8] i386: bitops: Don't mark memory as clobbered unnecessarily
> > 
> > The goal is to let gcc generate good, beautiful, optimized code.
> 
> 
> The first goal is correct code.
> 
> The reason for the memory barrier is to prevent other memory references
> from being moved over the atomic reference.
> 
> e.g. when a bit is used to communicate with another CPU this might be dangerous.


Yes, but _that_ address (of the bit-string) is protected already -- by the
implicit memory barrier due to the LOCK prefix. We shouldn't really be
caring about any other memory addresses, so it doesn't affect the
correctness of the bitops API at all.

[ and at least the __test_and_change_bit() case is definitely okay. ]

Satyam
