Return-Path: <linux-kernel-owner+w=401wt.eu-S932687AbXCGEne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932687AbXCGEne (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 23:43:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932773AbXCGEnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 23:43:33 -0500
Received: from smtp.osdl.org ([65.172.181.24]:47641 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932696AbXCGEnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 23:43:31 -0500
Date: Tue, 6 Mar 2007 20:39:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andre Noll <maan@systemlinux.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Jens Axboe <jens.axboe@oracle.com>, Alasdair G Kergon <agk@redhat.com>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: qla2xxx BUG: workqueue leaked lock or atomic
Message-Id: <20070306203952.471218df.akpm@linux-foundation.org>
In-Reply-To: <20070228153722.GJ22572@skl-net.de>
References: <20070226133153.GC4095@skl-net.de>
	<20070226182617.GC9968@andrew-vasquezs-computer.local>
	<20070227101100.GA22572@skl-net.de>
	<20070227185134.GJ20397@andrew-vasquezs-computer.local>
	<20070228151829.GI22572@skl-net.de>
	<20070228153722.GJ22572@skl-net.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Feb 2007 16:37:22 +0100 Andre Noll <maan@systemlinux.org> wrote:

> On 16:18, Andre Noll wrote:
> 
> > With 2.6.21-rc2 I am unable to reproduce this BUG message. However,
> > writing to both raid systems at the same time via lvm still locks up
> > the system within minutes.
> 
> Screenshot of the resulting kernel panic:
> 
> 	http://systemlinux.org/~maan/shots/kernel-panic-21-rc2-huangho2.png
> 

It died in CFQ.  Please try a different IO scheduler.  Use something
like

	echo deadline > /sys/block/sda/queue/scheduler

This could still be the old qla2xxx bug, or it could be a new qla2xxx bug,
or it could be a block bug, or it could be an LVM bug.

Adrian, can we please track this as a regression?
