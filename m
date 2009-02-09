Return-Path: <linux-kernel-owner+w=401wt.eu-S1754122AbZBIHxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122AbZBIHxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 02:53:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751055AbZBIHxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 02:53:11 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:47635 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbZBIHxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 02:53:10 -0500
Date: Mon, 9 Feb 2009 02:53:08 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Alessandro Bono <alessandro.bono@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs <linux-xfs@oss.sgi.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: XFS kernel BUG at fs/buffer.c:470! with 2.6.28.4
Message-ID: <20090209075308.GA7360@infradead.org>
References: <1234011974.7435.11.camel@champagne.cantina> <20090208222859.GA2532@infradead.org> <1234132752.12370.0.camel@champagne.cantina> <20090208224249.GA11931@infradead.org> <1234133120.12370.7.camel@champagne.cantina>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234133120.12370.7.camel@champagne.cantina>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 08, 2009 at 11:45:20PM +0100, Alessandro Bono wrote:
> sure, attached

That would be a missing PagePrivate bit in page_buffers() called from
end_buffer_async_write.  PG_private can only be cleared via drop_buffers
which requires the page not having PG_writeback set which must be
set until end_buffer_async_write is done.  Very strange, and all this
is generic code without xfs involvement.  Did this happen once
or can you reproduce it?

