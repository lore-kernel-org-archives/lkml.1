Return-Path: <linux-kernel-owner+w=401wt.eu-S1756196AbZAJN6I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196AbZAJN6I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 08:58:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752953AbZAJN5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 08:57:52 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42515 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752701AbZAJN5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 08:57:51 -0500
Date: Sat, 10 Jan 2009 13:57:31 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeff Garzik <jeff@garzik.org>, Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [bisected] Re: todays git: WARNING: at
 drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x45e/0x750()
Message-ID: <20090110135731.0da08c90@lxorguk.ukuu.org.uk>
In-Reply-To: <20090110133617.GA22304@elte.hu>
References: <200901091334.55823.borntraeger@de.ibm.com>
	<200901101009.13699.borntraeger@de.ibm.com>
	<20090110104114.633cacd8@lxorguk.ukuu.org.uk>
	<200901101242.05203.borntraeger@de.ibm.com>
	<49688B63.5030105@ru.mvista.com>
	<20090110122130.318cf168@lxorguk.ukuu.org.uk>
	<20090110130745.GA14049@elte.hu>
	<49689EA8.20506@garzik.org>
	<20090110132412.GB14049@elte.hu>
	<20090110133617.GA22304@elte.hu>
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

On Sat, 10 Jan 2009 14:36:17 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > build its random kernel and reboot into it (800 MHz P3), so i started a 
> > full automated bisection instead driven from a faster box.
> 
> and the winner is:
> 
> | 871af1210f13966ab911ed2166e4ab2ce775b99d is first bad commit
> | commit 871af1210f13966ab911ed2166e4ab2ce775b99d
> | Author: Alan Cox <alan@redhat.com>
> | Date:   Mon Jan 5 14:16:39 2009 +0000
> |
> |     libata: Add 32bit PIO support
> 
> And the revert below does the trick.

Unfortunately it only hides the bug - that code doesn't change the sg
lists being passed, it just catches out anyone who pasts a non divisble
by four malformed sg list.

The real bug is still there
