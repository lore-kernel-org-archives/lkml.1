Return-Path: <linux-kernel-owner+w=401wt.eu-S965649AbXAZNFJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965649AbXAZNFJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 08:05:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965650AbXAZNFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 08:05:09 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:57650 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965649AbXAZNFH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 08:05:07 -0500
Date: Fri, 26 Jan 2007 13:54:43 +0100
To: "Xavier Bestel" <xavier.bestel@free.fr>
Subject: Re: Bugfixes: PCI devices get assigned redundant IRQs
From: "Andreas Block" <andreas.block@esd-electronics.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII;
	format=flowed	delsp=yes
MIME-Version: 1.0
References: <op.tmrce0km8n9ctc@pc-block.esd> <1169809255.10952.178.camel@frg-rhel40-em64t-03>
Content-Transfer-Encoding: 7BIT
Message-ID: <op.tmrh5hxp8n9ctc@pc-block.esd>
In-Reply-To: <1169809255.10952.178.camel@frg-rhel40-em64t-03>
User-Agent: Opera Mail/9.10 (Win32)
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:7ee1d245d6d47e4a96dce2c88f0dd45f
X-Provags-ID2: V01U2FsdGVkX1+tg+Uv1Zu/UWJVZc2fGvTqImWVoLnBIGIWQ89GNeUJB3Xp6+ch9J982VtmqKG28G7jF93NNCEeRuPe0X+D5PMab8vWjMbPfdTcY6KqrmVm1w==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jan 2007 12:00:55 +0100, Xavier Bestel <xavier.bestel@free.fr>  
wrote:
> On Fri, 2007-01-26 at 11:50 +0100, Andreas Block wrote:
>
>>   	u8 pin, slot;
>> -	int irq;
>> +	int irq = 0;
>
> Aren't there platforms for which irq = 0 is a valid irq ?

As far as I understand the PCI spec, the answer to your question seems to  
be: no
(or I'm missing something).

Don't get me wrong. I'm not talking about system IRQs, but about the value  
of the Interrupt Pin Register in PCI configuration space.

The PCI Local Bus Specification in Revision 3.0 from 3rd February 2004  
says on page 223 about the content of Interrupt Pin register:

Value 0x00: _No_ interrupt
Values 0x01 to 0x04: Interrupt lines A to D
And values 5 to 0xFF are reserved.

So I'd say, the "correction" of greater values than four to a value of one  
seems discussable, too. Because it will break any future changes of the  
PCI spec.

Andreas

-- 
-------------------------------------------------------------------------

                             _/_/_/_/   Andreas Block
                            _/_/_/_/   Dipl.-Ing.
                           _/_/_/_/   andreas.block@esd-electronics.com

       _/_/_/   _/_/_/_/_/_/_/      esd electronic system design gmbh
     _/   _/  _/             _/    Vahrenwalder Str. 207
    _/   _/    _/_/_/   _/   _/   D-30165 Hannover
    _/             _/  _/   _/   Phone: +49-511-37298-0
     _/_/_/_/_/_/_/   _/_/_/    Fax:   +49-511-37298-68
                               http://www.esd-electronics.com

-------------------------------------------------------------------------
 
