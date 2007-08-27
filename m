Return-Path: <linux-kernel-owner+w=401wt.eu-S1766009AbXG0TeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766009AbXG0TeB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 15:34:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762619AbXG0Tdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 15:33:52 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:57241
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758338AbXG0Tdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 15:33:51 -0400
Message-ID: <46D33636.7070200@microgate.com>
Date: Mon, 27 Aug 2007 14:38:14 -0600
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Tilman Schmidt <tilman@imap.cc>
CC: Lee Howard <faxguy@howardsilvan.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Robert Hancock <hancockr@shaw.ca>, linux-serial@vger.kernel.org,
       tytso@mit.edu, rmk@arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: serial flow control appears broken
References: <fa.Z6O0xFRT69zes0Mg+agt3Uiwux4@ifi.uio.no>	<46A84B4A.6070902@shaw.ca>	<46A8C6F1.4080309@howardsilvan.com> <20070726173121.70088a92@the-village.bc.nu> <46A98845.8010806@howardsilvan.com> <46A9F712.70706@imap.cc>
In-Reply-To: <46A9F712.70706@imap.cc>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tilman Schmidt wrote:
> Could this be related?
> 
> http://lkml.org/lkml/2007/7/18/245
> 
> Quote:
> "I've recently found (using 2.6.21.4) that configuring a serial ports
> (ST16654) which use the 8250 driver using setserial results in the
> UART's FIFOs being disabled (unless you specify autoconfig)."

That would make sense.

Lee's error is a hardware FIFO overrun which could occur
if the FIFO is being disabled as described in your
link (by trying to set the uart type with setserial).

Since the tty flow control is only triggered
by the line discipline in response to ldisc
buffer levels and not hardware FIFO overruns,
you would never see any flow control action
as reported by Lee.


-- 
Paul Fulghum
Microgate Systems, Ltd.
