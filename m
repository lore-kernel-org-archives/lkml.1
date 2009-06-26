Return-Path: <linux-kernel-owner+w=401wt.eu-S1754293AbZFZPOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293AbZFZPOJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 11:14:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752781AbZFZPN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 11:13:56 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:37233 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751269AbZFZPNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 11:13:55 -0400
Subject: Re: [PATCH 01/10] percpu: use dynamic percpu allocator as the
 default percpu allocator
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org,
       mingo@elte.hu, kyle@mcmartin.ca, cl@linux-foundation.org,
       Jesper.Nilsson@axis.com, benh@kernel.crashing.org,
       paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Paul Mundt <lethal@linux-sh.org>, Russell King <rmk@arm.linux.org.uk>,
       Mikael Starvik <starvik@axis.com>, Ralf Baechle <ralf@linux-mips.org>,
       Bryan Wu <cooloney@kernel.org>, Matthew Wilcox <matthew@wil.cx>,
       Grant Grundler <grundler@parisc-linux.org>,
       Hirokazu Takata <takata@linux-m32r.org>,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
In-Reply-To: <4A42E72D.2060904@kernel.org>
References: <1245825924-30412-1-git-send-email-tj@kernel.org>
	 <1245825924-30412-2-git-send-email-tj@kernel.org>
	 <1245887275.4022.619.camel@mulgrave.site>  <4A42E72D.2060904@kernel.org>
Content-Type: text/plain
Date: Fri, 26 Jun 2009 10:13:49 -0500
Message-Id: <1246029229.3925.20.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-25 at 11:55 +0900, Tejun Heo wrote:
> James Bottomley wrote:
> > On Wed, 2009-06-24 at 15:45 +0900, Tejun Heo wrote:
> >> This patch makes most !CONFIG_HAVE_SETUP_PER_CPU_AREA archs use
> >> dynamic percpu allocator.  The first chunk is allocated using
> >> embedding helper and 8k is reserved for modules.  This ensures that
> >> the new allocator behaves almost identically to the original allocator
> >> as long as static percpu variables are concerned, so it shouldn't
> >> introduce much breakage.
> >>
> >> s390 and alpha use custom SHIFT_PERCPU_PTR() to work around addressing
> >> range limit the addressing model imposes.  Unfortunately, this breaks
> >> if the address is specified using a variable, so for now, the two
> >> archs aren't converted.
> >>
> >> The following architectures are affected by this change.
> >>
> >> * sh
> >> * arm
> >> * cris
> >> * mips
> >> * sparc(32)
> >> * blackfin
> >> * avr32
> >> * parisc (broken, under investigation)
> > 
> > OK, I thought I'd investigate this.  Unfortunately, your git tree
> > doesn't build when pulled into head ... could you update?
> > 
> > mm/percpu.c: In function 'setup_per_cpu_areas':
> > mm/percpu.c:2007: error: too many arguments to function 'pcpu_embed_first_chunk'
> 
> Hmm... strange.  I don't see such failures.  Can you please try the
> following git tree?
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-james
> 
> The contains all posted percpu patches and pulls in the current
> linus#master (rc1).

It still fails with the above error.

If you look at your own file:

http://git.kernel.org/?p=linux/kernel/git/tj/percpu.git;a=blob;f=mm/percpu.c;h=b11ae7af3f7a214717d6670edb2985368efa8391;hb=for-james

on line 1456 pcpu_embed_first_chunk is defined with *three* arguments

on line 2006 it's used with *four* arguments

This is what the compiler doesn't like.

James


