Return-Path: <linux-kernel-owner+w=401wt.eu-S1755710AbZECSkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710AbZECSkh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 14:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753207AbZECSk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 14:40:26 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:58147 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752229AbZECSkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 14:40:25 -0400
Message-ID: <49FDE50A.4060503@garzik.org>
Date: Sun, 03 May 2009 14:40:10 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>, Jens Axboe <jens.axboe@oracle.com>
CC: Boaz Harrosh <bharrosh@panasas.com>, Hugh Dickins <hugh@veritas.com>,
       Matthew Wilcox <willy@linux.intel.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Mark Lord <lkml@rtr.ca>
Subject: Re: New TRIM/UNMAP tree published (2009-05-02)
References: <1238683047-13588-1-git-send-email-willy@linux.intel.com> <49D8A3D7.5070507@panasas.com> <20090503061150.GF10704@linux.intel.com> <20090503071619.GP8822@parisc-linux.org> <Pine.LNX.4.64.0905031346350.29671@blonde.anvils> <20090503144847.GR8822@parisc-linux.org> <49FDB21B.3080301@panasas.com> <20090503154216.GU8822@parisc-linux.org> <49FDC786.6070309@panasas.com> <49FDE3BB.505@garzik.org>
In-Reply-To: <49FDE3BB.505@garzik.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> (2) determine at init if queue (a) supports explicit DISCARD and/or (b) 
> supports DISCARD flag passed with READ or WRITE


As an aside -- does any existing command set support case #b, above?

AFAICT, ATA, SCSI and NVMHCI all have a single, explicit hardware 
command to discard/deallocate unused sectors.

Therefore, creating REQ_TYPE_DISCARD seems to eliminate any need for new 
hook ->prepare_discard().

This provides a 1:1 correspondence between hardware and struct request, 
most closely matching the setup of known hardware.

	Jeff



