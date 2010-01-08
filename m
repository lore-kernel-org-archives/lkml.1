Return-Path: <linux-kernel-owner+w=401wt.eu-S1754003Ab0AHUri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003Ab0AHUri (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 15:47:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750904Ab0AHUrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 15:47:37 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:8914 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab0AHUrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 15:47:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=lqOU2JC4jGCHzL4Fzx6pAJO2wNffMH11tPOa16JAgPRsnhGTJ669tNd1NDLSMdP+2Z
         HYUmK6GLyW1G8haDSMrjfbxs55kze10xObYK0+lSp89owLtoz3IjrUQGMQ77sGAMfYCm
         nP/bz9HJbuwnblfDdjkjpDh94EW74WHEaiaOk=
Message-ID: <4B4799FB.9030208@googlemail.com>
Date: Fri, 08 Jan 2010 21:47:55 +0100
From: =?UTF-8?B?UmVuw6kgQm9sbGRvcmY=?= <xsecute@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@suse.de>
CC: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH]drivers/ata/libata-eh.c:1509 unneeded memset()
References: <4B3BDB66.6000008@googlemail.com>  <4B4632BF.4070806@pobox.com> <1262964519.3025.614.camel@mulgrave.site>
In-Reply-To: <1262964519.3025.614.camel@mulgrave.site>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/10 16:28, James Bottomley wrote:
> On Thu, 2010-01-07 at 14:15 -0500, Jeff Garzik wrote:
>> On 12/30/2009 05:59 PM, René Bolldorf wrote:
>>> We don't need this ;-).
>>>
>>> Best regards René Bolldorf&  a happy new year in advance.
>>>
>>> --- ./drivers/ata/libata-eh.c 2009-12-30 23:44:05.578988545 +0100
>>> +++ ./drivers/ata/libata-eh.c 2009-12-30 23:45:06.991987607 +0100
>>> @@ -1505,9 +1505,6 @@ static unsigned int atapi_eh_request_sen
>>>
>>> DPRINTK("ATAPI request sense\n");
>>>
>>> - /* FIXME: is this needed? */
>>> - memset(sense_buf, 0, SCSI_SENSE_BUFFERSIZE);
>>
>> I need a little bit more detail than an unqualified statement...  Did
>> you audit all paths leading to this code point?
>
> There are two code paths coming into here.  One directly from the scsi
> sense buffer:
>
> 		if (!(qc->ap->pflags&  ATA_PFLAG_FROZEN)) {
> 			tmp = atapi_eh_request_sense(qc->dev,
> 						qc->scsicmd->sense_buffer,
> 						qc->result_tf.feature>>  4);
>
> Which is fine because SCSI zeros the sense buffer.
>
> But one also here:
>
> 		u8 *sense_buffer = dev->link->ap->sector_buf;
> 		[...]
> 		err_mask = atapi_eh_request_sense(dev, sense_buffer, sense_key);
>
> Which doesn't look OK because it looks like the sector_buf isn't cleared
> (and it is reused).
>
> James
>
>

Thank's, you're right. I have overseen this, sry for that.
