Return-Path: <linux-kernel-owner+w=401wt.eu-S936569AbXHLSej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936569AbXHLSej (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 14:34:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761586AbXHLSe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 14:34:29 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:60092 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757354AbXHLSe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 14:34:28 -0400
Date: Sun, 12 Aug 2007 19:42:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: Finding out socket/pipe connectivity status
Message-ID: <20070812194210.210db3a3@the-village.bc.nu>
In-Reply-To: <Pine.LNX.4.64.0708121808470.28963@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0708121059160.28963@fbirervta.pbzchgretzou.qr>
	<20070812170018.6f56a0dd@the-village.bc.nu>
	<Pine.LNX.4.64.0708121808470.28963@fbirervta.pbzchgretzou.qr>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 	write(stdout, request);
> 	/* reference point [A] */
> 	read(stdin, response);
> 
> So my idea had been to launch another thread that monitors stdin for
> 'breakage' and unmount the fs before a user can start an operation on
> myfs. So I've been trying to complete the idea to code. You say a
> broken socket raises the read flag, so:

Your connection can break at any point even mid-write so you must handle
it. You have no real choice.

You can try and spot it earlier by using select/poll and checking for
error. In which case I'd use poll() as it is a bit more clear about what
event you get

Then poll stdin and stdout. The kernel will give you back 

POLLERR - an error condition
POLLHUP - a hangup

if at the point you poll an error has already occurred. You can do this
with select and the socket error and related stuff buts its uglier

Alan
 

