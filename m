Return-Path: <linux-kernel-owner+w=401wt.eu-S1753239AbYGVS2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbYGVS2J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 14:28:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752643AbYGVS1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 14:27:55 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59650 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751869AbYGVS1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 14:27:54 -0400
Date: Tue, 22 Jul 2008 19:10:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Alan Cox <alan@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: pata_it821x completely broken
Message-ID: <20080722191022.0417f45c@lxorguk.ukuu.org.uk>
In-Reply-To: <200807221959.53669.linux@rainbow-software.org>
References: <200807042153.56644.linux@rainbow-software.org>
	<200807122342.12841.linux@rainbow-software.org>
	<200807131347.14045.linux@rainbow-software.org>
	<200807221959.53669.linux@rainbow-software.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> New patch below, this time with DMA forced on RAID volumes - as my firmware
> does not identify the RAID arrays as DMA capable :(

The underlying problem is that the newer libata rewrites the dev->id data
in ways that we can't then patch up. I've actually been hacking on this a
bit today. The existing it821x code was working fine and it does the
needed patching, it just needs to do it in a different place, and that in
turn needs a new ap->ops->read_id() method so it can be hooked.

On the bright side that also allows us to implement a pata_mfm/rll
driver at last.

Alan

