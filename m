Return-Path: <linux-kernel-owner+w=401wt.eu-S1754824AbZFHId6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824AbZFHId6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 04:33:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752966AbZFHIdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 04:33:50 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:46366 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818AbZFHIdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 04:33:49 -0400
Date: Mon, 8 Jun 2009 17:32:19 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
Message-Id: <20090608173219.0588af26.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4A2BEC4F.6020908@lwfinger.net>
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera>
	<D9VoutSOyXP.A.hvH.Ha7KKB@chimera>
	<4A2BBC30.2030300@lwfinger.net>
	<84144f020906070640rf5ab14nbf66d3ca7c97675f@mail.gmail.com>
	<4A2BCC6F.8090004@redhat.com>
	<84144f020906070732l31786156r5d9753a0cabfde79@mail.gmail.com>
	<4A2BEC4F.6020908@lwfinger.net>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 07 Jun 2009 11:35:27 -0500
Larry Finger <Larry.Finger@lwfinger.net> wrote:

> Pekka Enberg wrote:
> > On Sun, Jun 7, 2009 at 5:19 PM, Rik van Riel <riel@redhat.com> wrote:
> >> That is a very strange trace.  The Mem-Info indicates
> >> that the system has more than enough memory free, and
> >> also enough memory in higher-order free blocks.
> >>
> >> This would indicate a bug somewhere in the page
> >> allocator - this memory should have been given to this
> >> allocation request.
> > 
> > Aha, I always have difficulties deciphering the traces. But lets
> > invite Mel to the party then!
> 
> I'm happy to see some action on this problem. As usual, I'm happy to
> test patches and/or provide diagnostic output.
> 
One question. 

Did your system fragmented in same way as to this
(see DMA32, 10052 of order-0 pages) in older kernel ? I think you can check
fragmentation status via /proc/buddyinfo.
=
kernel: Node 0 DMA: 3*4kB 3*8kB 5*16kB 2*32kB 4*64kB 1*128kB 2*256kB 0*512kB
1*1024kB 0*2048kB 0*4096kB = 2100kB
kernel: Node 0 DMA32: 10062*4kB 1*8kB 1*16kB 0*32kB 1*64kB 1*128kB 0*256kB
1*512kB 0*1024kB 0*2048kB 0*4096kB = 40976kB
==

Thanks,
-Kame


