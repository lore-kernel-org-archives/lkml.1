Return-Path: <linux-kernel-owner+w=401wt.eu-S1755866AbYEZV7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866AbYEZV7w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 17:59:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753572AbYEZV7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 17:59:42 -0400
Received: from orion.ambsoft.pl ([212.109.144.130]:52002 "EHLO
	orion.ambsoft.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbYEZV7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 17:59:41 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Neil Brown <neilb@suse.de>
Subject: Re: x86_64 panic on latest linux-2.6
Date: Mon, 26 May 2008 23:59:36 +0200
User-Agent: KMail/1.9.9
Cc: Adrian Bunk <bunk@kernel.org>, kernel-testers@vger.kernel.org,
       linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
References: <200805251051.33781.m.kozlowski@tuxland.pl> <20080525204229.GL1791@cs181133002.pp.htv.fi> <18489.63400.560248.222094@notabene.brown>
In-Reply-To: <18489.63400.560248.222094@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805262359.37088.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> > > 	My x86_64 box is not willing to boot.
> > > 
> > > http://tuxland.pl/tmp/s7300372.jpg (275kB)
> > > 
> > > (gdb) p blk_lookup_devt
> > > $1 = {dev_t (const char *, int)} 0xffffffff8032a430 <blk_lookup_devt>
> > > (gdb) l *(0xffffffff8032a430+0x7f)
> > > 0xffffffff8032a4af is in blk_lookup_devt (block/genhd.c:664).
> > > 659             dev_t devt = MKDEV(0, 0);
> > > 660     
> > > 661             mutex_lock(&block_class_lock);
> > > 662             list_for_each_entry(dev, &block_class.devices, node) {
> > > 663                     if (strcmp(dev->bus_id, name) == 0) {
> > > 664                             struct gendisk *disk = dev_to_disk(dev);
> > > 665     
> > > 666                             if (part < disk->minors)
> > > 667                                     devt = MKDEV(MAJOR(dev->devt),
> > > 668                                                  MINOR(dev->devt) + part);
> 
> Having decoded the "Code:", what is happening here is that 'dev' is
> clearly not embedded inside a 'disk'.
> The address of 'dev' is in RBX and is ffff81007f270010.
> disk->minors is at and offset of -0x60 from 'dev' (as 'dev' is assumed
> to be a structure embeded in a 'struct gendisk' - dev_to_disk uses
> container_of to find the gendisk that holds the device).  But 0x60 from RBX
> is in a different page, and presumably that memory doesn't exist.
> 
> So the question is: how can a 'struct device' which is not part of
> a 'struct gendisk' be on 'block_class.devices'.
> 
> Unfortunately, I have no idea.

2.6.26-rc4 works fine :/ Am I lucky or not? I'll do some more tests on weekend.

Thanks,

	Mariusz

