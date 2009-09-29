Return-Path: <linux-kernel-owner+w=401wt.eu-S1753258AbZI2Phx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbZI2Phx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 11:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752830AbZI2Phw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 11:37:52 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39557 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651AbZI2Phv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 11:37:51 -0400
Date: Tue, 29 Sep 2009 11:37:47 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: drbd-dev@lists.linbit.com, Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       akpm <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Drbd-dev] [PATCH -next] drbd: trace depends on TRACING
Message-ID: <20090929153747.GA29621@infradead.org>
References: <20090925133830.1ba29584.sfr@canb.auug.org.au> <4ABD4C28.9070202@oracle.com> <200909291732.51383.philipp.reisner@linbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909291732.51383.philipp.reisner@linbit.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 29, 2009 at 05:32:50PM +0200, Philipp Reisner wrote:
> On Saturday 26 September 2009 01:03:04 Randy Dunlap wrote:
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> >
> > DRBD_TRACE should depend on TRACING.
> > It's also possible that TRACEPOINTS should depend on TRACING.
> >
> 
> Hi Randy,
> 
> I tried to figure out in which way that should be done. By looking
> at "BLK_DEV_IO_TRACE" I got the impression that this should
> be done by adding "select GENERIC_TRACER".

Neither really.  The only way of tracing that should be used is the
TRACE_EVENT macros, which compile away to nothing if tracing is
disabled, so no dependency is needed at all.

