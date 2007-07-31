Return-Path: <linux-kernel-owner+w=401wt.eu-S1755700AbXGaJmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700AbXGaJmi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 05:42:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752961AbXGaJmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 05:42:31 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:60643 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752327AbXGaJma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 05:42:30 -0400
Date: Tue, 31 Jul 2007 10:49:45 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Manuel Reimer <Manuel.Spam@nurfuerspam.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Whats the problem with my IDE...
Message-ID: <20070731104945.4411c85b@the-village.bc.nu>
In-Reply-To: <f8mvg9$rc8$1@sea.gmane.org>
References: <f8mvg9$rc8$1@sea.gmane.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> After mounting my four LVs, formatted with XFS, here, I'm starting to 
> delete all files on those LVs to be able to do a fresh linux install. 
> While deleting, I get *many* DMA errors and "BAD CRC" messages.

Bad CRC indicates a data transfer problem between the drive and the
controller. The CRC is computed one end and verified the other. The OS
isn't directly involved.

This usually means either
#1 A 40 wire cable in use for > UDMA33
#2 A drive plugged into the middle of the cable and none on the end
#3 The short part of the cable connected between a drive and the
controller not the long part

And occassionally it may indicate power, iffy connectors or electrical
noise problems.

Theoretically it can also be caused by the kernel misprogramming the
timings but the old VIA IDE driver is very well tested in this area and
the one bug I know it has with timing it always sets to be excessively
safe not problematic.
