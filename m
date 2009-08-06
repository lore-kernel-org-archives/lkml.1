Return-Path: <linux-kernel-owner+w=401wt.eu-S1752836AbZHFMWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836AbZHFMWa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 08:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbZHFMW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 08:22:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47963 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbZHFMW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 08:22:29 -0400
Date: Thu, 6 Aug 2009 08:22:21 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Mark McLoughlin <markmc@redhat.com>,
       device-mapper development <dm-devel@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] [PATCH] block: silently error unsupported empty
	barriers too
Message-ID: <20090806122221.GA5175@infradead.org>
References: <1249557257.3721.55.camel@blaa> <20090806114550.GL29899@agk-dp.fab.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090806114550.GL29899@agk-dp.fab.redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 06, 2009 at 12:45:50PM +0100, Alasdair G Kergon wrote:
> On Thu, Aug 06, 2009 at 12:14:17PM +0100, Mark McLoughlin wrote:
> > We should error all barriers, even empty barriers, on devices like
> > virtio_blk which don't support them.
>  
> Have you considered whether or not virtio_blk actually needs to
> support empty barriers?

virtio_blk on kvm does not support any barriers at all, similar to many
other drivers out there.  If the queue flags say we don't support
barriers higher layers should not submit any barrier requests.

