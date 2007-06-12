Return-Path: <linux-kernel-owner+w=401wt.eu-S1757376AbXFLHxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376AbXFLHxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 03:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754055AbXFLHxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 03:53:11 -0400
Received: from bill.weihenstephan.org ([82.135.35.21]:52477 "EHLO
	bill.weihenstephan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739AbXFLHxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 03:53:10 -0400
From: Juergen Beisert <juergen127@kreuzholzen.de>
Organization: Privat
To: linux-kernel@vger.kernel.org
Subject: Re: ext2 on flash memory
Date: Tue, 12 Jun 2007 09:53:03 +0200
User-Agent: KMail/1.9.4
Cc: "Kevin Bowling" <lkml@kev009.com>
References: <20070611101319.GA14284@DervishD> <191337B7-F4CC-4824-B669-48AE194BE141@sbcglobal.net> <11f674920706111735l7dec2136t32d40ee2ab4ccca4@mail.gmail.com>
In-Reply-To: <11f674920706111735l7dec2136t32d40ee2ab4ccca4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706120953.03735.juergen127@kreuzholzen.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 June 2007 02:35, Kevin Bowling wrote:
> All of the posts fail to address the question here: what is the
> correct file system, or does one exist yet, for wear leveling flash
> storage.
> JFFS2 and logfs are nice for MTD, but for better flash 
> memories that are likely to be used in the future like solid state
> hard disks, what is the answer?

As long the device itself does the wear leveling, there could no specific 
answer here!
On MTD its the job of the filesystem to do the wear leveling because it works 
on the bare flash. But memory sticks, CFs and so on emulate a block device. I 
don't know a device where you could switch off its internal wear leveling 
mechanism. So it makes no sense to find the best filesystem for such a case. 
There is no best one.

Its the same discussion about protecting essential data on CF by using more 
than one partition. A first partition for read only (system), a second one 
also for writing (data). And everyone hopes in the case of a crash the read 
only partition survives. But CFs internal wear leveling does not know 
partitions and continuous to use *all* blocks on the CF for its job.

Juergen
