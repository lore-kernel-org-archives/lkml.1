Return-Path: <linux-kernel-owner+w=401wt.eu-S1755446AbYDPXvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446AbYDPXvl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 19:51:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752883AbYDPXv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 19:51:29 -0400
Received: from [85.114.38.90] ([85.114.38.90]:42037 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752729AbYDPXv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 19:51:28 -0400
X-Greylist: delayed 1038 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Apr 2008 19:51:28 EDT
Date: Thu, 17 Apr 2008 00:24:37 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Frans Pop <elendil@planet.nl>
Cc: Tejun Heo <htejun@gmail.com>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: No IDE drivers loaded for Toshiba Satellite 320 CDS
Message-ID: <20080417002437.559ec164@the-village.bc.nu>
In-Reply-To: <200804162008.27655.elendil@planet.nl>
References: <200804021524.27222.elendil@planet.nl>
	<20080415144748.GO7385@csclub.uwaterloo.ca>
	<48053AD1.8010007@gmail.com>
	<200804162008.27655.elendil@planet.nl>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> The problem here is determining whether a machine is "legacy" or not.
> So far in this discussion I've seen no suggestions how to do that (except 
> maybe for my test whether /sys/bus/isa is present), which would mean asking 
> _all_ users, and that's a damned ugly option.

Libata pata_legacy handles this itself for all known cases using the
ruleset

IF any PCI device -> no PATA legacy scans beyond IDE0/IDE1
IF any PCI IDE in legacy compat mode  -> No pata_legacy bind to that port
IF CS55x0 or MPIIX -> read the chipset magic [these are the obscure 'not
PCI but not ISA' specials]

Alan
