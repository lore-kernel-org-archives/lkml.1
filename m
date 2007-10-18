Return-Path: <linux-kernel-owner+w=401wt.eu-S1763117AbXJRKGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763117AbXJRKGz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 06:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760194AbXJRKGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 06:06:42 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:55039 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756120AbXJRKGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 06:06:40 -0400
Message-ID: <4717302D.4050107@garzik.org>
Date: Thu, 18 Oct 2007 06:06:37 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Mathieu Fluhr <mfluhr@nero.com>
CC: Robert Hancock <hancockr@shaw.ca>, LKML <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: Inquiry data and emulated SG devices
References: <fa.PgEHbZ0E5ogcX8bZwvrUeZB+eJs@ifi.uio.no>	 <4716B56A.1090501@shaw.ca>  <4716B786.80804@garzik.org> <1192701555.3247.28.camel@de-c-l-110.nero-de.internal>
In-Reply-To: <1192701555.3247.28.camel@de-c-l-110.nero-de.internal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Fluhr wrote:
> On Wed, 2007-10-17 at 21:31 -0400, Jeff Garzik wrote:
>> Robert Hancock wrote:
>>> This doesn't seem a very reliable way to identify an IDE device, as all
>>> that 0 means is that the device does not claim conformance to any
>>> standard. I would think it would be legitimate for an IDE device to put
>>> a value like 5 in there as well, if it complies with SPC-4..
>> Via the this-doesnt-really-matter-but-it-should-be-noted department:
>>
>> According to the latest on t10.org, MMC retroactively permitted SCSI 
>> version to be zero, for MMC-compliant USB and ATAPI devices.
>>
> 
> Quoting to the latest MtFuji draft (Section 17.7.1):
>  "The ANSI Version field shall contain a non-zero value to comply with 
>   this version of the Specification for a SCSI logical unit or zero for
>   an ATAPI logical unit."
> 
> 
>>> In the case of libata though, that appears to be due to this code in
>>> drivers/ata/libata-scsi.c:
>>>
>>>     /* ATAPI devices typically report zero for their SCSI version,
>>>      * and sometimes deviate from the spec WRT response data
>>>      * format.  If SCSI version is reported as zero like normal,
>>>      * then we make the following fixups:  1) Fake MMC-5 version,
>>>      * to indicate to the Linux scsi midlayer this is a modern
>>>      * device.  2) Ensure response data format / ATAPI information
>>>      * are always correct.
>>>      */
>>>             if (buf[2] == 0) {
>>>                 buf[2] = 0x5;
>>>                 buf[3] = 0x32;
>>>             }
>>>
> 
> This explain a lot... But (Sorry I am not a scsi mid-layer expert) why
> faking what the device outputs?

The SCSI midlayer makes a lot of "if scsi version <= 2" choices.  In the 
case of ATAPI, we do not want to force ATAPI down the path of ancient 
SCSI devices, as this disables some MMC features that modern ATAPI 
devices support.

	Jeff



