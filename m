Return-Path: <linux-kernel-owner+w=401wt.eu-S1030413AbXCCTiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030413AbXCCTiR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 14:38:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030412AbXCCTiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 14:38:17 -0500
Received: from h155.mvista.com ([63.81.120.155]:46304 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030404AbXCCTiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 14:38:16 -0500
Message-ID: <45E9CE9D.9030807@ru.mvista.com>
Date: Sat, 03 Mar 2007 22:38:05 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jeff@garzik.org>, akpm@osdl.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pata_cmd640: CMD640 PCI support
References: <20070302150306.368e24b9@lxorguk.ukuu.org.uk>	<45E8B28D.7030500@garzik.org>	<45E9AC6B.50701@ru.mvista.com> <20070303203339.6f605ac9@lxorguk.ukuu.org.uk>
In-Reply-To: <20070303203339.6f605ac9@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>>>>+    if (t.active > 16)
>>>>+        t.active = 16;
>>
>>    Erm, clamping active time is not a right thing to do. Right thing to do 
>>was to bail out. I didn't do it in the legacy driver rewrite though...

> As far as I can work out its a "can't happen"

>>>>+        pci_read_config_byte(pdev, ARTIM23, &reg);

>>    It's not even expensive, it may be just unsafe.

> You have to serialize the channels and idle both so its very expensive -
> or is that what you meant by unsafe.

    I meant that the address setup timing should always match that of a slower 
device -- *no* switching.

>>>>+    /* CMD640 detected, commiserations */
>>>>+    pci_write_config_byte(pdev, 0x5C, 0x00);

>>>magic number

>>   Indeed, completely undocumented. And I don't even see it in the legacy 
>>driver...

> Should be 0x5B which is still undocumented. Will fix that.

    Ah, that's what became DRWTIM3 in the later chips?

>>    It's used to be a well known fact (soon after Intel put that chip on their 
>>motherboards :-) that PCI0640 may return bad data on command block reads if 
>>another channel has data port I/O going on. That's why the interrupts needed 
>>to be disabled during PIO in the legacy driver (and the channels serialized).

> I was under the impression this was only the situation with the
> FIFO/readahead logic enabled, as with the RZ1000 ?

    Sorry, I mixed up with RZ1000 for the Intel's case -- memory fade. :-<

> Can you clarify that at all ?

    Yeah, it was happening with IDE prefetch of course...

> Alan

WBR, Sergei
