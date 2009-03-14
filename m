Return-Path: <linux-kernel-owner+w=401wt.eu-S1754080AbZCNIrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080AbZCNIrz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 04:47:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751667AbZCNIrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 04:47:46 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50009 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751542AbZCNIrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 04:47:45 -0400
Date: Sat, 14 Mar 2009 08:48:27 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Norman Diamond <n0diamond@yahoo.co.jp>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, Jim Paris <jim@jtan.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Mark Lord <liml@rtr.ca>
Subject: Re: Off-by-one in both LIBATA and IDE drivers
Message-ID: <20090314084827.2f2b05c2@lxorguk.ukuu.org.uk>
In-Reply-To: <49BB1341.2020203@gmail.com>
References: <20090313074120.48682.qmail@web4108.mail.ogk.yahoo.co.jp>
	<49BA7172.80908@gmail.com>
	<A88EBC06918A4B0789B55D31ECDAF1BB@DIAMOND8600>
	<49BB1341.2020203@gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ata_piix should definitely attach to 8086/7111 regardless of the 
> subsystem IDs. I can't really explain why it's not. You should at least 
> be seeing a message about the ata_piix version, if not then somehow the 
> driver probe function isn't even being called..

Because on at least some kernels

hda=noprobe ... etc

does not stop the old IDE layer grabbing the PCI device and continuing to
claim ownership (which means ATA cannot attach to it). Arguably this is
correct behaviour as the IDE layer was asked to ignore the devices *NOT*
to ignore the controller.

Alan
