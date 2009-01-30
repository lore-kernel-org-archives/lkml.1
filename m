Return-Path: <linux-kernel-owner+w=401wt.eu-S1756388AbZA3V0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388AbZA3V0e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 16:26:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754390AbZA3V00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 16:26:26 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44574 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751662AbZA3V0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 16:26:25 -0500
Date: Fri, 30 Jan 2009 13:25:41 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Hugh Dickins <hugh@veritas.com>
cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Greg KH <gregkh@suse.de>,
       Maksim Yevmenkin <maksim.yevmenkin@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, will@crowder-design.com,
       Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mikos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] Fix OOPS in mmap_region() when merging adjacent VM_LOCKED
 file segments
In-Reply-To: <Pine.LNX.4.64.0901302048360.18677@blonde.anvils>
Message-ID: <alpine.LFD.2.00.0901301323040.3150@localhost.localdomain>
References: <bb4a86c70901281151w4300605r3882461cd6e9774a@mail.gmail.com>  <alpine.LFD.2.00.0901281316450.3123@localhost.localdomain>  <1233259410.2315.75.camel@lts-notebook>  <alpine.LFD.2.00.0901291228250.3123@localhost.localdomain> 
 <alpine.LFD.2.00.0901291245170.3054@localhost.localdomain>  <bb4a86c70901291447k5c5e90cfg34877b745825f5e2@mail.gmail.com>  <alpine.LFD.2.00.0901291806340.3054@localhost.localdomain>  <20090130055639.GA30950@suse.de>  <alpine.LFD.2.00.0901300811260.3150@localhost.localdomain>
  <Pine.LNX.4.64.0901301724010.1563@blonde.anvils>  <alpine.LFD.2.00.0901300946360.3150@localhost.localdomain> <1233345190.908.36.camel@lts-notebook> <alpine.LFD.2.00.0901301159500.3150@localhost.localdomain>
 <Pine.LNX.4.64.0901302048360.18677@blonde.anvils>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 30 Jan 2009, Hugh Dickins wrote:
> 
> But I'm caring more about that VM_ACCOUNT...

The bright side here is that I think the VM_ACCOUNT bit differences only 
really happen for MAP_SHARED file mappings. For MAP_SHARED anon mappings 
we already don't share (for other reasons), and for private mappings 
VM_ACCOUNT looks stable (ie it's reliably either set or not, and stays 
that way).

So the impact is reasonably low. But it would definitely be good to clean 
up that whole VM_ACCOUNT logic, and incidentally then fix that merging 
issue at the same time.

			Linus
