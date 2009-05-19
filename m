Return-Path: <linux-kernel-owner+w=401wt.eu-S1754579AbZEVGNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579AbZEVGNK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 02:13:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751215AbZEVGNB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 02:13:01 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57561 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbZEVGNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 02:13:00 -0400
Date: Tue, 19 May 2009 22:39:45 +0200
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
Message-ID: <20090519203944.GD1362@ucw.cz>
References: <1242333519.15391.210.camel@nimitz> <alpine.DEB.2.00.0905141346030.28074@chino.kir.corp.google.com> <1242335120.15391.242.camel@nimitz> <alpine.DEB.1.10.0905141729180.30187@qirst.com> <20090514213403.GB14741@elf.ucw.cz> <1242337299.28440.47.camel@nimitz> <20090515130547.GA1976@elf.ucw.cz> <alpine.DEB.1.10.0905151358430.26559@qirst.com> <20090515200213.GA1406@ucw.cz> <alpine.DEB.1.10.0905151713230.26489@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0905151713230.26489@qirst.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-05-15 17:15:54, Christoph Lameter wrote:
> On Fri, 15 May 2009, Pavel Machek wrote:
> 
> > > Nope. If you have too little memory for your app then the kernel pages
> > > portions of the app out to disk. Thats is why you have a VM (VIRTUAL
> > > machine). The app is not running with physical memory.
> >
> > Try running your machine with mem=8M, then tell me how virtual memory
> > works.
> 
> Well that is of course not enough memory.

Ok, so in the end, there are two reasons for OOM:

1) Out of virtual memory.

   there's simply not enough ram+swap to fit the data. You go OOM.
   This seems to be common on small machines. 8M is pushing it, but
   64M ram + 64M swap + todays gnome would probably do that.

   And maybe the way to hint people would be printing 'out of
   _virtual_ memory'.

2) Something goes very wrong with reclaim

   this seems to be common on very  big machines you have experience
   with.

Perhaps 1 and 2 can be told appart by zero swap free in the 1) case?
And perhaps you can invent some better message for 2) case?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
