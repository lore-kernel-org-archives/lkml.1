Return-Path: <linux-kernel-owner+w=401wt.eu-S1759961AbZEYHnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759961AbZEYHnk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 03:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759807AbZEYHl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 03:41:27 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58453 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759811AbZEYHlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 03:41:25 -0400
Date: Mon, 25 May 2009 03:41:24 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       linux-scsi@vger.kernel.org
Subject: Re: [PATCH 03/13] scsi: unify allocation of scsi command and sense
	buffer
Message-ID: <20090525074124.GA31746@infradead.org>
References: <1243236668-3398-1-git-send-email-jens.axboe@oracle.com> <1243236668-3398-6-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243236668-3398-6-git-send-email-jens.axboe@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 25, 2009 at 09:30:48AM +0200, Jens Axboe wrote:
> Fold the sense buffer into the command, thereby eliminating a slab
> allocation and free per command.

Might help to send it to linux-scsi to get people to review and apply it
:)

But that patch looks good to me, avoiding one allocation for each
command and simplifying the code.  I try to remember why these were
two slabs to start with but can't find any reason.

Btw, we might just want to declare the sense buffer directly as a sized
array in the scsi command as there really doesn't seem to be a reason
not to allocate it.

