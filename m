Return-Path: <linux-kernel-owner+w=401wt.eu-S1764097AbXJZQKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764097AbXJZQKU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 12:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166AbXJZQKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 12:10:06 -0400
Received: from gateway-1237.mvista.com ([63.81.120.155]:58537 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753112AbXJZQKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 12:10:04 -0400
Message-ID: <47221164.10200@ru.mvista.com>
Date: Fri, 26 Oct 2007 20:10:12 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Russell King <rmk@arm.linux.org.uk>
Cc: linux-ide@vger.kernel.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jeff Garzik <jgarzik@pobox.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression: commit "ide: constify struct ide_port_info" causes
 breakage
References: <20071026155648.GB4321@flint.arm.linux.org.uk>
In-Reply-To: <20071026155648.GB4321@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Russell King wrote:

> commit 8562043606430185cad26d085d46adcc7ad67fd1 is broken, causing:

>   CC      drivers/ide/pci/cmd64x.o
>   CC      drivers/ide/pci/hpt366.o
> drivers/ide/pci/hpt366.c:1428: error: hpt366_chipsets causes a section type conflict

> and therefore should be reverted.
> 
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

> If we want ide_port_info to be read-only initdata, then we need
> __devroinitdata and __roinitdata tags.

    We can just convert cariables declared as 'struct hpt_info' to const too 
-- they are read-only templates.

MBR, Sergei
