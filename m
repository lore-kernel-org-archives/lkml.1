Return-Path: <linux-kernel-owner+w=401wt.eu-S1751283AbXBMLPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751283AbXBMLPy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 06:15:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751286AbXBMLPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 06:15:54 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57596 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751283AbXBMLPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 06:15:53 -0500
Date: Tue, 13 Feb 2007 11:27:58 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Arjan van de Ven <arjan@infradead.org>
Cc: "Martin A. Fink" <fink@mpe.mpg.de>, Matthias Schniedermeyer <ms@citd.de>,
       linux-kernel@vger.kernel.org
Subject: Re: SATA-performance: Linux vs. FreeBSD
Message-ID: <20070213112758.5920a28e@localhost.localdomain>
In-Reply-To: <1171361290.12771.77.camel@laptopd505.fenrus.org>
References: <200702121502.17130.fink@mpe.mpg.de>
	<200702121856.29729.fink@mpe.mpg.de>
	<45D0F8EE.7020604@citd.de>
	<200702131025.15964.fink@mpe.mpg.de>
	<1171361290.12771.77.camel@laptopd505.fenrus.org>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> there's several tunables you can do;
> 1) increase /sys/block/<device>/queue/nr_requests
>    the linux default is on the low side
> 5) echo a larger value into /sys/block/<device>/queue/max_sectors_kb
>    the default seems to be 512 which is... really low. The hw max is in
>    another file in that directory; if you want max throughput set the
>    max_sectors_kb value to the hw max. (you pay in terms of fairness for


There are two more factors that play into #1 and #5. Firstly there is a
per command completion overhead in ATA without NCQ being active and that
isn't yet a heavily optimised libata path. Secondly erase block size
matters with flash drives so the bigger each I/O the better erase block
behaviour we should get.
