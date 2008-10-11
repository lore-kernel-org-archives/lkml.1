Return-Path: <linux-kernel-owner+w=401wt.eu-S1758647AbYJKWtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758647AbYJKWtT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 18:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754707AbYJKWtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 18:49:12 -0400
Received: from 1wt.eu ([62.212.114.60]:4712 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754694AbYJKWtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 18:49:11 -0400
Date: Sun, 12 Oct 2008 00:48:16 +0200
From: Willy Tarreau <w@1wt.eu>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       torvalds@linux-foundation.org
Subject: Re: Looks broken to me: x86, cyrix: debug
Message-ID: <20081011224816.GL24654@1wt.eu>
References: <200810112003.m9BK3Wwu025556@hera.kernel.org> <20081011214043.283a3330@lxorguk.ukuu.org.uk> <alpine.LFD.1.10.0810112146400.1984@ftp.linux-mips.org> <20081011205858.GA21965@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081011205858.GA21965@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 11, 2008 at 10:58:58PM +0200, Ingo Molnar wrote:
> 
> * Maciej W. Rozycki <macro@linux-mips.org> wrote:
> 
> > On Sat, 11 Oct 2008, Alan Cox wrote:
> > 
> > > > +#define getCx86_old(reg) ({ outb((reg), 0x22); inb(0x23); })
> > > 
> > > Doesn't expand to any kind of returned value.
> > 
> >  Well, actually it returns the value of the inb() expression -- cf the 
> > semantics of compound statements.  The rest looks suspicious indeed.
> 
> indeed it's broken - will sort it out. It's all about breakage that has 
> been in this code since v2.6.20, see c6744955d0. Will likely revert the 
> whole thing.

In fact the whole commit looks buggy to me as it simply reintroduces the
old bug at several places. The correct way of accessing the registers is
precisely through the inline functions and never through a macro due to
the ordering problem.

Willy

