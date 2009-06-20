Return-Path: <linux-kernel-owner+w=401wt.eu-S1755421AbZFTXBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421AbZFTXBo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 19:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751275AbZFTXBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 19:01:35 -0400
Received: from mail-fx0-f214.google.com ([209.85.220.214]:53446 "EHLO
	mail-fx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbZFTXBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 19:01:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=afLT9W1tYUon/u9oNVDiN7EOukHjHAkQcqh7w0Hrhix1NrioVQosniNdXEIsNaxigI
         dvIqbEIJHrFGzKIxwWrJPb3A7CEkor6orcA0JxlEVtcVjlsLcHb8v6DGY/XLl022DJah
         lyQWaPhC1GutQPRhL6TFSYx7vojH3TGF7vJW8=
Subject: Re: BUG] Strange oopses in 2.6.30
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
       Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mel@csn.ul.ie>,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0906201626270.5322@sister.anvils>
References: <1245448091.5475.19.camel@localhost>
	 <1245506908.6327.36.camel@localhost>
	 <Pine.LNX.4.64.0906201626270.5322@sister.anvils>
Content-Type: text/plain
Date: Sun, 21 Jun 2009 02:01:31 +0300
Message-Id: <1245538891.6540.8.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-06-20 at 16:40 +0100, Hugh Dickins wrote:
> On Sat, 20 Jun 2009, Maxim Levitsky wrote:
> > On Sat, 2009-06-20 at 00:48 +0300, Maxim Levitsky wrote:
> > > I see lots of following oopses in 2.6.30 and latest -git 
> > > 
> > > Many different applications shows up, not just reiserfsck
> > > Something in MM I guess, it makes me worry. But system seems to work.
> > > 
> > > Is this known?
> 
> I think so...
> 
> > > 
> > > dmesg attached.
> > > 
> > > 
> > > [   34.544040] BUG: Bad page state in process reiserfsck  pfn:37d86
> > > [   34.544044] page:c2a34f38 flags:3650000c count:0 mapcount:0
> > > mapping:(null) index:bffeb
> > > [   34.544048] Pid: 2654, comm: reiserfsck Tainted: G    B
> > > 2.6.30-git #4
> > > [   34.544051] Call Trace:
> > > [   34.544055]  [<c04cd26a>] ? printk+0x18/0x1e
> > > [   34.544059]  [<c018f065>] bad_page+0xd5/0x140
> > > [   34.544064]  [<c0190097>] free_hot_cold_page+0x1e7/0x280
> > > [   34.544069]  [<c0193682>] ? release_pages+0x92/0x1b0
> > > [   34.544074]  [<c0190155>] __pagevec_free+0x25/0x30
> > > [   34.544078]  [<c0193758>] release_pages+0x168/0x1b0
> > > [   34.544084]  [<c0193cf3>] ? lru_add_drain+0x53/0xd0
> > > [   34.544088]  [<c01ab7d4>] free_pages_and_swap_cache+0x84/0xa0
> > > [   34.544093]  [<c019ff5d>] unmap_vmas+0x73d/0x760
> > > [   34.544099]  [<c016480e>] ? lock_release_non_nested+0x15e/0x270
> > > [   34.544104]  [<c01a43b5>] exit_mmap+0xb5/0x1b0
> > > [   34.544109]  [<c0138666>] mmput+0x36/0xc0
> > > [   34.544113]  [<c013c874>] exit_mm+0xe4/0x120
> > > [   34.544117]  [<c0175539>] ? acct_collect+0x139/0x180
> > > [   34.544122]  [<c013e889>] do_exit+0x6b9/0x720
> > > [   34.544142]  [<c01bcac2>] ? vfs_write+0x122/0x180
> > > [   34.544146]  [<c01bbda0>] ? do_sync_write+0x0/0x110
> > > [   34.544151]  [<c013e920>] do_group_exit+0x30/0x90
> > > [   34.544156]  [<c013e993>] sys_exit_group+0x13/0x20
> > > [   34.544161]  [<c01039e8>] sysenter_do_call+0x12/0x3c
> > > [   34.544180] BUG: Bad page state in process reiserfsck  pfn:37d91
> > > [   34.544184] page:c2a35174 flags:3650000c count:0 mapcount:0
> > > mapping:(null) index:bfff6
> > > [   34.544188] Pid: 2654, comm: reiserfsck Tainted: G    B
> > > 2.6.30-git #4
> > > 
> > 
> > This really worries me
> 
> I hope it's fixed by this patch Hannes posted yesterday...

Indeed, this helps, thanks a lot

Best regards,

	Maxim Levitsky

