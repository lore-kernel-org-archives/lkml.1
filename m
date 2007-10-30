Return-Path: <linux-kernel-owner+w=401wt.eu-S1755526AbXJ3QJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526AbXJ3QJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 12:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751958AbXJ3QJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 12:09:09 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41792 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751011AbXJ3QJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 12:09:08 -0400
Date: Tue, 30 Oct 2007 16:10:37 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Daniel Drake <dsd@gentoo.org>, linux list <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: "Fix ATAPI transfer lengths" causes CD writing regression
Message-ID: <20071030161037.54c41fff@the-village.bc.nu>
In-Reply-To: <472755A1.5080703@garzik.org>
References: <47274A5F.6070409@gentoo.org>
	<472755A1.5080703@garzik.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Any ideas?
> 
> hrm
> 
> we may need to make that controller-specific, given that the code prior 
> to 2db78dd302d26d242d3e8e5c4c5024b6c3ea93c2 was working for most...

Removing it breaks some devices on any controller.

I don't think this one is a simple compatibility issue - its a behaviour
we have done for ten years on PIIX/ICH chipsets without problems in the
old IDE. Also those logs of 66 bytes overrun are worrying - the app is
either issuing incorrectly sized commands, the drive is providing
incorrectly sized answers or something really evil is going on in the
midlayer translations.

And the ICH7 is in fact the chipset I did the original testing on ...

Need to work out if this is some nutty gentoo app, a quirky device we need
to dig into or something else. I've asked Daniel for some first test
points to try and eliminate the obvious.

Alan
