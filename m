Return-Path: <linux-kernel-owner+w=401wt.eu-S1756180AbXKBOeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180AbXKBOeR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 10:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753909AbXKBOeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 10:34:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:51607 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784AbXKBOeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 10:34:06 -0400
Subject: Re: per BDI dirty limit (was Re: -mm merge plans for 2.6.24)
From: Kay Sievers <kay.sievers@vrfy.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Greg KH <greg@kroah.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>,
       Fengguang Wu <fengguang.wu@gmail.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Miklos Szeredi <miklos@szeredi.hu>
In-Reply-To: <1194013028.27652.387.camel@twins>
References: <1193410087.6914.34.camel@twins>
	 <1193412836.27652.11.camel@twins> <1193414147.2431.35.camel@lov.site>
	 <1193429066.5648.35.camel@lappy> <1193447889.5648.44.camel@lappy>
	 <20071027024033.GB29039@kroah.com> <1193474399.27652.15.camel@twins>
	 <20071027160203.GA5709@kroah.com> <1193519317.5776.14.camel@lov.site>
	 <1194009359.27652.377.camel@twins>
	 <3ae72650711020650l37870e45yb853f888b4807116@mail.gmail.com>
	 <1194013028.27652.387.camel@twins>
Content-Type: text/plain
Date: Fri, 02 Nov 2007 15:32:59 +0100
Message-Id: <1194013979.2440.20.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18fA5s21+GyOpgCC2WC74phKPnEfcMDHkfwpxQ
 Vp29YENshZvQbVTYZUCc8sFMg9+LmL8WrKLja/UxK+BiJmM+Pd
 HKymnboDJr4cydIaVWGI3vyGjetRCS1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-11-02 at 15:17 +0100, Peter Zijlstra wrote:
> One more question,
> 
> I currently prefix the names with "bdi-", is that needed?

Not really.

> That is, if I give the bdi object a parent, how will it look?
> Would a bdi device with name "sda" with a block device called "sda" as
> parent look like: /sys/block/sda/sda? Or would if be
> called /sys/block/sda/bdi:sda or just /sys/block/sda/bdi?

The class devices as childs get their own subdirectory at the parent. So
it would be /sys/block/sda/bdi/sda

It's currently only implemented for class devices which get a bus device
as a parent, but that will be for all parents, so that we prevent
clashing names if devices from multiple subsystems get the same parent.
See here for netdevs there is a "net" "glue directory":

  $ ls -l /sys/class/net/eth0
  /sys/class/net/eth0 -> ../../devices/pci0000:00/0000:00:1c.0/0000:02:00.0/net/eth0

We needed this, because people complained that they can't name their
netif "irq", because there is already an attribute at the parent with
that name. :)

When we get the "block as devices" patch merged, we can do the proper
parent logic for bdi, and I'll add the same logic as we have for bus
device parents today.

Kay

