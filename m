Return-Path: <linux-kernel-owner+w=401wt.eu-S1763238AbYAHRNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763238AbYAHRNi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 12:13:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755343AbYAHRN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 12:13:27 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34967 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763073AbYAHRN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 12:13:26 -0500
Date: Tue, 8 Jan 2008 09:11:48 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Matthew Wilcox <matthew@wil.cx>, Valdis.Kletnieks@vt.edu,
       Willy Tarreau <w@1wt.eu>, Adrian Bunk <bunk@kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Osterlund <petero2@telia.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [patch] scsi: revert "[SCSI] Get rid of scsi_cmnd->done"
In-Reply-To: <4783A904.9030705@s5r6.in-berlin.de>
Message-ID: <alpine.LFD.1.00.0801080902460.3148@woody.linux-foundation.org>
References: <20080106171158.GM20473@parisc-linux.org> <1199640983.5205.65.camel@localhost.localdomain> <20080106183402.GA7906@1wt.eu> <20080106185625.GM2082@does.not.exist> <20080106191044.GA1105@1wt.eu> <20080106195802.GN2082@does.not.exist>
 <20080106210813.GA10136@1wt.eu> <19438.1199739038@turing-police.cc.vt.edu> <20080107213717.GB16309@parisc-linux.org> <26581.1199747065@turing-police.cc.vt.edu> <20080107231930.GC16309@parisc-linux.org> <4783A904.9030705@s5r6.in-berlin.de>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 8 Jan 2008, Stefan Richter wrote:

> Matthew Wilcox wrote:
> > So you're saying that you can't find reliable ways to reproduce problems
> > on demand?  Those are some of the lower quality bug reports,
> 
> Or those are the more difficult problems.

Indeed. If it's some race condition, or dependent on memory pressure at 
just the right time, or a use-after-free that corrupts some memory that 
normally nobody will even notice (it's freed, after all, and not 
necessarily re-allocated), reproduction can be really very hard.

It's happily not exactly *common*, but it's certainly not unheard of 
either, when you need to run some specific workload for hours to trigger 
the bug - and then when it doesn't happen, you have to ask yourself: "was 
I just lunky, punk?"

Some of those things also go away magically between kernel versions or 
subtly different configurations. A use-after-free problem might be obvious 
in one config, but then another configuration might change the size of a 
structure, and suddenly the two kmalloc's that used to be in the same slab 
(and made the problem more visible) end up in different slabs, and now you 
suddenly cannot reproduce it with that particular load at all any more!

These things *are* fairly rare (most bugs by _far_ are of the trivial 
stupid kind), but some of those things can stay around for a long time, 
and it can take months of different people reporting similar problems 
until somebody finally puts two and two together and sees the pattern.

When we get a good bug-reporter that is willing and able to reproduce and 
test kernels, that's wonderful, but when we get some "background noise" of 
bad bug-reports, that's usually good too - even if it's good only in the 
long run (ie sometimes we just have to accept that the bug-report didn't 
contain enough information for us to really do anythign about it, and just 
let it be - and hope that future events will clarify things)

				Linus
