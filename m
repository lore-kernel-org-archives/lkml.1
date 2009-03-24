Return-Path: <linux-kernel-owner+w=401wt.eu-S1761020AbZCXT1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761020AbZCXT1V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 15:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758209AbZCXTZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 15:25:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46711 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756996AbZCXTZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 15:25:35 -0400
Date: Tue, 24 Mar 2009 12:17:42 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Kyle Moffett <kyle@moffetthome.net>
cc: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
In-Reply-To: <f73f7ab80903241141t358ab241qa377e709752a3cbf@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0903241215230.3032@localhost.localdomain>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain>  <49C87B87.4020108@krogh.cc>  <72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com>  <20090324091545.758d00f5@lxorguk.ukuu.org.uk>  <20090324093245.GA22483@elte.hu> 
 <20090324101011.6555a0b9@lxorguk.ukuu.org.uk>  <20090324103111.GA26691@elte.hu> <20090324132032.GK5814@mit.edu>  <alpine.LFD.2.00.0903241053200.3032@localhost.localdomain> <f73f7ab80903241141t358ab241qa377e709752a3cbf@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 24 Mar 2009, Kyle Moffett wrote:
> 
> Regardless of any journalling, a power-fail or a crash is almost
> certainly going to cause "data loss" of some variety.

The point is, if you write your metadata earlier (say, every 5 sec) and 
the real data later (say, every 30 sec), you're actually MORE LIKELY to 
see corrupt files than if you try to write them together.

And if you write your data _first_, you're never going to see corruption 
at all.

This is why I absolutely _detest_ the idiotic ext3 writeback behavior. It 
literally does everything the wrong way around - writing data later than 
the metadata that points to it. Whoever came up with that solution was a 
moron. No ifs, buts, or maybes about it.

			Linus
