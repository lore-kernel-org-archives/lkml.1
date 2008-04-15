Return-Path: <linux-kernel-owner+w=401wt.eu-S1762229AbYDOKJI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762229AbYDOKJI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 06:09:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756638AbYDOKI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 06:08:56 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55184 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756292AbYDOKIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 06:08:55 -0400
Date: Tue, 15 Apr 2008 11:04:19 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tejun Heo <htejun@gmail.com>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Frans Pop <elendil@planet.nl>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: No IDE drivers loaded for Toshiba Satellite 320 CDS
Message-ID: <20080415110419.785a75ee@core>
In-Reply-To: <480414E6.2090205@gmail.com>
References: <200804021524.27222.elendil@planet.nl>
	<200804021820.04610.elendil@planet.nl>
	<20080402194938.GI24237@csclub.uwaterloo.ca>
	<200804031947.07674.elendil@planet.nl>
	<48017248.4030600@gmail.com>
	<20080414134734.GB7385@csclub.uwaterloo.ca>
	<20080414145302.4239b0b9@core>
	<480414E6.2090205@gmail.com>
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

> Always loading generic or ata_generic used to be safe.  It's still 
> pretty safe but not as much as before.  Nowadays, there are good number 

ata_generic is always safe unless you force it to grab every class
device. By default it grabs only those devices we know obey the class
interface well enough and for which we have no proper driver (usually
because there are no documents). Ditto for ide/pci/generic.

The trickier one is pata_legacy, which tries to be smart and knows about
the known exception so *should* always be safe. The old IDE legacy driver
lacks these smarts so in some cases will do the wrong thing even if
loaded last.

Alan
