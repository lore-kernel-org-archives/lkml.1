Return-Path: <linux-kernel-owner+w=401wt.eu-S933215AbXCMUcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933215AbXCMUcs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 16:32:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933298AbXCMUcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 16:32:48 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43228 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933215AbXCMUcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 16:32:47 -0400
Date: Tue, 13 Mar 2007 20:32:44 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Kandan Venkataraman <kven709@cse.unsw.EDU.AU>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] Loop device - Tracking page writes made to a loop device through mmap
Message-ID: <20070313203244.GA13914@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Kandan Venkataraman <kven709@cse.unsw.EDU.AU>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <Pine.LNX.4.64.0703140712080.18655@williams.orchestra.cse.unsw.EDU.AU>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703140712080.18655@williams.orchestra.cse.unsw.EDU.AU>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2007 at 07:21:41AM +1100, Kandan Venkataraman wrote:
> All comments have been taken care of.
> 
> Description:
> 
> A  file_operations structure variable called loop_fops is initialised with
> the default block device file operations (def_blk_fops).
> The mmap operation is overriden with a new function called loop_file_mmap.

NACK.  block device driver should never ever play around with file
operations themselves.  If you want functionality like the one you
have please don't overload the loop driver, but start a new (character)
driver doing specificaly what you want.  And even then I'm not sure
we'd want functionality like this in the mainline tree, but at least
we can have an open discussion if it's done properly.

