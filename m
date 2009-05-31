Return-Path: <linux-kernel-owner+w=401wt.eu-S1757644AbZEaPDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757644AbZEaPDV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 11:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753946AbZEaPDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 11:03:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:38029 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827AbZEaPDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 11:03:07 -0400
Date: Sun, 31 May 2009 08:03:04 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       "Larry H." <research@subreption.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>, linux-mm@kvack.org,
       Ingo Molnar <mingo@redhat.com>, pageexec@freemail.hu
Subject: Re: [patch 0/5] Support for sanitization flag in low-level page
 allocator
Message-ID: <20090531080304.6e195c14@infradead.org>
In-Reply-To: <20090531073826.567d1dc3@infradead.org>
References: <20090522073436.GA3612@elte.hu>
	<20090522113809.GB13971@oblivion.subreption.com>
	<20090522143914.2019dd47@lxorguk.ukuu.org.uk>
	<20090522180351.GC13971@oblivion.subreption.com>
	<20090522192158.28fe412e@lxorguk.ukuu.org.uk>
	<20090522234031.GH13971@oblivion.subreption.com>
	<20090523090910.3d6c2e85@lxorguk.ukuu.org.uk>
	<20090523085653.0ad217f8@infradead.org>
	<1243539361.6645.80.camel@laptop>
	<20090529073217.08eb20e1@infradead.org>
	<20090530054856.GG29711@oblivion.subreption.com>
	<1243679973.6645.131.camel@laptop>
	<20090531073826.567d1dc3@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 31 May 2009 07:38:26 -0700
Arjan van de Ven <arjan@infradead.org> wrote:

> > 
> > 
> > Really, get a life, go fix real bugs. Don't make our kernel slower 
> 
> the "make it slower" is an assumption on your part.
> I'm not convinced. Would like to see data!
> 


btw if the performance difference is basically a wash (as I'm
suspecting), then we SHOULD do zero-on-free, just out of general
principles. 

Ingo mentioned the kernel stack, and that's a good point, we ought
to have a way to zero the rest of the stack inside the kernel, at
which point you could do things like providing a command line option
(or sysctl?) to call that from the munmap codepath or so...
(after all there you do a tlb flush and other expensive things as well)
