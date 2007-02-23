Return-Path: <linux-kernel-owner+w=401wt.eu-S933209AbXBWUsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933209AbXBWUsa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 15:48:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933211AbXBWUsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 15:48:30 -0500
Received: from email13.mywebmailserver.com ([199.231.136.143]:4006 "EHLO
	email13.mywebmailserver.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933209AbXBWUs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 15:48:29 -0500
Message-ID: <45DF531B.5090505@kuchera.com>
Date: Fri, 23 Feb 2007 15:48:27 -0500
From: Rob Prowel <prowel@kuchera.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.9) Gecko/20070104 Red Hat/1.0.7-0.6.fc5 SeaMonkey/1.0.7
MIME-Version: 1.0
To: Rob Prowel <prowel@kuchera.com>, linux-kernel@vger.kernel.org,
       rmk+lkml@arm.linux.org.uk
Subject: Re: questions about 8250 uart support for adhoc boards
References: <45DF1EEC.4040602@kuchera.com> <20070223202116.GA3000@flint.arm.linux.org.uk>
In-Reply-To: <20070223202116.GA3000@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Feb 2007 20:48:27.0501 (UTC) FILETIME=[F7EE51D0:01C7578B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks so much for your followup.


Russell King wrote:
> On Fri, Feb 23, 2007 at 12:05:48PM -0500, Rob Prowel wrote:
>   
>> At least now, with fourport compiled into the kernel,
>>     
>
> You don't even need to do that.  Just configure SERIAL_8250_NR_UARTS
> and SERIAL_8250_RUNTIME_UARTS appropriately for your system.  There's
> absolutely no need to build any of the additional modules.
>
>   
Unfortunately what I'm seeing in 2.6.20.1 seems to differ from this.  If 
I use the options below:

CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=32
CONFIG_SERIAL_8250_RUNTIME_UARTS=16
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
# CONFIG_SERIAL_8250_FOURPORT is not set
# CONFIG_SERIAL_8250_ACCENT is not set
# CONFIG_SERIAL_8250_BOCA is not set
# CONFIG_SERIAL_8250_EXAR_ST16C554 is not set
# CONFIG_SERIAL_8250_HUB6 is not set
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y
# Non-8250 serial port support

Then I can only access ttyS0 through ttyS3 sith setserial.  Only after I add
CONFIG_SERIAL_8250_FOURPORT=y am I actually able to do anything with the 
additional ports.  I would otherwise get the evil setserial: invalid 
parameter error.

If you'd like I can offline you my complete .config file.  lemme know.

>> I can use 
>> setserial to see the uarts and correctly identify them...but the shared 
>> interrupt vector doesn't seem to work.  I haven't even attempted yet to 
>> try stty or echoing data our to an o-scope.
>>     
>
> I dropped support for the shared interrupt vector - having multiple
> different ISRs depending on the way the wind was blowing was extremely
> complex, and in this day and age of GHz CPUs rather silly.
>
> The serial driver can still share interrupts just fine.  Just omit
> configuring the multiport address and masks.
>
>   

OK.  Fair enough.  My question then becomes, how does the driver deal 
with this now? scan all applicable uarts when any relevant interrupt is 
detected (as identified in setserial)?


Thanks.



