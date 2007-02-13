Return-Path: <linux-kernel-owner+w=401wt.eu-S1751233AbXBMKI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751233AbXBMKI2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 05:08:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbXBMKI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 05:08:28 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:45150 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbXBMKI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 05:08:27 -0500
Subject: Re: SATA-performance: Linux vs. FreeBSD
From: Arjan van de Ven <arjan@infradead.org>
To: "Martin A. Fink" <fink@mpe.mpg.de>
Cc: Matthias Schniedermeyer <ms@citd.de>, linux-kernel@vger.kernel.org
In-Reply-To: <200702131025.15964.fink@mpe.mpg.de>
References: <200702121502.17130.fink@mpe.mpg.de>
	 <200702121856.29729.fink@mpe.mpg.de> <45D0F8EE.7020604@citd.de>
	 <200702131025.15964.fink@mpe.mpg.de>
Content-Type: text/plain
Organization: Intel International BV
Date: Tue, 13 Feb 2007 11:08:10 +0100
Message-Id: <1171361290.12771.77.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> The problem is: FreeBSD is fast, but lacks of some special drivers. Linux has 
> all drivers but access to harddisk is unpredictable and thus unreliable!
> What can I do??


there's several tunables you can do;
1) increase /sys/block/<device>/queue/nr_requests
   the linux default is on the low side
2) investigate other elevators; cfq is great for interactive use but not
so great for max throughput. you can do this by echo'ing "deadline"
into /sys/block/<device>/scheduler
3) make sure ext3 is set to "data=writeback"; the default journalling
mode is very strict, fine for smallish files but for multi-gigabyte
it'll start to hurt
4) try to use iostat -x /dev/<foo>  1 to see what values avg-rq and
avg-qu are.. avg-rq should be at least several hundred if not more.
5) echo a larger value into /sys/block/<device>/queue/max_sectors_kb
   the default seems to be 512 which is... really low. The hw max is in
   another file in that directory; if you want max throughput set the
   max_sectors_kb value to the hw max. (you pay in terms of fairness for
   this; it's the eternal fairness/latency versus throughput tradeoff)



