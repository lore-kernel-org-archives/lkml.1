Return-Path: <linux-kernel-owner+w=401wt.eu-S1757860AbYEEKj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757860AbYEEKj6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 06:39:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752630AbYEEKju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 06:39:50 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:34519 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751348AbYEEKjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 06:39:49 -0400
Date: Mon, 5 May 2008 11:30:55 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: rmk@arm.linux.org.uk, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG] NULL pointer dereference in uart_write_room().
Message-ID: <20080505113055.5284052e@core>
In-Reply-To: <200805041716.DDG43279.JOSMHVFOFFQLOt@I-love.SAKURA.ne.jp>
References: <261636618@web.de>
	<200805022300.GIB30385.FJOVHQSMFtOOFL@I-love.SAKURA.ne.jp>
	<200805041716.DDG43279.JOSMHVFOFFQLOt@I-love.SAKURA.ne.jp>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> (5) uart_remove_one_port() is called by serial8250_register_port()
>     since ttyS0 is already in use but it is requested to be once removed.

That means 8250_pnp is taking over and then trying to delete the console,
so its breakage in the serial layer glue. Perhaps Russell has some ideas
as its hard to tell what he intended to happen originally.

Alan
