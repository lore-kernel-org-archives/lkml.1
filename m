Return-Path: <linux-kernel-owner+w=401wt.eu-S1756251AbXLHEsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251AbXLHEsk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 23:48:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753403AbXLHEsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 23:48:31 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:19626 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453AbXLHEsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 23:48:30 -0500
Date: Fri, 07 Dec 2007 22:47:57 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: 2.6.24-rc4-mm1 and Very Slow PCMCIA Compact Flash
In-reply-to: <fa.5knWxRyOEvQSAwZoz5fEa2Krvko@ifi.uio.no>
To: Zan Lynx <zlynx@acm.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pcmcia@lists.infradead.org, linux-ide@vger.kernel.org
Message-id: <475A21FD.6020009@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <fa.9+cyQSoHqcg4p5BAdLi4beGvJ8E@ifi.uio.no>
 <fa.es7DHARPOKbnzAqaEFBauYRpWjo@ifi.uio.no>
 <fa.kwN53ZHLrpa2M5QIn+VR9hoaqjA@ifi.uio.no>
 <fa.IgSJMFcov+qjLkhPpd1LhbCf93o@ifi.uio.no>
 <fa.5knWxRyOEvQSAwZoz5fEa2Krvko@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zan Lynx wrote:
> On Fri, 2007-12-07 at 15:22 -0800, Andrew Morton wrote:
>> On Fri, 07 Dec 2007 23:09:43 +0000
>> Zan Lynx <zlynx@acm.org> wrote:
>>
>>> On Fri, 2007-12-07 at 15:02 -0800, Andrew Morton wrote:
>>>> On Fri, 07 Dec 2007 20:38:24 +0000
>>>> Zan Lynx <zlynx@acm.org> wrote:
>>>>
>>>>> While I'm reporting problems I'll get this one out there.
>>>>>
>>>>> I normally use a USB-2 memory card reader but I also have a PCMCIA
>>>>> CompactFlash adapter that I use occasionally.  During the MM series
>>>>> kernels 2.6.22 and 23 (I am pretty sure) this didn't work at all.  I
>>>>> don't know about vanilla since I don't run that.
>>>>>
>>>>> Now with MM kernels 2.6.24 rc1-4 the PCMCIA adapter works again, but I
>>>>> only get read rates of 1.6 MB/s.  When it used to work in 2.6.20 I got
>>>>> at least 16 MB/s.  The card itself is capable of 30+ in the USB-2
>>>>> reader.
>>>>>
> [cut]
>> Oh, OK.  Hopefully the ata guys can help out with this.
>>
>> I don't know if it actually strictly a regression?  Did libata ever support
>> that device in any earlier kernels?
> 
> That could be why it didn't work for a few kernel versions.  I
> reconfigured for a libata-only system a while back.  And, since I
> usually use the USB-2 flash reader I didn't care much about the PCMCIA.
> 
> I will try reverting that patch later tonight, in a few hours.

It looks like pata_pcmcia is always PIO mode 0:

/**
  *	pcmcia_init_one		-	attach a PCMCIA interface
  *	@pdev: pcmcia device
  *
  *	Register a PCMCIA IDE interface. Such interfaces are PIO 0 and
  *	shared IRQ.
  */

I assume that with old IDE this would use ide_cs.c, but I'm drawing a 
blank on what modes that supports..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

