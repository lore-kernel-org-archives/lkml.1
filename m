Return-Path: <linux-kernel-owner+w=401wt.eu-S1754925AbZIJOGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925AbZIJOGS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 10:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752145AbZIJOGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 10:06:17 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59549 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752090AbZIJOGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 10:06:16 -0400
Date: Thu, 10 Sep 2009 15:07:16 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Alan Cox <alan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] char/tty_io: fix legacy pty name when more than 256 pty
 devices are requested
Message-ID: <20090910150716.66310f02@lxorguk.ukuu.org.uk>
In-Reply-To: <20090910093301.4ccfd786@caramujo.chehab.org>
References: <20090908144942.76ddf0e7@caramujo.chehab.org>
	<4AA6DF50.3030603@zytor.com>
	<20090908203323.486c129c@caramujo.chehab.org>
	<4AA6F63F.7090009@zytor.com>
	<20090908235441.04549a29@caramujo.chehab.org>
	<4AA73309.8030302@zytor.com>
	<20090910010512.60a1f523@caramujo.chehab.org>
	<4AA89B02.1050909@zytor.com>
	<20090910093301.4ccfd786@caramujo.chehab.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> * The remaining nibbles are represented by one of 0123456789abcdef letters,
>   indicating the 1st through 16th nibble value, starting from the most
>   significative nibble to the least significative nibble, excluding the
>   second nibble (that were already represented).

This is a real step back.

It now wastes all the tty[e-p]%d namespace. ttyp%d for > 255 at least
only uses one for this irrelevant area.

I actually have another proposal having reviewed the user space code.

Limit the BSD ptys to 256. Nothing uses them, the C library routines for
their allocation would need glibc modifying (which takes about five years
for a tty change it seems anyway). It's basically a huge amount of work
for no purpose at all.

So lets limit BSD ptys (unused anyway) to 256 and be done with it.


Alan
