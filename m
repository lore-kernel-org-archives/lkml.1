Return-Path: <linux-kernel-owner+w=401wt.eu-S1754912AbZEOUC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912AbZEOUC2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 16:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753376AbZEOUCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 16:02:19 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52405 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955AbZEOUCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 16:02:18 -0400
Date: Fri, 15 May 2009 22:02:13 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Mel Gorman <mel@csn.ul.ie>, Peter Ziljstra <a.p.ziljstra@chello.nl>,
       San Mehat <san@android.com>, Arve Hj?nnev?g <arve@android.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Misleading OOM messages
Message-ID: <20090515200213.GA1406@ucw.cz>
References: <20090514092909.GG1365@ucw.cz> <alpine.DEB.1.10.0905141546040.1381@qirst.com> <1242333519.15391.210.camel@nimitz> <alpine.DEB.2.00.0905141346030.28074@chino.kir.corp.google.com> <1242335120.15391.242.camel@nimitz> <alpine.DEB.1.10.0905141729180.30187@qirst.com> <20090514213403.GB14741@elf.ucw.cz> <1242337299.28440.47.camel@nimitz> <20090515130547.GA1976@elf.ucw.cz> <alpine.DEB.1.10.0905151358430.26559@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0905151358430.26559@qirst.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-05-15 13:59:50, Christoph Lameter wrote:
> On Fri, 15 May 2009, Pavel Machek wrote:
> 
> > Ok, so kernel should be fixed to make limits 30% of non-mlocked
> > memory.
> 
> There is already ulimit.

...which does not work as described in the message you snipped.

> > > folks.  They go sucking up and locking as much memory as they can get
> > > their hands on.  Adding memory never helps them because they'll use up
> > > whatever is there.
> >
> > Well, but it is uncommon everywhere else. If you have desktop system,
> > job size is pretty much constant. If you have too little memory, you
> > OOM.
> 
> Nope. If you have too little memory for your app then the kernel pages
> portions of the app out to disk. Thats is why you have a VM (VIRTUAL
> machine). The app is not running with physical memory.

Try running your machine with mem=8M, then tell me how virtual memory
works.

If you have too little RAM+swap, you OOM. (Adding memory helps).

If you have *way* too little RAM, you OOM. (Kernel data is
unswappable. Task struct is 8KB. At some point it breaks).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
