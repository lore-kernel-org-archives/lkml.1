Return-Path: <linux-kernel-owner+w=401wt.eu-S1751733AbXA2PGH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751733AbXA2PGH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 10:06:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751872AbXA2PGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 10:06:06 -0500
Received: from lmv.inov.pt ([146.193.64.2]:32892 "EHLO lmv.inov.pt"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733AbXA2PGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 10:06:05 -0500
Message-ID: <45BE0D44.1080309@inov.pt>
Date: Mon, 29 Jan 2007 15:05:40 +0000
From: Jose Goncalves <jose.goncalves@inov.pt>
User-Agent: Thunderbird 1.5.0.9 (X11/20070111)
MIME-Version: 1.0
To: Frederik Deweerdt <deweerdt@free.fr>
CC: linux-kernel@vger.kernel.org
Subject: Re: Oops on serial access on kernel 2.6.16.38
References: <45BA2341.40008@inov.pt> <20061226201003.GA2990@slug> <45BA459F.7060604@inov.pt> <20070126212203.GB2990@slug>
In-Reply-To: <20070126212203.GB2990@slug>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-INOV-EmailServer-Information: Please contact the Email service provider for more information
X-INOV-EmailServer: Found to be clean
X-INOV-EmailServer-From: jose.goncalves@inov.pt
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Frederik Deweerdt wrote:
> On Fri, Jan 26, 2007 at 06:17:03PM +0000, Jose Goncalves wrote:
>   
>> Frederik Deweerdt wrote:
>>     
>>> On Fri, Jan 26, 2007 at 03:50:25PM +0000, Jose Goncalves wrote:
>>>   
>>>       
>>>> I'm having a problem with the latest 2.6.16 kernel (I've found the
>>>> problem on 2.6.16.37 and 2.6.16.38). I have a application that retreives
>>>> data from a GPS connected on a serial port. From time to time a get a
>>>> kernel Oops, like this:
>>>>
>>>>     
>>>>         
>>> Could you send your .config?
>>>   
>>>       
>> Here it goes...
>>
>>     
> Thanks. It looks like something is wrong with port->ops->startup() in
> uart_startup(), could you apply the following patch and report the
> results? And btw, you're using a plain 8250 serial port, isn't it?
>   

OK. I've applied the patch and I'm now waiting for the kernel Oops...
sometimes it takes two days until it happens.
I'm using a standard 16550A serial controller found on my hardware, that
is a PC/104 SBC:

 http://www.icop.com.tw/products_detail.asp?ProductID=70

We have a custom hardware that has another serial controller (TL16C554A)
with 4 extra serial ports (also, 16550A type), and the problem happens
in a test program that is retreiving data from ttyS0 (from the SBC) and
ttyS3 (from our custom hardware).
The serial ports initialization, as reported by the kernel:

[   15.216847] Serial: 8250/16550 driver $Revision: 1.90 $ 6 ports, IRQ
sharing disabled
[   15.219517] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   15.221963] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[   15.223907] serial8250: ttyS2 at I/O 0x3e8 (irq = 5) is a 16550A
[   15.225757] serial8250: ttyS3 at I/O 0x2e8 (irq = 5) is a 16550A
[   15.227644] serial8250: ttyS4 at I/O 0x1a0 (irq = 6) is a 16550A
[   15.229656] serial8250: ttyS5 at I/O 0x1a8 (irq = 6) is a 16550A

With your patch I'm now getting the following for each iteration of my
test program:

<4>[  298.918962] type is 4
<4>[  298.919011] ops is c0292f00
<4>[  298.919033] ops->startup is c01bd777
<4>[  299.436980] type is 4
<4>[  299.437030] ops is c0292f00
<4>[  299.437051] ops->startup is c01bd777

I don't know if it's relevant or not but the kernel is running in
NFS-Root mode.

Best regards,
José Gonçalves
