Return-Path: <linux-kernel-owner+w=401wt.eu-S937388AbXHLSr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937388AbXHLSr4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 14:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932753AbXHLSrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 14:47:48 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:36691 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751284AbXHLSrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 14:47:47 -0400
Date: Sun, 12 Aug 2007 19:55:25 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Fredrik Noring <noring@nocrew.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Improving read/write/close system call reliability when used
 with pthreads
Message-ID: <20070812195525.20dbb6fc@the-village.bc.nu>
In-Reply-To: <A94120FD-315A-45B7-A8F4-8DC8DC21279E@nocrew.org>
References: <70E19A0A-2728-4ADA-B984-A36182C1F575@nocrew.org>
	<20070812161337.3828381c@the-village.bc.nu>
	<A94120FD-315A-45B7-A8F4-8DC8DC21279E@nocrew.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> POSIX appears to leave it "implementation-defined" provided I  
> interpret this correctly, of course. So wouldn't it be great to make  
> one of the current results a reliable feature?

Given that 99.99% of programs don't appear to care and you materially
slow down a critical path for every read and write I'm skeptical. 

Teaching the pipe code specifically to behave more nicely in this case
might be worthwhile (and as it happens with sockets in the same case you
can use shutdown() before close to get your preferred behaviour)

Alan
