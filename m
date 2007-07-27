Return-Path: <linux-kernel-owner+w=401wt.eu-S937536AbXG0RNH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937536AbXG0RNH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 13:13:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937490AbXG0RMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 13:12:51 -0400
Received: from gateway.howardsilvan.com ([64.146.212.27]:48015 "EHLO
	mail.howardsilvan.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937473AbXG0RMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 13:12:50 -0400
Message-ID: <46AA2748.80703@howardsilvan.com>
Date: Fri, 27 Jul 2007 10:11:36 -0700
From: Lee Howard <faxguy@howardsilvan.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060501 Fedora/1.7.13-1.1.fc4
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: "Maciej W. Rozycki" <macro@linux-mips.org>
CC: Robert Hancock <hancockr@shaw.ca>, linux-serial@vger.kernel.org,
       tytso@mit.edu, rmk@arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: serial flow control appears broken
References: <fa.Z6O0xFRT69zes0Mg+agt3Uiwux4@ifi.uio.no> <46A84B4A.6070902@shaw.ca> <46A8C6F1.4080309@howardsilvan.com> <Pine.LNX.4.64N.0707271216410.425@blysk.ds.pg.gda.pl>
In-Reply-To: <Pine.LNX.4.64N.0707271216410.425@blysk.ds.pg.gda.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej W. Rozycki wrote:

>On Thu, 26 Jul 2007, Lee Howard wrote:
>
>  
>
>>If the application were to use TIOCM_RTS how would it know when to apply it or
>>not?  Is there some approach that the application could take to manage flow
>>control on the serial port?  What about software flow control?  Does the
>>    
>>
>
> Well, an application could negate RTS when it receives a character and 
>is running out of resources for further processing of incoming data.
>
> Smarter UARTs may be able to negate RTS themselves based on the amount of 
>data in their receive FIFO.  The threshold may be configurable.
>

Okay, so let's say we've got a loop around a blocking read on the modem 
file descriptor...

  for (;;) {
      read some data from modem
      process data from modem
      if (end-of-data detected) break;
  }

Are you suggesting that the application should be using deasserting RTS 
after the read and asserting it before?

I had previously thought that the control of RTS was something that the 
serial/tty driver was supposed to do independently based on the buffer 
fill.  Was I wrong?

Thanks,

Lee.
