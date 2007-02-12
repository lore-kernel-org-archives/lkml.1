Return-Path: <linux-kernel-owner+w=401wt.eu-S965035AbXBLR4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965035AbXBLR4f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 12:56:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965031AbXBLR4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 12:56:35 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:9057 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965035AbXBLR4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 12:56:34 -0500
Message-ID: <45D0AA49.8060006@ru.mvista.com>
Date: Mon, 12 Feb 2007 20:56:25 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Marc St-Jean <Marc_St-Jean@pmc-sierra.com>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org
Subject: Re: [PATCH] serial driver PMC MSP71xx, kernel linux-mips.git mast
  er
References: <45D0A7DA.1040305@pmc-sierra.com>
In-Reply-To: <45D0A7DA.1040305@pmc-sierra.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Marc St-Jean wrote:

>> >> > Fourth attempt at the serial driver patch for the PMC-Sierra MSP71xx
>> >>device.

>>    I think you need to submit your patch to Andrew Morton since it 
>>requires a patch from his tree.

> OK, will do.

    In fact, since the serial drivers are not maintained anymore, this seems 
the only option.

>> >> > +                     /* The DesignWare APB UART has an Busy Detect
>> >>(0x07)
>> >> > +                      * interrupt meaning an LCR write attempt
>> >>occured while the
>> >> > +                      * UART was busy. The interrupt must be cleared
>> >>by reading
>> >> > +                      * the UART status register (USR) and the LCR
>> >>re-written. */
>> >> > +                     unsigned int status;
>> >> > +                     status = *(volatile u32 
>>*)up->port.private_data;
>> >> > +                     serial_out(up, UART_LCR, up->lcr);
>> >> > +
>> >> > +                     handled = 1;
>> >> > +
>> >> > +                     end = NULL;
>> >> >               } else if (end == NULL)
>> >> >                       end = l;

>> >> >       return 0;

>> >>    Still, shouldn't you be doing this in serial8250_timeout()

>> > No, the serial8250_timeout is for issue 1 at the top, this is for
>> > issue 2.

>>    It's for lost interrupts, IIUC. They use anothe timeout handler for the
>>workaround...

> This issue (2) is a completely new type of interrupt generated but the
> DesignWare APB uart, it has nothing to do with lost interrupts.

    Yeah, I just thought that the lost interrupts might be a "generic" issue.

>> >>also?
>> >>What IRQ numbers this UART is using, BTW?

>> > For the ports on the device they are 27 and 42. Is there any 
>>significance
>> > that I'm not aware of?

>>    Yeah, IRQ0 is treated as no IRQ by 8250, and in this case it falls 
>>back to using serial8250_timeout() to handle "interrupts".

> Good to know. It won't be affecting us then.

    This may be overriden anyway...

>> >>    Oops, your mailer went and did it again. :-)

>> > I'm completely giving up on Thunderbird,unless someone can point out

>>    Ypu should have long ago. :-)

>> > the specific internal configuration items which needs a kick!

>>    Only the attachments will work in the Mozilla kind mailer, AFAIK.
>>The last patch looked OK at last. :-)

> The attachemnents appear to be MIME which is a no-no according the

    The text/plain type attachments seem to be acceptable for the most 
maintainers.  This Mozilla can do, at least. :-)

> linux FAQ at kernel.org. I guess I'll stick with /bin/mail.

> Thanks,
> Marc

WBR, Sergei
