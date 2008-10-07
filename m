Return-Path: <linux-kernel-owner+w=401wt.eu-S1755113AbYJGJGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113AbYJGJGj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 05:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752850AbYJGJG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 05:06:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60789 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422AbYJGJG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 05:06:28 -0400
Date: Tue, 7 Oct 2008 05:05:54 -0400
From: Christoph Hellwig <hch@infradead.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Chris Mason <chris.mason@oracle.com>, Dave Chinner <david@fromorbit.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH] Improve buffered streaming write ordering
Message-ID: <20081007090554.GA23811@infradead.org>
References: <1222886451.9158.34.camel@think.oraclecorp.com> <20081001215239.ee2ae63f.akpm@linux-foundation.org> <1222950054.6745.18.camel@think.oraclecorp.com> <20081002181856.GB29613@skywalker> <20081002234309.GH30001@disturbed> <1223063155.13375.64.camel@think.oraclecorp.com> <20081006101605.GA15881@skywalker> <1223302903.16546.58.camel@think.oraclecorp.com> <20081007084531.GB15881@skywalker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081007084531.GB15881@skywalker>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2008 at 02:15:31PM +0530, Aneesh Kumar K.V wrote:
> +static int ext4_write_cache_pages(struct address_space *mapping,
> +		      struct writeback_control *wbc, writepage_t writepage,
> +		      void *data)
> +{

Looking at this functions the only difference is killing the
writeback_index and range_start updates.  If they are bad why would we
only remove them from ext4?

