Return-Path: <linux-kernel-owner+w=401wt.eu-S1760660AbXHaP7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760660AbXHaP7r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 11:59:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758509AbXHaP7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 11:59:40 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:56384 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758340AbXHaP7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 11:59:38 -0400
Date: Fri, 31 Aug 2007 17:08:07 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "anon... anon.al" <anon.asdf@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: memory barrier to ensure copy_to_user() completes
Message-ID: <20070831170807.50d4394f@the-village.bc.nu>
In-Reply-To: <379fb4870708310825o70509368l490ac9063ce09866@mail.gmail.com>
References: <379fb4870708310825o70509368l490ac9063ce09866@mail.gmail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Which memory barrier do I require if I need to ensure that a
> copy_to_user(dest, src, len) completes before the next statement?

Define "completes"

> 
> copy_to_user(dest, src, len) ;
> //rmb(); OR wmb(); OR barrier(); OR mb(); ??????

Usually none of them

> If I'm writing to hardware, and need to ensure the correct order, I'll
> use wmb(), right?

No

> e.g.:
> 
> #define HW_address1 20
> #define HW_address2 40
> 
> *((int *)HW_address1) = 0x00000001;
> wmb();  // is this good???
> *((int *)HW_address2) = 0x00000010;

Linux doesn't define directly poking kernel addresses to hit hardware as
valid (and on many platforms it doesn't work). Use readl/writel and their
ordering is defined.

Read Documentation/io_ordering.txt and Docuemntation/pci.txt
