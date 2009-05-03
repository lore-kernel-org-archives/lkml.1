Return-Path: <linux-kernel-owner+w=401wt.eu-S1755793AbZECWye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793AbZECWye (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 18:54:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752987AbZECWyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 18:54:23 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60338 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624AbZECWyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 18:54:22 -0400
Message-ID: <49FE208E.7070001@garzik.org>
Date: Sun, 03 May 2009 18:54:06 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Boaz Harrosh <bharrosh@panasas.com>, Hugh Dickins <hugh@veritas.com>,
       Matthew Wilcox <willy@linux.intel.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>,
       linux-scsi@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Mark Lord <lkml@rtr.ca>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: New TRIM/UNMAP tree published (2009-05-02)
References: <1238683047-13588-1-git-send-email-willy@linux.intel.com> <49D8A3D7.5070507@panasas.com> <20090503061150.GF10704@linux.intel.com> <20090503071619.GP8822@parisc-linux.org> <Pine.LNX.4.64.0905031346350.29671@blonde.anvils> <20090503144847.GR8822@parisc-linux.org> <49FDB21B.3080301@panasas.com> <20090503154216.GU8822@parisc-linux.org> <49FDC786.6070309@panasas.com> <49FDE3BB.505@garzik.org> <20090503214836.GV8822@parisc-linux.org>
In-Reply-To: <20090503214836.GV8822@parisc-linux.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
>> (3) when creating a discard request, use block helpers w/ queue-specific  
>> knowledge to create either
>> 	(a) one request, REQ_TYPE_FS, with discard flag or
>> 	(b) two requests, REQ_TYPE_FS followed by REQ_TYPE_DISCARD
> 
> I'm not sure we need option 3b.


Well -- it is a hard requirement to map 1:1 struct request with the 
underlying hardware device's command set.

If a device command set lacks a READ-and-DISCARD operation, then you 
_must_ create two struct request.  Otherwise you break block layer 
tagging and other 1:1-based assumptions that exist today.	

Thus, given that all of ATA|SCSI|NVMHCI have a DISCARD operation 
distinct from other commands...

option 3b is the overwhelming common case.

	Jeff



