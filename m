Return-Path: <linux-kernel-owner+w=401wt.eu-S1759908AbYDNN5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759908AbYDNN5c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 09:57:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753892AbYDNN5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 09:57:24 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46646 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753494AbYDNN5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 09:57:23 -0400
Date: Mon, 14 Apr 2008 14:53:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Cc: Tejun Heo <htejun@gmail.com>, Frans Pop <elendil@planet.nl>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: No IDE drivers loaded for Toshiba Satellite 320 CDS
Message-ID: <20080414145302.4239b0b9@core>
In-Reply-To: <20080414134734.GB7385@csclub.uwaterloo.ca>
References: <200804021524.27222.elendil@planet.nl>
	<200804021820.04610.elendil@planet.nl>
	<20080402194938.GI24237@csclub.uwaterloo.ca>
	<200804031947.07674.elendil@planet.nl>
	<48017248.4030600@gmail.com>
	<20080414134734.GB7385@csclub.uwaterloo.ca>
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

> If a driver supports a device with dual interfaces, then it better
> reserve both sets of ports to prevent the generic driver from trying to
> use them.

That isn't the problem. The generic driver doesn't know if there is
another valid driver for the ports - how can it - and the other driver
may not be loaded first so cannot reserve the ports. If you load the
generic driver last then you should be fine, and the link order for IDE
and libata puts acpi, pci generic and legacy at the end for good reason.

Libata pata_legacy has some smarts in this area but they are only good
for the common cases.

Alan
