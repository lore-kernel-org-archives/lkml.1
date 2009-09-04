Return-Path: <linux-kernel-owner+w=401wt.eu-S933950AbZIDUNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933950AbZIDUNT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 16:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933927AbZIDUNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 16:13:18 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45058 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933884AbZIDUNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 16:13:18 -0400
Date: Fri, 4 Sep 2009 22:12:34 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mikael Pettersson <mikpe@it.uu.se>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Cox <alan@linux.intel.com>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [Bug #14015] pty regressed again, breaking expect and gcc's
 testsuite
Message-ID: <20090904221234.1b4ef2b8@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.00.0909040804450.23850@eeepc.linux-foundation.org>
References: <riPp5fx5ECC.A.2IG.qsGlKB@chimera>
	<19099.52899.620345.326521@pilspetsen.it.uu.se>
	<19100.31254.666066.755541@pilspetsen.it.uu.se>
	<200909012042.59856.rjw@sisk.pl>
	<alpine.LFD.2.00.0909021429360.3590@eeepc.linux-foundation.org>
	<19105.5352.28380.230615@pilspetsen.it.uu.se>
	<alpine.LFD.2.00.0909040729490.5232@eeepc.linux-foundation.org>
	<alpine.LFD.2.00.0909040739060.17375@eeepc.linux-foundation.org>
	<alpine.LFD.2.00.0909040753370.17375@eeepc.linux-foundation.org>
	<alpine.LFD.2.00.0909040804450.23850@eeepc.linux-foundation.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> After writing the above, the voices in my head started clamoring about 
> this "space allocated" vs "bytes buffered" thing, which I was obviously 
> aware of, but hadn't thought about as an issue.
> 
> And you know what? The thing about "space allocated" vs "bytes buffered" 
> is that writing _one_ byte (the '\r') can cause a lot more than one byte 
> to be allocated for a buffer (we do minimum 256-byte buffers)

Doh yes thats an utterly dumb bug on my part - we do have to work on
chars.

100% agree with the diagnosis
