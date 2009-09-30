Return-Path: <linux-kernel-owner+w=401wt.eu-S1753991AbZI3ICW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbZI3ICW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 04:02:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753432AbZI3ICU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 04:02:20 -0400
Received: from mail09.linbit.com ([212.69.161.110]:51131 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527AbZI3ICS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 04:02:18 -0400
Date: Wed, 30 Sep 2009 10:02:21 +0200
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Philipp Reisner <philipp.reisner@linbit.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       akpm <akpm@linux-foundation.org>, drbd-dev@lists.linbit.com
Subject: Re: [Drbd-dev] [PATCH -next] drbd: trace depends on TRACING
Message-ID: <20090930080221.GA8032@barkeeper1-xen.linbit>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
	akpm <akpm@linux-foundation.org>, drbd-dev@lists.linbit.com
References: <20090925133830.1ba29584.sfr@canb.auug.org.au> <4ABD4C28.9070202@oracle.com> <200909291732.51383.philipp.reisner@linbit.com> <20090929153747.GA29621@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090929153747.GA29621@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 29, 2009 at 11:37:47AM -0400, Christoph Hellwig wrote:
> On Tue, Sep 29, 2009 at 05:32:50PM +0200, Philipp Reisner wrote:
> > On Saturday 26 September 2009 01:03:04 Randy Dunlap wrote:
> > > From: Randy Dunlap <randy.dunlap@oracle.com>
> > >
> > > DRBD_TRACE should depend on TRACING.
> > > It's also possible that TRACEPOINTS should depend on TRACING.
> > >
> > 
> > Hi Randy,
> > 
> > I tried to figure out in which way that should be done. By looking
> > at "BLK_DEV_IO_TRACE" I got the impression that this should
> > be done by adding "select GENERIC_TRACER".
> 
> Neither really.  The only way of tracing that should be used is the
> TRACE_EVENT macros, which compile away to nothing if tracing is
> disabled, so no dependency is needed at all.

TRACE_EVENT macros depend on, and use TRACE_POINTS.
And those trace points are what compiles away if !CONFIG_TRACEPOINTS, no?

kernel/trace/Kconfig says
# All tracer options should select GENERIC_TRACER. [...]

If one uses tracepoints without trace_events, they still compile away.

If using tracepoints directly, not using the (admittedly elegant)
trace-events macro system, is in fact not wanted anymore, then
Documentation/trace/* should be changed accordingly.

So what is the plan, going forward?

-- 
: Lars Ellenberg
: LINBIT | Your Way to High Availability
: DRBD/HA support and consulting http://www.linbit.com

DRBD® and LINBIT® are registered trademarks of LINBIT, Austria.
