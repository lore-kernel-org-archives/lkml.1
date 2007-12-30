Return-Path: <linux-kernel-owner+w=401wt.eu-S1758907AbXL3Vs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758907AbXL3Vs4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 16:48:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757248AbXL3Vss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 16:48:48 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57492 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755712AbXL3Vss (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 16:48:48 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Hibernation: Document __save_processor_state() on x86-64
Date: Sun, 30 Dec 2007 23:08:50 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>
References: <200712281353.37976.rjw@sisk.pl> <200712302248.03567.rjw@sisk.pl> <20071230213126.GB14654@elte.hu>
In-Reply-To: <20071230213126.GB14654@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712302308.51562.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 30 of December 2007, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > > how different can it be, for resume to work? I mean, we'll have 
> > > deeply kernel version dependent variables in RAM. Am i missing 
> > > something obvious?
> > 
> > On x86-64 it can be almost totally different (by restoring a 
> > hibernation image we replace the entire contents of RAM with almost no 
> > constraints).
> > 
> > [Well, using a relocatable kernel for restoring an image with 
> > nonrelocatable one or vice versa is rather not the best idea, but 
> > everything else should work in theory.]
> > 
> > On i386 the boot kernel is still required to be the same as the one in 
> > the image.
> 
> what's exactly in the hibernation image? Dirty data i suppose

No, everything, including the kernel code, page tables etc. :-)

> - but what about kernel-internal pages. What if we go from SLAB to SLUB?
> What if the size of a structure changes? Etc.

We can go from SLAB to SLUB just fine, it doesn't matter.  The only thing
that matters is we have to jump to the right address at the end of
core_restore_code() (defined in arch/x86/kernel/suspend_asm_64.S).

Rafael
