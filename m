Return-Path: <linux-kernel-owner+w=401wt.eu-S1757557AbZEDP21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557AbZEDP21 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 11:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756778AbZEDP2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 11:28:16 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:51932 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755728AbZEDP2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 11:28:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=q7+lsk769eMncFnzFyIPnNkZYY7yk3dxlCaibD5FiOagYDjxm6gZIy9d1uqS7BQn3D
         0wfYt8s3zjGpge3CWgVPn+EbsHzgvuYRBQevENJLGVb3rGurLRhJYv2LMpvYIwgKOZog
         1PUt/HnszOybzzXktb/BnnRwISu4OYQkA2ge8=
Message-ID: <49FF0987.8040608@panasas.com>
Date: Mon, 04 May 2009 18:28:07 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Matthew Wilcox <matthew@wil.cx>, Jens Axboe <jens.axboe@oracle.com>,
       Hugh Dickins <hugh@veritas.com>, Matthew Wilcox <willy@linux.intel.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Mark Lord <lkml@rtr.ca>
Subject: Re: New TRIM/UNMAP tree published (2009-05-02)
References: <1238683047-13588-1-git-send-email-willy@linux.intel.com>	 <49D8A3D7.5070507@panasas.com> <20090503061150.GF10704@linux.intel.com>	 <20090503071619.GP8822@parisc-linux.org>	 <Pine.LNX.4.64.0905031346350.29671@blonde.anvils>	 <20090503144847.GR8822@parisc-linux.org> <49FDB21B.3080301@panasas.com>	 <20090503154216.GU8822@parisc-linux.org> <49FDC786.6070309@panasas.com>	 <49FDE3BB.505@garzik.org>  <49FDE50A.4060503@garzik.org>	 <1241377472.5596.88.camel@mulgrave.int.hansenpartnership.com>	 <49FDEE64.5090302@garzik.org> <1241380067.5596.103.camel@mulgrave.int.hansenpartnership.com> <49FE1EFF.2050406@garzik.org>
In-Reply-To: <49FE1EFF.2050406@garzik.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2009 01:47 AM, Jeff Garzik wrote:
> James Bottomley wrote:
>> The ideal for REQ_TYPE_DISCARD seems to be to force a page allocation
>> tied to a bio when it's issued at the top.  That way everyone has enough
>> memory when it comes down the stack (both extents and WRITE SAME sector
>> will fit into a page ... although only just for WRITE SAME on 4k
>> sectors).
> 
> Makes sense...
> 
> 	Jeff
> 

I second that, let the allocator of the request supply a buffer and free it
on return/done. Perhaps with a general helper that does all that.

Boaz
