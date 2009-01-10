Return-Path: <linux-kernel-owner+w=401wt.eu-S1754060AbZAJM1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbZAJM1h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 07:27:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752118AbZAJM12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 07:27:28 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44124 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751249AbZAJM11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 07:27:27 -0500
Date: Sat, 10 Jan 2009 12:21:30 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>, linux-ide@vger.kernel.org,
       Jeff Garzik <jgarzik@redhat.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: todays git: WARNING: at drivers/ata/libata-sff.c:1017
 ata_sff_hsm_move+0x45e/0x750()
Message-ID: <20090110122130.318cf168@lxorguk.ukuu.org.uk>
In-Reply-To: <49688B63.5030105@ru.mvista.com>
References: <200901091334.55823.borntraeger@de.ibm.com>
	<200901101009.13699.borntraeger@de.ibm.com>
	<20090110104114.633cacd8@lxorguk.ukuu.org.uk>
	<200901101242.05203.borntraeger@de.ibm.com>
	<49688B63.5030105@ru.mvista.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>    That's the typical REQUEST SENSE command with 18-byte data length.

Which means something has become horribly broken in the core libata stack.
An 18 byte inquiry would have 18 bytes as the *last* sg element. That
would therefore not trigger the WARN_ON. Someone has passed an sg list
that isn't properly terminated perhaps ?

I wonder if the pad code broke this.


