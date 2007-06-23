Return-Path: <linux-kernel-owner+w=401wt.eu-S1759786AbXFWRa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759786AbXFWRa1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 13:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756105AbXFWRaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 13:30:20 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41768 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754389AbXFWRaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 13:30:19 -0400
Date: Sat, 23 Jun 2007 10:29:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Carlo Wood <carlo@alinoe.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Arjan van de Ven <arjan@infradead.org>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org
Subject: Re: SATA Harddisk speed drop of 100 MB/s
Message-Id: <20070623102949.09e36fb9.akpm@linux-foundation.org>
In-Reply-To: <20070623025906.GA24336@alinoe.com>
References: <20070620224847.GA5488@alinoe.com>
	<4679B2DE.9090903@garzik.org>
	<1182397012.2863.0.camel@laptopd505.fenrus.org>
	<20070622162142.GA603@alinoe.com>
	<20070622211746.GB21769@khazad-dum.debian.net>
	<20070622212758.GA6970@alinoe.com>
	<20070623013132.GA1702@khazad-dum.debian.net>
	<20070623025906.GA24336@alinoe.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Jun 2007 04:59:06 +0200 Carlo Wood <carlo@alinoe.com> wrote:

> On Fri, Jun 22, 2007 at 10:31:32PM -0300, Henrique de Moraes Holschuh wrote:
> > for i in /sys/block/sd*/queue/scheduler ; do echo -n "scheduler for $i was:" ; cat $i ; echo anticipatory > $i ; done
> > 
> > Should show you the scheduler for all libata/scsi discs, and switch to
> > anticipatory.  It probably works for hd* as well, but I don't have any
> > around to test.
> > 
> > I had ridiculous md raid performance (on resync) using cfq at least once.
> > Unfortunately I never bothered trying to track it down, and I didn't check
> > the throughput after the resync was done either. Also, I don't recall the
> > kernel version, but it was either 2.6.18 or 2.6.20.
> 
> Just one kernel version? The problem here is in every
> kernel revision after 551c012d7eea3dc5ec063c7ff9c718d39e77634f
> 
> 2.6.20-rc2,rc3,rc4,rc5,rc6,rc7 ... 2.6.20 ... 2.6.21 ... 2.6.22-rc5
> 
> noop:
>  Timing buffered disk reads:  254 MB in  3.00 seconds =  84.66 MB/sec
> 
> anticipatory:
>  Timing buffered disk reads:  252 MB in  3.02 seconds =  83.43 MB/sec
> 
> deadline:
>  Timing buffered disk reads:  258 MB in  3.02 seconds =  85.41 MB/sec
> 
> cfq:
>  Timing buffered disk reads:  194 MB in  3.03 seconds =  64.06 MB/sec
> 
> The normal value is cfq. So, all other schedulars are somewhat faster,
> but still far from the correct 165 MB/s.
> 

Please see http://bugzilla.kernel.org/show_bug.cgi?id=8636

In that report a pretty large slowdown with CFQ has been identified.
Jens has plunked a patch in there (Comment #50) and then ran away on
vacation.

If someone can test that patch and demonstrate its goodness, I'll
queue it up, thanks.
