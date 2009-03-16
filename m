Return-Path: <linux-kernel-owner+w=401wt.eu-S1759483AbZCPNjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759483AbZCPNjk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 09:39:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752790AbZCPNja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 09:39:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40310 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbZCPNj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 09:39:29 -0400
Date: Mon, 16 Mar 2009 09:39:23 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Chris Mason <chris.mason@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       david@fromorbit.com, npiggin@suse.de, linux-mm@kvack.org
Subject: Re: [PATCH 2/7] writeback: switch to per-bdi threads for flushing
	data
Message-ID: <20090316133923.GA27393@infradead.org>
References: <1236868428-20408-1-git-send-email-jens.axboe@oracle.com> <1236868428-20408-3-git-send-email-jens.axboe@oracle.com> <20090316102253.GB9510@infradead.org> <1237210214.30224.3.camel@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237210214.30224.3.camel@think.oraclecorp.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 16, 2009 at 09:30:14AM -0400, Chris Mason wrote:
> Some of our poor filesystem cousins don't write the super until kupdate
> kicks them (see ext2_write_super).  kupdate has always been the periodic
> FS thread of last resort.

Yikes, looks like this is indeed the only peridocial sb update for many
simpler filesystems.  We should really have a separate thread for that
instead of hacking it into VM writeback.  Especially with the per-bdi
one where the current setup doesn't make any sense.
