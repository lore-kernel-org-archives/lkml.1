Return-Path: <linux-kernel-owner+w=401wt.eu-S1758941AbZFPWH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758941AbZFPWH4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 18:07:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751505AbZFPWHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 18:07:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54683 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753800AbZFPWHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 18:07:48 -0400
Date: Tue, 16 Jun 2009 15:06:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Christoph Lameter <cl@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, mingo@elte.hu,
       yinghai@kernel.org
Subject: Re: [GIT PULL v2] Early SLAB fixes for 2.6.31
In-Reply-To: <1245189509.14036.28.camel@pasglop>
Message-ID: <alpine.LFD.2.01.0906161505080.16802@localhost.localdomain>
References: <Pine.LNX.4.64.0906121624280.2937@melkki.cs.Helsinki.FI>  <Pine.LNX.4.64.0906121859420.5963@melkki.cs.Helsinki.FI>  <20090615081831.GA5411@osiris.boeblingen.de.ibm.com>  <84144f020906150210w7fa29042xc12efb4a087e3d26@mail.gmail.com> 
 <20090615094148.GC1314@wotan.suse.de> <1245059476.12400.7.camel@pasglop>  <20090615101254.GB10294@wotan.suse.de> <1245062388.12400.17.camel@pasglop>  <20090615112205.GA6012@wotan.suse.de> <20090615112827.GC6012@wotan.suse.de>  <1245101567.12400.38.camel@pasglop>
  <alpine.DEB.1.10.0906161104480.26093@gentwo.org>  <alpine.LFD.2.01.0906161208100.3282@localhost.localdomain> <1245189509.14036.28.camel@pasglop>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 17 Jun 2009, Benjamin Herrenschmidt wrote:
> 
> I would normally agree ... but we still have some stuff in setup_arch()
> that will need that :-( IE, we need to allow ioremap very early on
> powerpc (and possibly various other archs that don't have magic PIO to
> whack their chipset without the need for a mapping), so we have tricks
> to allocate page tables using LMB, bootmem or slab depending on what's
> available that still rely on slab_is_available().
> 
> Same goes with some PCI PHB related data structures that we are
> allocating in setup_arch() as well, though that's something I do intend
> to move to normal initcalls asap (there's a few skeletons hiding in some
> corners there so it's not totally trivial).

Both of these sound like they should be moved. Perhaps not to "normal 
initcalls" (those do happen very late), but maybe to some slightly later 
phase in init/main.c.

Why do you need ioremap so early that it has to happen before even the 
basic MM data is up? That sounds bogus, and like just a random 
implementation issue for historical reasons.

		Linus
