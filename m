Return-Path: <linux-kernel-owner+w=401wt.eu-S1763029AbXJZSNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763029AbXJZSNV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 14:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755554AbXJZSNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 14:13:07 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:62100 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755519AbXJZSNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 14:13:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=HrTacz49lbwao5sYPsLhU7aY2w/4E74EQrbEYYfOwW0y7f1ZpyoabmtN5+PyKQeoC9Aqc31qr5xweWAyndKe0QZ1vPd/hHHc3Gd+F0R/TMzmLsTQAC2P/mBi/or9YNXX9sZIWkAPtgzDano8OlxPeG85K8PdTCR5wrg6H83mD2Y=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Russell King <rmk@arm.linux.org.uk>
Subject: Re: Regression: commit "ide: constify struct ide_port_info" causes breakage
Date: Fri, 26 Oct 2007 20:18:14 +0200
User-Agent: KMail/1.9.7
Cc: linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20071026155648.GB4321@flint.arm.linux.org.uk>
In-Reply-To: <20071026155648.GB4321@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710262018.14815.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 October 2007, Russell King wrote:
> commit 8562043606430185cad26d085d46adcc7ad67fd1 is broken, causing:
> 
>   CC      drivers/ide/pci/cmd64x.o
>   CC      drivers/ide/pci/hpt366.o
> drivers/ide/pci/hpt366.c:1428: error: hpt366_chipsets causes a section type conflict
> 
> and therefore should be reverted.

Fixed 3 days ago, patch was posted to LKML.

http://lkml.org/lkml/2007/10/23/411

[ Will be pushed to Linus together with few other fixes soon. ]

> The problem arises because hpt366 has other data marked with __devinitdata,
> so the compiler tries to define the initdata section with read-write
> attributes at one point, and read-only attributes when encountering the
> const-but-devinitdata declaration:
> 
> static struct hpt_info hpt36x __devinitdata = {
> static struct hpt_info hpt370 __devinitdata = {
> static struct hpt_info hpt370a __devinitdata = {
> ...
> static const struct ide_port_info hpt366_chipsets[] __devinitdata = {
> 
> If we want ide_port_info to be read-only initdata, then we need
> __devroinitdata and __roinitdata tags.

http://lkml.org/lkml/2007/10/23/412

Thanks,
Bart
