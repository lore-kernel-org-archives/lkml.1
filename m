Return-Path: <linux-kernel-owner+w=401wt.eu-S1753383AbXE3KOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383AbXE3KOg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 06:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751684AbXE3KO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 06:14:27 -0400
Received: from verein.lst.de ([213.95.11.210]:54958 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751578AbXE3KO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 06:14:26 -0400
Date: Wed, 30 May 2007 12:13:49 +0200
From: Christoph Hellwig <hch@lst.de>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Christoph Hellwig <hch@lst.de>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [patch 6/7] ps3: ROM Storage Driver
Message-ID: <20070530101348.GD24586@lst.de>
References: <20070525083607.784351000@sonycom.com> <20070525083632.677742000@sonycom.com> <20070529104948.GC29351@lst.de> <Pine.LNX.4.62.0705291308280.7698@pademelon.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.62.0705291308280.7698@pademelon.sonytel.be>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2007 at 01:11:41PM +0200, Geert Uytterhoeven wrote:
> > This looks very inefficient.  Just set sg_tablesize of your driver
> > to 1 to avoid getting mutiple segments.
> 
> The disadvantage of setting sg_tablesize = 1 is that the driver will get small
> requests (PAGE_SIZE) most of the time, which is very bad for performance.

If you set .clustering = 1 in your host template you will frequently
get larger requests.

For any sane hypervisor or hardware the copy should be worth
than that.  Then again a sane hardware or hypervisor would support
SG requests..

