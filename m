Return-Path: <linux-kernel-owner+w=401wt.eu-S1764587AbXHLPGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764587AbXHLPGs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 11:06:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936096AbXHLPGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 11:06:06 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:50939 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S936084AbXHLPGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 11:06:03 -0400
Date: Sun, 12 Aug 2007 16:13:37 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Fredrik Noring <noring@nocrew.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Improving read/write/close system call reliability when used
 with pthreads
Message-ID: <20070812161337.3828381c@the-village.bc.nu>
In-Reply-To: <70E19A0A-2728-4ADA-B984-A36182C1F575@nocrew.org>
References: <70E19A0A-2728-4ADA-B984-A36182C1F575@nocrew.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> For (1), a simple scenario has two threads: a reader and a watchdog.  
> The reader thread is stuck in a blocking read of an unreliable pipe.  
> The watchdog thread is designed to cancel the blocking read using  
> close on the reader's fd.

The reader still has the fd open so the fd is not yet closed. This seems
completely sane to me. Closing the *writer* fd would create an EOF which
is the proper response.

Alan
