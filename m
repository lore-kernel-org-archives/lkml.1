Return-Path: <linux-kernel-owner+w=401wt.eu-S937590AbXG0RxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937590AbXG0RxW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 13:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760760AbXG0RxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 13:53:14 -0400
Received: from pollux.ds.pg.gda.pl ([153.19.208.7]:1611 "EHLO
	pollux.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756911AbXG0RxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 13:53:13 -0400
Date: Fri, 27 Jul 2007 18:53:11 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Lee Howard <faxguy@howardsilvan.com>
cc: Robert Hancock <hancockr@shaw.ca>, linux-serial@vger.kernel.org,
       tytso@mit.edu, rmk@arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: serial flow control appears broken
In-Reply-To: <46AA2748.80703@howardsilvan.com>
Message-ID: <Pine.LNX.4.64N.0707271825220.425@blysk.ds.pg.gda.pl>
References: <fa.Z6O0xFRT69zes0Mg+agt3Uiwux4@ifi.uio.no> <46A84B4A.6070902@shaw.ca>
 <46A8C6F1.4080309@howardsilvan.com> <Pine.LNX.4.64N.0707271216410.425@blysk.ds.pg.gda.pl>
 <46AA2748.80703@howardsilvan.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jul 2007, Lee Howard wrote:

> Okay, so let's say we've got a loop around a blocking read on the modem file
> descriptor...
> 
>  for (;;) {
>      read some data from modem
>      process data from modem
>      if (end-of-data detected) break;
>  }
> 
> Are you suggesting that the application should be using deasserting RTS after
> the read and asserting it before?

 It certainly could -- you were asking how it would know. ;-)

> I had previously thought that the control of RTS was something that the
> serial/tty driver was supposed to do independently based on the buffer fill.

 The TTY line discipline driver could do that based on the amount of 
received data present in its buffer.  And it should if asked to (a brief 
look at drivers/char/n_tty.c reveals it does; obviously there may be a bug 
somewhere though).  So could e.g. the SLIP and PPP line discipline 
drivers, though the criteria might be different (apparently they do not, 
which is a shame).

 The serial drivers have nothing to do about it -- all they can do is 
pushing data upstream, to the discipline driver.  They can provide an 
interface to hardware flow control features though, if implemented by a 
given UART.

  Maciej
