Return-Path: <linux-kernel-owner+w=401wt.eu-S932763AbXHDSTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932763AbXHDSTS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 14:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765064AbXHDSTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 14:19:10 -0400
Received: from gateway.howardsilvan.com ([64.146.212.27]:33027 "EHLO
	mail.howardsilvan.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765016AbXHDSTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 14:19:08 -0400
Message-ID: <46B4C314.7020600@howardsilvan.com>
Date: Sat, 04 Aug 2007 11:19:00 -0700
From: Lee Howard <faxguy@howardsilvan.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060501 Fedora/1.7.13-1.1.fc4
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: "Maciej W. Rozycki" <macro@linux-mips.org>
CC: Robert Hancock <hancockr@shaw.ca>, linux-serial@vger.kernel.org,
       tytso@mit.edu, rmk@arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: serial flow control appears broken
References: <fa.Z6O0xFRT69zes0Mg+agt3Uiwux4@ifi.uio.no> <46A84B4A.6070902@shaw.ca> <46A8C6F1.4080309@howardsilvan.com> <Pine.LNX.4.64N.0707271216410.425@blysk.ds.pg.gda.pl> <46AA2748.80703@howardsilvan.com> <Pine.LNX.4.64N.0707271825220.425@blysk.ds.pg.gda.pl>
In-Reply-To: <Pine.LNX.4.64N.0707271825220.425@blysk.ds.pg.gda.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej W. Rozycki wrote:

>On Fri, 27 Jul 2007, Lee Howard wrote:
>
>  
>
>>Okay, so let's say we've got a loop around a blocking read on the modem file
>>descriptor...
>>
>> for (;;) {
>>     read some data from modem
>>     process data from modem
>>     if (end-of-data detected) break;
>> }
>>
>>Are you suggesting that the application should be using deasserting RTS after
>>the read and asserting it before?
>>    
>>
>
> It certainly could -- you were asking how it would know. ;-)
>

So, to test... I put this in the application before every read:

    int flags;
    ioctl(modemFd, TIOCMGET, &flags);
    flags |= TIOCM_RTS;
    ioctl(modemFd, TIOCMSET, &flags);

and this after:

    int flags;
    ioctl(modemFd, TIOCMGET, &flags);
    flags &= ~TIOCM_RTS;
    ioctl(modemFd, TIOCMSET, &flags);

Now I can see the RTS light blink on the modem (and during heavy 
communication it merely "dims" depending on the amount of delay in the 
processing.

However, it does not help.  Data still goes missing.

Thanks,

Lee.

