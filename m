Return-Path: <linux-kernel-owner+w=401wt.eu-S932283AbYGBLaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932283AbYGBLaj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 07:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755479AbYGBLaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 07:30:19 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53720 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754128AbYGBLaS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 07:30:18 -0400
Date: Wed, 2 Jul 2008 12:11:53 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, Uwe.Kleine-Koenig@digi.com, gregkh@suse.de,
       akpm@linux-foundation.org, hjk@linutronix.de, lethal@linux-sh.org,
       Magnus Damm <magnus.damm@gmail.com>, tglx@linutronix.de
Subject: Re: [PATCH] uio: User IRQ Mode
Message-ID: <20080702121153.4d464885@lxorguk.ukuu.org.uk>
In-Reply-To: <20080702105951.22648.2197.sendpatchset@rx1.opensource.se>
References: <20080702105951.22648.2197.sendpatchset@rx1.opensource.se>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Jul 2008 19:59:51 +0900
Magnus Damm <magnus.damm@gmail.com> wrote:

> From: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
> 
> This patch adds a "User IRQ Mode" to UIO. In this mode the user space driver
> is responsible for acknowledging and re-enabling the interrupt.
> Shared interrupts are not supported by this mode.

This doesn't work even for some non shared interrupts.

If I take a level triggered interrupt then the IRQ handler code must
clear the IRQ before the line can be unmasked.

It might work for edge triggered providing you don't get too many edges
before you respond (in which case we will decide its a stuck IRQ and turn
it off for good).
