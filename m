Return-Path: <linux-kernel-owner+w=401wt.eu-S1759199AbYDCPA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759199AbYDCPA4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 11:00:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757502AbYDCPAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 11:00:46 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50241 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757488AbYDCPAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 11:00:45 -0400
Subject: Re: [tainted,fglrx] page allocation failure: basic meaning of log
	messages?
From: Peter Zijlstra <peterz@infradead.org>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: "Andreas K. Huettel" <mail@akhuettel.de>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080403144852.GD24239@csclub.uwaterloo.ca>
References: <alpine.LNX.1.00.0804031117030.10277@localhost>
	 <20080403183021.028C.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <alpine.LNX.1.00.0804031318480.10277@localhost>
	 <20080403144852.GD24239@csclub.uwaterloo.ca>
Content-Type: text/plain
Date: Thu, 03 Apr 2008 17:00:30 +0200
Message-Id: <1207234830.8514.838.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-04-03 at 10:48 -0400, Lennart Sorensen wrote:
> On Thu, Apr 03, 2008 at 01:22:40PM +0200, Andreas K. Huettel wrote:
> > -----BEGIN PGP SIGNED MESSAGE-----
> > Hash: RIPEMD160
> > 
> > 
> > Hi, 
> > 
> > #]> Apr  3 09:01:30 bellini hal-system-powe: page allocation failure. order:10, mode:0x4020
> > #]> Apr  3 09:01:30 bellini Pid: 327, comm: hal-system-powe Tainted: PF       2.6.24-gentoo-r3 #1
> > #]> Apr  3 09:01:30 bellini [<c0140c48>] __alloc_pages+0x2bd/0x2ce
> > #]> Apr  3 09:01:30 bellini [<c0140c92>] __get_free_pages+0x39/0x47
> > #]> Apr  3 09:01:30 bellini [<f8adcd9e>] firegl_cmmqs_save_fb+0x8e/0x200 [fglrx]
> > #]
> > #]this messages doesn't mean bug, merely indicate allocation failure.
> > #]if any other bad thind doen't happend, you can ignore it.
> > 
> > Swapping like mad without any obvious cause (500M swap in use, 1.5G RAM 
> > - - which is normally not such a big problem). This however stopped when 
> > I closed some memory-intensive applications (firefox, vmware).
> > 
> > Since then the machine is running without problems. 
> 
> firefox 2.x tends to leak memory like crazy in my experience, so it may
> be perfectly normal.  If you have adobe's flash plugin firefox can leak
> very quickly too.

An order 10 alloc (4 mb contiguous) isn't likely to succeed by any
measure. Lumpy reclaim will try very hard and likely cause that swap
storm you taked about, but relying on order 10 allocs is insane.

