Return-Path: <linux-kernel-owner+w=401wt.eu-S936322AbXHLPwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936322AbXHLPwt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 11:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762594AbXHLPwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 11:52:36 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:59603 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753318AbXHLPwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 11:52:34 -0400
Date: Sun, 12 Aug 2007 17:00:18 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: Finding out socket/pipe connectivity status
Message-ID: <20070812170018.6f56a0dd@the-village.bc.nu>
In-Reply-To: <Pine.LNX.4.64.0708121059160.28963@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0708121059160.28963@fbirervta.pbzchgretzou.qr>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> when a pipe/socket is broken, the process trying to read/write to it 
> gets SIGPIPE. Is there a way to detect whether the next read/write will 
> trigger a SIGPIPE? select() does not seem helpful here.

select considers the broken pipe an error that needs reporting so it goes
ready. Processes that are network aware normally set SIGPIPE to SIG_IGN.
The default behaviour comes from a desire that non aware programs
shouldn't get stuck spinning on a network error but go away.

If you ignore the signal you'll get a event from select, and then an
error code.
