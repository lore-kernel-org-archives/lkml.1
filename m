Return-Path: <linux-kernel-owner+w=401wt.eu-S1752770AbXDEKDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbXDEKDc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 06:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965967AbXDEKDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 06:03:32 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37615 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902AbXDEKDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 06:03:31 -0400
Date: Thu, 5 Apr 2007 11:03:26 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Hannes Reinecke <hare@suse.de>
Cc: Mike Miller <mike.miller@hp.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       SCSI Mailing List <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] Perverting cciss
Message-ID: <20070405100326.GA19092@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Hannes Reinecke <hare@suse.de>, Mike Miller <mike.miller@hp.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	SCSI Mailing List <linux-scsi@vger.kernel.org>
References: <4614C82E.1020100@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4614C82E.1020100@suse.de>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 05, 2007 at 11:58:06AM +0200, Hannes Reinecke wrote:
> Hi All,
> 
> this patch adds the SG_IO ioctl to the cciss driver.
> As the driver is capable of sending SCSI CDBs to the controller there is
> no reason why we shouldn't exploit it.
> This way we get to use all the nice sg_utils for the cciss driver.
> And a persistent device name for free.

Instead of adding yet another implementation of SG_IO please implement
support for REQ_TYPE_BLOCK_PC requests and add all the nice block layer
passthrough ioctls to it.

> Makes one wonder why this one is not implemented as a SCSI driver in the
> first place.

It probably should have been a scsi driver, but it's far too late now.

