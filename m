Return-Path: <linux-kernel-owner+w=401wt.eu-S1754235Ab0AKURk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235Ab0AKURk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 15:17:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109Ab0AKURh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 15:17:37 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:62948 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989Ab0AKURf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 15:17:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Z5fjfKLZ1D3kwVg9g2GefMpHwwtdwgy7ZrMEWExbHnsxJIgsP3iBlADJRykcN3Al9w
         9drMb6f40M6u0/cgBfaV+iVy/hzkZgtk4HEVFPDKtQkkGumTC8CLxInU8RdhWN7bdn0i
         cAtrrkDHdvOdT/gaEOjSA4XMuZ20yrFnpHlE8=
Message-ID: <4B4B877A.8060106@googlemail.com>
Date: Mon, 11 Jan 2010 21:18:02 +0100
From: =?ISO-8859-1?Q?Ren=E9_Bolldorf?= <xsecute@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: Marc Bejarano <beej@beej.org>
CC: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       James Bottomley <James.Bottomley@suse.de>, linux-kernel@vger.kernel.org,
       jgarzik@pobox.com
Subject: Re: [PATCH]drivers/ata/libata-eh.c:1509 unneeded memset()
References: <5543f88f1001111129u362be554kd97027d977b5dff3@mail.gmail.com> <5543f88f1001111141r5375d2a3kd726d2b70e124b94@mail.gmail.com>
In-Reply-To: <5543f88f1001111141r5375d2a3kd726d2b70e124b94@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/10 20:41, Marc Bejarano wrote:
> and once more in plain text.  (sorry vger)
>
> 2010/1/11 Marc Bejarano<beej@beej.org>:
>> oops.  seems that GMANE's reply function only goes to a single "newsgroup".
>>   original recipients re-added.
>> marc
>> ----
>> From: Marc Bejarano<beej<at>  beej.org>
>> Subject: Re: [PATCH]drivers/ata/libata-eh.c:1509 unneeded memset()
>> Newsgroups: gmane.linux.scsi
>> Date: 2010-01-08 22:21:09 GMT (2 days, 20 hours and 40 minutes ago)
>>
>> René Bolldorf<xsecute<at>  googlemail.com>  writes:
>>> On 01/08/10 16:28, James Bottomley wrote:
>>>> On Thu, 2010-01-07 at 14:15 -0500, Jeff Garzik wrote:
>>>>> On 12/30/2009 05:59 PM, René Bolldorf wrote:
>>>>>> We don't need this .
>>
>>>>>> - /* FIXME: is this needed? */
>>>>>> - memset(sense_buf, 0, SCSI_SENSE_BUFFERSIZE);
>>>>>
>>>>> I need a little bit more detail than an unqualified statement...  Did
>>>>> you audit all paths leading to this code point?
>>
>>>> But one also here:
>>>>
>>>> u8 *sense_buffer = dev->link->ap->sector_buf;
>>>> [...]
>>>> err_mask = atapi_eh_request_sense(dev, sense_buffer, sense_key);
>>>>
>>>> Which doesn't look OK because it looks like the sector_buf isn't cleared
>>>> (and it is reused).
>>>>
>>>> James
>>>>
>>>>
>>>
>>> Thank's, you're right. I have overseen this, sry for that.
>>
>> René: perhaps you'd like to submit a patch that substitutes FIXME comment
>> for one that explains why the memset is needed, crediting James in the
>> description?  we may as well gain something permanent from this discussion
>> that you started :)
>>
>> cheers,
>> marc
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo<at>  vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>> ----

I hope that's good enough explained :-).

Best regards
René

--- ./drivers/ata/libata-eh.c   2010-01-07 23:21:23.622464012 +0100
+++ ./drivers/ata/libata-eh.c   2010-01-11 21:11:19.869092897 +0100
@@ -1505,7 +1505,10 @@ static unsigned int atapi_eh_request_sen

         DPRINTK("ATAPI request sense\n");

-       /* FIXME: is this needed? */
+       /* make sure sense_buf is cleared then atapi_eh_request_sense is 
called.
+        * (to make sure nothing get's reused.)
+        * thanks to James Bottomley
+        */
         memset(sense_buf, 0, SCSI_SENSE_BUFFERSIZE);

         /* initialize sense_buf with the error register,
