Return-Path: <linux-kernel-owner+w=401wt.eu-S1755689AbXEIJI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689AbXEIJI3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 05:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754538AbXEIJIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 05:08:22 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42272 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754392AbXEIJIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 05:08:21 -0400
Date: Wed, 9 May 2007 11:08:19 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ken Moffat <zarniwhoop@ntlworld.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@in.ibm.com>, Andi Kleen <ak@suse.de>,
       Valdis.Kletnieks@vt.edu
Subject: Re: Lockup after logging out of X
Message-ID: <20070509090819.GB15029@one.firstfloor.org>
References: <20070508195142.GA30030@deepthought> <20070508230134.GD17482@one.firstfloor.org> <20070509001459.GA2435@deepthought>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070509001459.GA2435@deepthought>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2007 at 01:14:59AM +0100, Ken Moffat wrote:
> On Wed, May 09, 2007 at 01:01:34AM +0200, Andi Kleen wrote:
> > 
> > Already known, although it is still unclear what the bug actually is.
> > Can you run with the appended patch please (from Eric Biederman) 
> > and post any backtraces the WARN_ON in there spews out? 
> > 
> > Also do you use swiotlb?
> > 
> > Thanks
> > 
> > -Andi
> > 
>  Had to turn off modules to get it to build.  It half-logged another
> oops, but no backtraces, and SysRq+r does nothing.  Nothing else
> unusual in the log.

Hmm, not good.
> 
> May  9 00:47:12 bluesbreaker gconfd (ken-2833): Resolved address
> "xml:readonly:/etc/gnome/gconf/gconf.xml.defaults" to a read-only
> configuration source at position 2
> May  9 00:52:59 bluesbreaker kernel: [  275.667737] Unable to handle
> kernel paging request at ffff81003b4ac3e8 RIP:
> May  9 00:52:59 bluesbreaker kernel: [  275.667742]
> [<ffffffff8027134a>] fasync_helper+0x52/0xf0
> May  9 00:52:59 bluesbreaker kernel: [  275.667749] PGD 8063 PUD
> 9063 PMD 800000003b4a11e3 BAD
> May  9 00:52:59 bluesbreaker kernel: [  275.667754] Oops: 0009 [1]
> PREEMPT
> May  9 00:54:26 bluesbreaker syslogd 1.4.1: restart.
> May  9 00:54:26 bluesbreaker bootlog: Starting system log daemon...
> [  OK  ]
> 
>  Apparently I do use swiotlb - I didn't know that, and can't see
> where it gets asked in menuconfig, but I can see
> CONFIG_SWIOTLB=y
> 
>  Let me know if there is anything else I can test (probably pm
> tomorrow), otherwise I'll go back to -head.

Yes testing head would be a good idea. It has a different bug fix
from Linus that is supposed to address this too. Unfortunately it is
still not known why it actually breaks; i had hoped to find that out
using the debugging patch

-Andi
