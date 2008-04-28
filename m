Return-Path: <linux-kernel-owner+w=401wt.eu-S934035AbYD1MPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934035AbYD1MPz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 08:15:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932089AbYD1MPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 08:15:48 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:46728 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765863AbYD1MPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 08:15:47 -0400
Date: Mon, 28 Apr 2008 14:15:26 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, i2c@lm-sensors.org
Subject: Re: [i2c] i2c or eeprom enumeration problem
Message-ID: <20080428141526.2f4e993f@hyperion.delvare>
In-Reply-To: <20080428050515.fcc05689.akpm@linux-foundation.org>
References: <4815509A.9040802@redhat.com>
	<20080428050515.fcc05689.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2008 05:05:15 -0700, Andrew Morton wrote:
> On Sun, 27 Apr 2008 21:20:42 -0700 Ulrich Drepper <drepper@redhat.com> wrote:
> 
> > -----BEGIN PGP SIGNED MESSAGE-----
> > Hash: SHA1
> > 
> > On a NUMA system the eeprom interface in /sys
> > 
> >   /sys/bus/i2c/drivers/eeprom/*
> > 
> > do not list all the DRAM eeproms.  Only the DRAM from one node is
> > listed.  I have a 4 socket system with all 16 banks filled and see only
> > 4 entries.
> > 
> > My suspicion (without looking at any code) is that the list of i2c
> > devices with eeproms is collected once and this happens only on one CPU.
> >  I sees not to be dynamic since when I read the files with taskset
> > restricting execution on certain sockets and cores the result doesn't
> > change.
> > 
> > Is this known or expected (I hope not the latter)?  Where should I look
> > at?  I assume that's in the i2c code?
> > 
> 
> Let's cc the i2c list.

Motherboard manufacturer and model?

Most likely the SMBus is multiplexed and each CPU gets it's own SMBus
segment, as was seen on the Tyan S4882. The EEPROMs you see are the
ones on the segment which happens to be active at boot time.

The i2c subsystem (still) doesn't support that properly, although we
have a quirk for the Tyan S4882 (see
drivers/i2c/busses/i2c-amd756-s4882.c).

-- 
Jean Delvare
