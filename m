Return-Path: <linux-kernel-owner+w=401wt.eu-S1751482AbXFWC7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751482AbXFWC7T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 22:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750948AbXFWC7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 22:59:10 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:8340 "EHLO
	viefep34-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750936AbXFWC7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 22:59:09 -0400
Date: Sat, 23 Jun 2007 04:59:06 +0200
From: Carlo Wood <carlo@alinoe.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Arjan van de Ven <arjan@infradead.org>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org
Subject: Re: SATA Harddisk speed drop of 100 MB/s
Message-ID: <20070623025906.GA24336@alinoe.com>
Mail-Followup-To: Carlo Wood <carlo@alinoe.com>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Arjan van de Ven <arjan@infradead.org>,
	Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org
References: <20070620224847.GA5488@alinoe.com> <4679B2DE.9090903@garzik.org> <1182397012.2863.0.camel@laptopd505.fenrus.org> <20070622162142.GA603@alinoe.com> <20070622211746.GB21769@khazad-dum.debian.net> <20070622212758.GA6970@alinoe.com> <20070623013132.GA1702@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070623013132.GA1702@khazad-dum.debian.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2007 at 10:31:32PM -0300, Henrique de Moraes Holschuh wrote:
> for i in /sys/block/sd*/queue/scheduler ; do echo -n "scheduler for $i was:" ; cat $i ; echo anticipatory > $i ; done
> 
> Should show you the scheduler for all libata/scsi discs, and switch to
> anticipatory.  It probably works for hd* as well, but I don't have any
> around to test.
> 
> I had ridiculous md raid performance (on resync) using cfq at least once.
> Unfortunately I never bothered trying to track it down, and I didn't check
> the throughput after the resync was done either. Also, I don't recall the
> kernel version, but it was either 2.6.18 or 2.6.20.

Just one kernel version? The problem here is in every
kernel revision after 551c012d7eea3dc5ec063c7ff9c718d39e77634f

2.6.20-rc2,rc3,rc4,rc5,rc6,rc7 ... 2.6.20 ... 2.6.21 ... 2.6.22-rc5

noop:
 Timing buffered disk reads:  254 MB in  3.00 seconds =  84.66 MB/sec

anticipatory:
 Timing buffered disk reads:  252 MB in  3.02 seconds =  83.43 MB/sec

deadline:
 Timing buffered disk reads:  258 MB in  3.02 seconds =  85.41 MB/sec

cfq:
 Timing buffered disk reads:  194 MB in  3.03 seconds =  64.06 MB/sec

The normal value is cfq. So, all other schedulars are somewhat faster,
but still far from the correct 165 MB/s.

-- 
Carlo Wood <carlo@alinoe.com>
