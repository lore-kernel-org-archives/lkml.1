Return-Path: <linux-kernel-owner+w=401wt.eu-S1754081AbXFYKQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081AbXFYKQV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 06:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751530AbXFYKQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 06:16:10 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:45017 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbXFYKQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 06:16:08 -0400
Message-ID: <467F95D8.6000805@tw.ibm.com>
Date: Mon, 25 Jun 2007 18:15:52 +0800
From: Albert Lee <albertcc@tw.ibm.com>
Reply-To: albertl@mail.com
User-Agent: Mozilla Thunderbird 1.0.6 (Windows/20050716)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Robert de Rooy <robert.de.rooy@gmail.com>
CC: Mark Lord <liml@rtr.ca>, Tejun Heo <htejun@gmail.com>,
       Mark Lord <mlord@pobox.com>, Jeff Garzik <jeff@garzik.org>,
       bzolnier@gmail.com, linux-pcmcia@lists.infradead.org,
       linux-kernel@vger.kernel.org,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: libata and legacy ide pcmcia failure
References: <466718B6.4080105@gmail.com> <4667B39D.209@gmail.com> <46685AE5.4010908@gmail.com> <466900F3.7040801@gmail.com> <46694FB2.6040007@pobox.com> <4669D2D8.3020806@gmail.com> <4669D3F5.7040300@rtr.ca> <466B4D86.1020808@gmail.com> <466C631D.2000001@rtr.ca> <466C723C.6000300@gmail.com> <20070610221322.GA18196@flint.arm.linux.org.uk> <466C7A9F.1080700@rtr.ca> <466DCE55.30507@gmail.com> <466DCF43.5060304@pobox.com> <466E11DF.5020901@gmail.com> <466F4A27.8070309@tw.ibm.com> <46710CD7.9070901@gmail.com> <467BB7DB.4090004@gmail.com> <467BCF86.8060508@rtr.ca> <467F3EDC.2060002@tw.ibm.com> <467F8B8B.1000006@gmail.com>
In-Reply-To: <467F8B8B.1000006@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert de Rooy wrote:
> Albert Lee wrote:
> 
>> Mark Lord wrote:
>>  
>>
>>> ...
>>>
>>> Mmm.. I don't know about the first failure there,
>>> but after that it gets into the "stuck DRQ" state
>>> which libata makes no attempt to handle at present.
>>>
>>>     
>>
>>
>> It seems the pata_pcmcia driver is using IRQ driven PIO. Maybe Robert
>> could try the following pio_polling patch first.
>>   
> 
> 
> I did not get the chance to try Marks patch, but the pio_polling patch
> from Albert works!!
> 
> 

The patch just workarounds the "lost irq" problem by polling; not real
fix. We still need to find out why irq is lost per Mark's comment:

"This proves that the device does work correctly in most respects
except for interrupt delivery.  The status bits are working and
it can be probed for, configured, and used."

"So, next step might be to try and understand the interrupt mis-delivery
problem some more.   I've lost the history of the original issue,
but we now know that everything except the actual interrupt seems good."

I am not familiar with the PCMCIA interrupt delivery. It seems the
"Dazzle 4in1 Card Adapter" works under windows but somehow lost irq
under both IDE and libata. Maybe Alan/Bart or the PCMCIA developers
know better...
--
albert

