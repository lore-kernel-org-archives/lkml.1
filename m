Return-Path: <linux-kernel-owner+w=401wt.eu-S1758151AbYABKJI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758151AbYABKJI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 05:09:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753846AbYABKI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 05:08:56 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:50375 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731AbYABKI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 05:08:56 -0500
Date: Wed, 2 Jan 2008 10:08:52 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andy Whitcroft <apw@shadowen.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: WARNING: do not add new typedefs - is that for real?
Message-ID: <20080102100852.GA19859@infradead.org>
References: <477A6732.4010609@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <477A6732.4010609@panasas.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 01, 2008 at 06:15:46PM +0200, Boaz Harrosh wrote:
> I have this code:
> 
> <c_code>
> /* 
>  * osd-r10 4.12.5 Data-In and Data-Out buffer offsets
>  * byte offset = mantissa * (2^(exponent+8))
>  */
> typedef __be32 osd_cdb_offset;

Given that you can't do normal arithmetic on this type it should't
really be a __be32 but it's own __bitwise type with proper accessors.

But yes, this is one of the rare cases where a typedef makes sense,
but Í'd call it osd_off_t or something like that.

