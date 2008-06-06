Return-Path: <linux-kernel-owner+w=401wt.eu-S1754827AbYFFJbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827AbYFFJbf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 05:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752991AbYFFJb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 05:31:28 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41406 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752951AbYFFJb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 05:31:27 -0400
Date: Fri, 6 Jun 2008 10:15:25 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/18] firmware: moving drivers to request_firmware()
Message-ID: <20080606101525.3f2fdb57@core>
In-Reply-To: <4848648D.8010501@garzik.org>
References: <20080605.foo@pmac.infradead.org>
	<4848648D.8010501@garzik.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> * firmware should be field-replaceable, even if one was compiled in

If you want to replace it then put it in the file system. You've said
binuntils isn't acceptable in your "vision" below so field replacing
compiled in ones clearly is. It's a needless overcomplication.

> * the preferred form of firmware is one or more binary blobs, stored in 
> a regular [filesystem|git] binary file.

That depends on the firmware. In a few cases we even have firmware source
in the tree.

> * in-tree firmwares should be stored in one or more binary files in the 
> tree, not in C source code or .ihex files.
> 
> * when firmware is stored as binary blob, it is easier for
> 	(1) vendor to replace,

Nope, they can't submit a diff to the tree except as an attachment which
will be dropped if you do that. 

> 	(2) developer/user to compare/verify using sha1,

sha1 doesn't appear to be totally secure for that purpose with a firmware
block any more. Putting the sha1 in the header might be a good idea in
some cases (eg DaveM wants to be sure precisely *which* tg3 firmware he
loads)

> 	(3) does not require a C compiler or binutils to unpack

Why ? What is the usage scenario ? Vendor distributed firmware for PC
class systems is going to be a deb or rpm that drops files
into ../lib/firmware.

> Thus, if you are going to be touching the in-tree firmwares at all, it 
> doesn't make sense to convert from C source to any format other than 
> native binary.

You don't mean native binary either. Native binary on some of these
devices is very strange indeed. Its simply bytes in various random
formats for stuffing into the device in various random ways - that's not
really "native" in all cases.

Alan
