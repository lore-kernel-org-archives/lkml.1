Return-Path: <linux-kernel-owner+w=401wt.eu-S1753101AbZH3BFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101AbZH3BFF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 21:05:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753041AbZH3BFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 21:05:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58633 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968AbZH3BFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 21:05:04 -0400
Date: Sat, 29 Aug 2009 21:05:00 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, liml@rtr.ca,
       jens.axboe@oracle.com, matthew@wil.cx, dwmw2@infradead.org
Subject: Re: [PATCH 4/7] sd: add support for WRITE SAME (16) with unmap bit
Message-ID: <20090830010500.GA24395@infradead.org>
References: <20090829230332.017137693@bombadil.infradead.org> <20090829231121.713422216@bombadil.infradead.org> <4A99CB2F.9000000@interlog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A99CB2F.9000000@interlog.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 29, 2009 at 08:43:27PM -0400, Douglas Gilbert wrote:
>>  +	if (buffer[14] & 0x80)
>> +		sdkp->thin_provisioning = 1;
>> +
>
> So you are checking the TPE bit (Thin Provisioning Enabled) but
> not the TPRZ bit (Thin Provisioning Read Zeros). Shouldn't
> there also be a sdkp->thin_provisioning_read_zeros bit defined
> in struct scsi_disk?
>
> Is your application well defined when TPRZ==0 ?

Filesystems do not care if these blocks are in a defined state, as
they must never return the content of uninitilized blocks to userspace.
Now if we do want to support discard through raid arrays we might start
to care, and will have check the TPRZ bit.

