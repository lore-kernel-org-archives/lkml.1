Return-Path: <linux-kernel-owner+w=401wt.eu-S937088AbXG0UGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937088AbXG0UGk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 16:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763283AbXG0UGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 16:06:31 -0400
Received: from gateway.howardsilvan.com ([64.146.212.27]:55694 "EHLO
	mail.howardsilvan.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763522AbXG0UGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 16:06:30 -0400
Message-ID: <46AA4FFB.9010402@howardsilvan.com>
Date: Fri, 27 Jul 2007 13:05:15 -0700
From: Lee Howard <faxguy@howardsilvan.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060501 Fedora/1.7.13-1.1.fc4
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Tilman Schmidt <tilman@imap.cc>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Robert Hancock <hancockr@shaw.ca>,
       linux-serial@vger.kernel.org, tytso@mit.edu, rmk@arm.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: serial flow control appears broken
References: <fa.Z6O0xFRT69zes0Mg+agt3Uiwux4@ifi.uio.no>	<46A84B4A.6070902@shaw.ca>	<46A8C6F1.4080309@howardsilvan.com> <20070726173121.70088a92@the-village.bc.nu> <46A98845.8010806@howardsilvan.com> <46A9F712.70706@imap.cc>
In-Reply-To: <46A9F712.70706@imap.cc>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tilman Schmidt wrote:

>Lee Howard schrieb:
>  
>
>>So, does this explain why I wouldn't have a problem at 115200 bps with 
>>kernel 2.2.5 but why I do with 2.6.5 and 2.6.18?  Both hardware and 
>>software flow control work fine with 2.2.5 (meaning I don't see any 
>>error message and I don't have any data corruption), but neither works 
>>to avoid the "kernel: ttyS1: 1 input overrun(s)" and consequent data 
>>corruption issue in 2.6.5 nor 2.6.18.
>>
>>Was there some associated application change in tty handling that needed 
>>to occur between the 2.2 and 2.6 kernels to properly implement flow control?
>>    
>>
>
>Could this be related?
>
>http://lkml.org/lkml/2007/7/18/245
>
>Quote:
>"I've recently found (using 2.6.21.4) that configuring a serial ports
>(ST16654) which use the 8250 driver using setserial results in the
>UART's FIFOs being disabled (unless you specify autoconfig)."
>  
>

I'm not running setserial on the port, myself.  But to test to see if it 
is related, I included this code in the application:

#include <linux/serial.h>
....
struct serial_struct serial;
ioctl(modemFd, TIOCGSERIAL, &serial);
traceModemOp("modem xmit_fifo_size: %u", serial.xmit_fifo_size);

And I get this resulting logging:

"MODEM modem xmit_fifo_size: 16"

So it's clear from here that the xmit_fifo_size is set correctly on this 
system.

Thanks,

Lee.

