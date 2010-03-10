Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932665Ab0CJSPv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 13:15:51 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:32851 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727Ab0CJSPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 13:15:49 -0500
Date: Wed, 10 Mar 2010 13:15:48 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Hans-Peter Jansen <hpj@urpla.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: howto combat highly pathologic latencies on a server?
Message-ID: <20100310181548.GA25684@infradead.org>
References: <201003101817.42812.hpj@urpla.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003101817.42812.hpj@urpla.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 10, 2010 at 06:17:42PM +0100, Hans-Peter Jansen wrote:
> While this system usually operates fine, it suffers from delays, that are 
> displayed in latencytop as: "Writing page to disk:     8425,5 ms": 
> ftp://urpla.net/lat-8.4sec.png, but we see them also in the 1.7-4.8 sec 
> range: ftp://urpla.net/lat-1.7sec.png, ftp://urpla.net/lat-2.9sec.png, 
> ftp://urpla.net/lat-4.6sec.png and ftp://urpla.net/lat-4.8sec.png.
> 
> >From other observations, this issue "feels" like it is induced by single 
> syncronisation points in the block layer, eg. if I create heavy IO load on 
> one RAID array, say resizing a VMware disk image, it can take up to a 
> minute to log in by ssh, although the ssh login does not touch this area at 
> all (different RAID arrays). Note, that the latencytop snapshots above are 
> made during normal operation, not this kind of load..

I had very similar issues on various systems (mostly using xfs, but some
with ext3, too) using kernels before ~ 2.6.30 when using the cfq I/O
scheduler.  Switching to noop fixed that for me, or upgrading to a
recent kernel where cfq behaves better again.

