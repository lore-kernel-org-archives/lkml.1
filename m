Return-Path: <linux-kernel-owner+w=401wt.eu-S1761522AbZCXSDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761522AbZCXSDO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 14:03:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755543AbZCXSCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 14:02:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46491 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754990AbZCXSCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 14:02:54 -0400
Date: Tue, 24 Mar 2009 10:55:40 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Theodore Tso <tytso@mit.edu>
cc: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
In-Reply-To: <20090324132032.GK5814@mit.edu>
Message-ID: <alpine.LFD.2.00.0903241053200.3032@localhost.localdomain>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain> <49C87B87.4020108@krogh.cc> <72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com> <20090324091545.758d00f5@lxorguk.ukuu.org.uk> <20090324093245.GA22483@elte.hu>
 <20090324101011.6555a0b9@lxorguk.ukuu.org.uk> <20090324103111.GA26691@elte.hu> <20090324132032.GK5814@mit.edu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 24 Mar 2009, Theodore Tso wrote:
> 
> Try ext4, I think you'll like it.  :-)
> 
> Failing that, data=writeback for single-user machines is probably your
> best bet.

Isn't that the same fix? ext4 just defaults to the crappy "writeback" 
behavior, which is insane.

Sure, it makes things _much_ smoother, since now the actual data is no 
longer in the critical path for any journal writes, but anybody who thinks 
that's a solution is just incompetent. 

We might as well go back to ext2 then. If your data gets written out long 
after the metadata hit the disk, you are going to hit all kinds of bad 
issues if the machine ever goes down.

			Linus
