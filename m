Return-Path: <linux-kernel-owner+w=401wt.eu-S1762903AbXLQNiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762903AbXLQNiR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 08:38:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762511AbXLQNh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 08:37:59 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:49522 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762497AbXLQNh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 08:37:58 -0500
Date: Mon, 17 Dec 2007 13:30:53 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Steven Winikoff <smw@alcor.concordia.ca>
Cc: linux-kernel@vger.kernel.org, Sheila Ettinger <sheilae@alcor.concordia.ca>,
       Tan Bui <tan@alcor.concordia.ca>, Tao Wang <taow@alcor.concordia.ca>,
       Gillian Roper <groper@alcor.concordia.ca>,
       Sylvain Robitaille <syl@alcor.concordia.ca>
Subject: Re: 2.6.23.8: OOM killer kills wrong jobs
Message-ID: <20071217133053.508dbab0@the-village.bc.nu>
In-Reply-To: <304323.1197868809@alcor.concordia.ca>
References: <9xMQB-5XC-25@gated-at.bofh.it>
	<9xHQH-6oR-5@gated-at.bofh.it>
	<304323.1197868809@alcor.concordia.ca>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ...but I've run into a situation in which a system on which I *have* set
> no overcommit is being blasted by the OOM killer anyway.

Looks like the kernel is eating all the resources needed.

>    Linux babyalcor 2.6.23.1 #1 SMP Fri Oct 26 15:35:18 EDT 2007 \
>     i686 Dual Core AMD Opteron(tm) Processor 280 AuthenticAMD GNU/Linux

32bit kernel, 16GB of RAM. 

No suprise I'm afraid. Handling 16GB on a 32bit kernel, which has to
manage it all through a small addressible memory window is right on the
limit of what the standard kernel will handle (8GB is probably as high as
I would go). The no overcommit code ensures that user space doesn't
overcommit, but the kernel can get itself short of low memory resources
on a big box with 32bit kernels very easily. (In 64bit mode the CPU can
address all the memory directly so the problem vanishes).

You will *probably* get stable 16GB with the vendor tuned enterprise
kernels (RHEL, CentOS etc), or run a 64bit kernel and then the kernel
isn't trying the software equivalent of managing a filing cabinet through
the keyhole.

Alan
