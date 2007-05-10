Return-Path: <linux-kernel-owner+w=401wt.eu-S1760835AbXEJXak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760835AbXEJXak (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 19:30:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754285AbXEJXab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 19:30:31 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:12886 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784AbXEJXaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 19:30:30 -0400
Date: Thu, 10 May 2007 17:29:58 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] libata: add human-readable error value decoding
In-reply-to: <4642E92D.5010509@gmail.com>
To: Tejun Heo <htejun@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>
Message-id: <4643AAF6.7080204@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <46428103.3040003@shaw.ca> <4642E92D.5010509@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
>> +    if (ehc->i.serror)
>> +        ata_port_printk(ap, KERN_ERR,
>> +          "SError: {%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s}\n",
>> +          ehc->i.serror & SERR_DATA_RECOVERED ? "RecovDataErr " : "",
>> +          ehc->i.serror & SERR_COMM_RECOVERED ? "RecovCommErr " : "",
>> +          ehc->i.serror & SERR_DATA ? "UnrecovDataErr " : "",
>> +          ehc->i.serror & SERR_PERSISTENT ? "PersistErr " : "",
>> +          ehc->i.serror & SERR_PROTOCOL ? "ProtocolErr " : "",
>> +          ehc->i.serror & SERR_INTERNAL ? "HostInternalErr " : "",
>> +          ehc->i.serror & SERR_PHYRDY_CHG ? "PHYRdyChg " : "",
>> +          ehc->i.serror & SERR_PHY_INT_ERR ? "PHYInternalErr " : "",
>> +          ehc->i.serror & SERR_COMM_WAKE ? "CommWake " : "",
>> +          ehc->i.serror & SERR_10B_8B_ERR ? "10B8BErr " : "",
>> +          ehc->i.serror & SERR_DISPARITY ? "Disparity " : "",
>> +          ehc->i.serror & SERR_CRC ? "CRCErr " : "",
>> +          ehc->i.serror & SERR_HANDSHAKE ? "HandshakeErr " : "",
>> +          ehc->i.serror & SERR_LINK_SEQ_ERR ? "LinkSeqErr " : "",
>> +          ehc->i.serror & SERR_TRANS_ST_ERROR ? "TransStatTransErr " : "",
>> +          ehc->i.serror & SERR_UNRECOG_FIS ? "UnrecogFIS " : "",
>> +          ehc->i.serror & SERR_DEV_XCHG ? "DevExchanged " : "" );
> 
> I'm not really convinced whether this is necessary.  The human readable
> form is also a bit cryptic and can get quite long.  So, mild NACK from me.
> 

It certainly seems useful when debugging hotplug issues or random SATA 
problems which end up being caused by communication problems. Without 
this output, Joe User stands no chance of figuring out what's going on, 
and neither does Joe libata Developer unless they really care to dig 
through the spec and count bits to figure out what they mean. At least 
with this you can see that there was a CRC error, etc. and go from that..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

