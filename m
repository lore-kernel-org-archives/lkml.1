Return-Path: <linux-kernel-owner+w=401wt.eu-S1761353AbXIXX7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761353AbXIXX7X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 19:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755504AbXIXX7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 19:59:12 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:54370 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755350AbXIXX7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 19:59:10 -0400
Message-ID: <46F84F45.6000807@pobox.com>
Date: Mon, 24 Sep 2007 19:59:01 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
CC: roel <12o3l@tiscali.nl>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: [patch 1/2] Enable link power management for ata drivers
References: <20070924215140.966161778@intel.com> <20070924151320.67f0c332.kristen.c.accardi@intel.com> <46F84460.5090703@tiscali.nl> <20070924164118.803cfb22.kristen.c.accardi@intel.com>
In-Reply-To: <20070924164118.803cfb22.kristen.c.accardi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kristen Carlson Accardi wrote:
> On Tue, 25 Sep 2007 01:12:32 +0200
> roel <12o3l@tiscali.nl> wrote:
> 
>>>  #define ata_id_cdb_intr(id)	(((id)[0] & 0x60) == 0x20)
>>> +#define ata_id_has_hipm(id)	\
>>> +	( (((id)[76] != 0x0000) && ((id)[76] != 0xffff)) && \
>>> +	  ((id)[76] & (1 << 9)) )
>> 		^
>> 		|
>> are you sure this
>> should be 76?
> 
> Yes.
> 
>> we can also change the first statement a bit:
>> 	(!(((id)[76] == 0x0000) || ((id)[76] == 0xffff)) && \
>>
>>
>>> +#define ata_id_has_dipm(id)	\
>>> +	( (((id)[76] != 0x0000) && ((id)[76] != 0xffff)) && \
>> and:
>> 	(!(((id)[76] == 0x0000) || ((id)[76] == 0xffff)) && \
> 
> I feel this is equivalent functionality and not as readable.

Poke around for Alan Cox's cleanup of this area of linux/ata.h.

It converts several macros to inline functions (encouraged), and also 
illustrates a nice, clean way of testing an ID word's validity. 
[obviously the final implementation varies, depending on that ID word's 
history]

Alan or Andrew, got a copy somewhere?  My feeble search skills don't 
seem to turn it up at the moment, even though I had a copy in my hands 
quite recently.

	Jeff


