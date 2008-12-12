Return-Path: <linux-kernel-owner+w=401wt.eu-S1759273AbYLLRhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759273AbYLLRhn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 12:37:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757237AbYLLRhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 12:37:33 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:57524 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756799AbYLLRhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 12:37:32 -0500
Date: Fri, 12 Dec 2008 17:37:48 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Rik van Riel <riel@redhat.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jens Axboe <jens.axboe@oracle.com>, Jean Delvare <khali@linux-fr.org>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: Fix LSF default inconsistency
In-Reply-To: <494292D4.6090302@redhat.com>
Message-ID: <Pine.LNX.4.64.0812121733440.27074@blonde.anvils>
References: <20081211202923.330F.KOSAKI.MOTOHIRO@jp.fujitsu.com> 
 <20081211113646.GI23742@kernel.dk>  <20081211204006.3312.KOSAKI.MOTOHIRO@jp.fujitsu.com>
  <20081212075844.GH23742@kernel.dk> <49426C16.6040108@redhat.com>
 <2f11576a0812120711l130e07c3x94ff3b1e64959edf@mail.gmail.com>
 <Pine.LNX.4.64.0812121559220.19722@blonde.anvils> <494292D4.6090302@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Dec 2008, Rik van Riel wrote:
> Hugh Dickins wrote:
> > On Sat, 13 Dec 2008, KOSAKI Motohiro wrote:
> >   
> > > To move mlocked file cache page to unevictable list is useful although
> > > swapless embedded device.
> >
> > Yes, I don't understand why Rik suggested CONFIG_SWAP for it either.
> On swapless systems (with CONFIG_SWAP=n), we never scan
> the anon lists, so we do not need to split out the mlocked pages from
> the anon pages.
> 
> On a system with swap, we want to split out the mlocked pages
> so that scan balancing always works right.  So whenever
> CONFIG_SWAP is on, we want CONFIG_UNEVICTABLE_LRU
> to be on as well.
> 
> That means we can replace CONFIG_UNEVICTABLE_LRU
> with CONFIG_SWAP throughout the code, and get a kernel
> with the desired behaviour either way.

Sorry, I'm still puzzled: I thought the unevictable lru was for
shared file pages as well as for anon pages?  Of course I agree
with you over the anons (and shm and tmpfs get counted along
with the anons in this context), but wouldn't we still need
an unevictable lru for mlocked shared file pages?

Hugh
