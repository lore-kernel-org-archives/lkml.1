Return-Path: <linux-kernel-owner+w=401wt.eu-S1752014AbYIJLIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014AbYIJLIR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 07:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526AbYIJLIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 07:08:05 -0400
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:42848 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751131AbYIJLIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 07:08:04 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: forcedeth: option to disable 100Hz timer (try 2)
To: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ayaz Abdulla <aabdulla@nvidia.com>, Jeff Garzik <jgarzik@pobox.com>
Reply-To: 7eggert@gmx.de
Date: Wed, 10 Sep 2008 13:16:02 +0200
References: <baho5-34g-25@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1KdNg3-0001N5-Al@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com> wrote:

> On some hardware no TX done interrupts are generated, thus special
> 100Hz timer interrupt is required to handle this situation properly.
> Other device do not require that timer interrupt feature.
> 
> Forcedeth has a DEV_NEED_TIMERIRQ flag to mark the broken devices.
> Unfortunately, nobody know the actual list of broken devices, so all
> device has this flag on. Other problem, this flag is not user visible,
> so the kernel recompilation is required to disable timer interrupts and
> test a device.

Why don't you disable the interrupt after the first TX_done interrupt
(no RX pending, no RX done)? Maybe you can printk "forcedeth device [x,y] does
not need timer interrupts, please send this line to you@example.org", too.
Maybe you can even disable it if no TX is to be done.

OTOH, this fix is available, it's possibly the best to use it for now.

