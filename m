Return-Path: <linux-kernel-owner+w=401wt.eu-S1756509AbZBKKFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509AbZBKKFf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 05:05:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754672AbZBKKF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 05:05:27 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56101 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754441AbZBKKF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 05:05:26 -0500
Date: Wed, 11 Feb 2009 10:05:57 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Keith Mannthey <kmannth@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>
Subject: Re: [RFC][Patch] IBM Real-Time "SMI Free" mode driver
Message-ID: <20090211100557.634529ae@lxorguk.ukuu.org.uk>
In-Reply-To: <1234312633.15410.546.camel@keith-laptop>
References: <1234312633.15410.546.camel@keith-laptop>
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

> +	/*get the address for the RTL table from the EBDA */
> +	ebda_addr = *(unsigned short *)phys_to_virt(0x40E);
> +	ebda_addr <<= 4;
> +	ebda_size = 64*1024;

Second problem - you'll crash some systems with the assumptions here

> +	for (i = 0 ; i < ebda_size/4; i++) {
> +		unsigned int *tmp = (unsigned int *) data++;
> +		if (*tmp == RTL_MAGIC_IDENT) {
> +			table_addr = ebda_addr + i;
> +			ret = rtl_setup_sysfs();
> +			goto exit;
> +		}
> +	}

Some machines place the EBDA in the top pages of the low 640K. Your 64K
walk will continue into ISA MMIO space which isn't safe to blindly read.

Alan
