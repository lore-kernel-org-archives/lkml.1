Return-Path: <linux-kernel-owner+w=401wt.eu-S1754450AbZBJKnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450AbZBJKnX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 05:43:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753434AbZBJKnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 05:43:10 -0500
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:32533 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753694AbZBJKnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 05:43:09 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAE/okEl5LClx/2dsb2JhbADTCoQaBg
X-IronPort-AV: E=Sophos;i="4.38,185,1233495000"; 
   d="scan'208";a="287384453"
Date: Tue, 10 Feb 2009 21:43:04 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Alessandro Bono <alessandro.bono@gmail.com>,
       linux-xfs <linux-xfs@oss.sgi.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: XFS kernel BUG at fs/buffer.c:470! with 2.6.28.4
Message-ID: <20090210104304.GP8830@disturbed>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Alessandro Bono <alessandro.bono@gmail.com>,
	linux-xfs <linux-xfs@oss.sgi.com>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <1234011974.7435.11.camel@champagne.cantina> <20090208222859.GA2532@infradead.org> <1234132752.12370.0.camel@champagne.cantina> <20090208224249.GA11931@infradead.org> <1234133120.12370.7.camel@champagne.cantina> <20090209075308.GA7360@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090209075308.GA7360@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 09, 2009 at 02:53:08AM -0500, Christoph Hellwig wrote:
> On Sun, Feb 08, 2009 at 11:45:20PM +0100, Alessandro Bono wrote:
> > sure, attached
> 
> That would be a missing PagePrivate bit in page_buffers() called from
> end_buffer_async_write.  PG_private can only be cleared via drop_buffers
> which requires the page not having PG_writeback set which must be
> set until end_buffer_async_write is done.  Very strange, and all this
> is generic code without xfs involvement.  Did this happen once
> or can you reproduce it?

Hmmmm - i wonder if this has anything to do with the writeback fixes
that went into 2.6.28.2? Alessandro, can you revert to 2.6.28.1 (not
plain 2.6.28) and see if you can reproduce the problem?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
