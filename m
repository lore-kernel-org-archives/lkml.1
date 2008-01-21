Return-Path: <linux-kernel-owner+w=401wt.eu-S1755355AbYAUOQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbYAUOQ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 09:16:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072AbYAUOQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 09:16:47 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46409 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753039AbYAUOQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 09:16:46 -0500
Date: Mon, 21 Jan 2008 14:14:25 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tejun Heo <htejun@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Georgi Chulkov <g.chulkov@jacobs-university.de>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Mark Lord <liml@rtr.ca>
Subject: Re: ATA device reset, shoud I be concerned?
Message-ID: <20080121141425.45aa9c61@lxorguk.ukuu.org.uk>
In-Reply-To: <47949AA4.9090601@gmail.com>
References: <200801140019.20668.g.chulkov@jacobs-university.de>
	<20080115025435.1e21b703.akpm@linux-foundation.org>
	<20080115113552.75731bf8@lxorguk.ukuu.org.uk>
	<4794501E.90306@gmail.com>
	<20080121130256.2443d7c1@lxorguk.ukuu.org.uk>
	<47949AA4.9090601@gmail.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> while IDE thinks that IRQ might be lost and complete the command if the
> TF status register says so.

For PATA at least that makes a lot of sense. It would probably make the
Promise driver a lot more stable too.

> It could be that the particular device doesn't raise IRQ on certain
> error conditions but updates TF registers.  After timeout, IDE completes
> the command with the indicated error while libata ignores the status and
> resets the device.

And loses the important information like media errors
 
> libata never touches TF register after timeout because some controllers
> lock up hard if TF register is read after certain error conditions
> (event the status register).

Should that not then be a per host flag ?

Alan
