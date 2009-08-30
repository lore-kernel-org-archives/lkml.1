Return-Path: <linux-kernel-owner+w=401wt.eu-S1752905AbZH3Cnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905AbZH3Cnt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 22:43:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbZH3Cnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 22:43:49 -0400
Received: from smtp.infotech.no ([82.134.31.41]:47347 "EHLO elrond.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752595AbZH3Cns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 22:43:48 -0400
Message-ID: <4A99E760.1060302@interlog.com>
Date: Sat, 29 Aug 2009 22:43:44 -0400
From: Douglas Gilbert <dgilbert@interlog.com>
Reply-To: dgilbert@interlog.com
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, liml@rtr.ca, jens.axboe@oracle.com,
       matthew@wil.cx, dwmw2@infradead.org
Subject: Re: [PATCH 4/7] sd: add support for WRITE SAME (16) with unmap bit
References: <20090829230332.017137693@bombadil.infradead.org> <20090829231121.713422216@bombadil.infradead.org> <4A99CB2F.9000000@interlog.com> <20090830010500.GA24395@infradead.org>
In-Reply-To: <20090830010500.GA24395@infradead.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Sat, Aug 29, 2009 at 08:43:27PM -0400, Douglas Gilbert wrote:
>>>  +	if (buffer[14] & 0x80)
>>> +		sdkp->thin_provisioning = 1;
>>> +
>> So you are checking the TPE bit (Thin Provisioning Enabled) but
>> not the TPRZ bit (Thin Provisioning Read Zeros). Shouldn't
>> there also be a sdkp->thin_provisioning_read_zeros bit defined
>> in struct scsi_disk?
>>
>> Is your application well defined when TPRZ==0 ?
> 
> Filesystems do not care if these blocks are in a defined state, as
> they must never return the content of uninitilized blocks to userspace.
> Now if we do want to support discard through raid arrays we might start
> to care, and will have check the TPRZ bit.

Another reason to note the TPRZ bit is that if it is 1 then
the data given to WRITE SAME (16 and 32) must be a logical
block of zeros for the UNMAP bit to be honoured (sbc3r19.pdf
section 4.6.3.2 last paragraph).
