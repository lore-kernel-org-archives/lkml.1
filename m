Return-Path: <linux-kernel-owner+w=401wt.eu-S1758337AbZD1GQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758337AbZD1GQR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 02:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753639AbZD1GP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 02:15:59 -0400
Received: from cantor.suse.de ([195.135.220.2]:40405 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923AbZD1GP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 02:15:59 -0400
Date: Tue, 28 Apr 2009 08:15:57 +0200
From: Nick Piggin <npiggin@suse.de>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mm-commits@vger.kernel.org
Subject: Re: mmotm 2009-04-24-18-14 uploaded - NVidia indigestion
Message-ID: <20090428061557.GA29299@wotan.suse.de>
References: <200904250133.n3P1XBJn006790@imap1.linux-foundation.org> <5622.1240628800@turing-police.cc.vt.edu> <20090425052434.GE10088@wotan.suse.de> <57773.1240857915@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57773.1240857915@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 02:45:15PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Sat, 25 Apr 2009 07:24:34 +0200, Nick Piggin said:
> 
> > >             #include <linux/version.h>
> > >             #include <linux/utsname.h>
> > >             int main() {
> > >               if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)) {
> > >                 return 0;
> > >               } else {
> > >                 return 1;
> > >               }
> 
> > Yeah BUILD_BUG_ON does work like that. I can't for the life of me
> > understand why it triggered though. Is anything in your external
> > code calling kmalloc_slab directly?
> 
> See above - I didn't think LINUX_VERSION_CODE cared about kmalloc, but
> I could be wrong on this. ;)
> 
> > What's the preprocessor output look like?
> 
> The problem appears to be that if you only include version.h and utsname.h,
> and *don't* actually reference kmalloc_slab, it doesn't know that the size_t
> is actually a constant, so it whinges.  Most modules end up doing at least
> one kmalloc(), so kmalloc() and kmalloc_slab() get inlined, the constant 'size'
> gets propogated, and life is good.  If you *don't* call kmalloc(), bad things
> happen. ;)

Hmm, yes if you build without -O, then it appears like the compiler
trips over this. I wouldn't be unhappy with just removing the BUILD_BUG_ON,
but shouldn't the module be using -O[s2]?

