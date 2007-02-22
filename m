Return-Path: <linux-kernel-owner+w=401wt.eu-S1751487AbXBVDd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751487AbXBVDd1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 22:33:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751375AbXBVDd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 22:33:27 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:41389 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbXBVDd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 22:33:26 -0500
Date: Thu, 22 Feb 2007 03:33:19 +0000
From: Christoph Hellwig <hch@infradead.org>
To: mike.miller@hp.com
Cc: jens.axboe@oracle.com, akpm@osdl.org, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, gregkh@novell.com
Subject: Re: [Patch 2/2] cciss: add reboot notifier support to driver
Message-ID: <20070222033319.GA7493@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>, mike.miller@hp.com,
	jens.axboe@oracle.com, akpm@osdl.org, linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org, gregkh@novell.com
References: <20070221211251.GB2672@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070221211251.GB2672@beardog.cca.cpqcorp.net>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 21, 2007 at 03:12:51PM -0600, Mike Miller (OS Dev) wrote:
> Patch 2/2
> 
> This patch adds reboot_notifier support to cciss. Changes in firmware make this patch
> essential. Without this patch there may be valid data left in the controller's battery
> backed write cache (BBWC) on shutdown. We found out the hard way that the kernel does
> not call our cleanup routines on shutdown or reboot. It seems that only rmmod calls
> the cleanup.
> Please consider this for inclusion.
> 

NAK.  This should be using the shutdown method in struct pci_driver instead.

I really wish we wouldn't export the reboot_notifier so people don't repeat
this mistake over and over again..

