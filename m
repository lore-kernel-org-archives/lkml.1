Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932979Ab0CKAP3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 19:15:29 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:59112 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932969Ab0CKAP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 19:15:28 -0500
From: "Hans-Peter Jansen" <hpj@urpla.net>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: howto combat highly pathologic latencies on a server?
Date: Thu, 11 Mar 2010 01:15:14 +0100
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
References: <201003101817.42812.hpj@urpla.net> <20100310181548.GA25684@infradead.org>
In-Reply-To: <20100310181548.GA25684@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003110115.14555.hpj@urpla.net>
X-Provags-ID: V01U2FsdGVkX18ToHUj+BvpFOgnMqMjdGlL2VJERBQRszFiijJ
 E9fFyzEVddGDLGlI5jCJft8nbDkgn0XuIYZL1kq2/inFRNCibB
 1/1JViywB6tzIglU8cz0g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 March 2010, 19:15:48 Christoph Hellwig wrote:
> On Wed, Mar 10, 2010 at 06:17:42PM +0100, Hans-Peter Jansen wrote:
> > While this system usually operates fine, it suffers from delays, that
> > are displayed in latencytop as: "Writing page to disk:     8425,5 ms":
> > ftp://urpla.net/lat-8.4sec.png, but we see them also in the 1.7-4.8 sec
> > range: ftp://urpla.net/lat-1.7sec.png, ftp://urpla.net/lat-2.9sec.png,
> > ftp://urpla.net/lat-4.6sec.png and ftp://urpla.net/lat-4.8sec.png.
> >
> > >From other observations, this issue "feels" like it is induced by
> > > single
> >
> > syncronisation points in the block layer, eg. if I create heavy IO load
> > on one RAID array, say resizing a VMware disk image, it can take up to
> > a minute to log in by ssh, although the ssh login does not touch this
> > area at all (different RAID arrays). Note, that the latencytop
> > snapshots above are made during normal operation, not this kind of
> > load..
>
> I had very similar issues on various systems (mostly using xfs, but some
> with ext3, too) using kernels before ~ 2.6.30 when using the cfq I/O
> scheduler.  Switching to noop fixed that for me, or upgrading to a
> recent kernel where cfq behaves better again.

Christoph, thanks for this valuable suggestion: I've changed it to noop 
right away, and also:

vm.dirty_ratio = 20
vm.dirty_background_ratio = 1

since the defaults of 40 and 10 seem to also not fit my needs. Even the 20 
might be still oversized with 8GB total mem. 

Thanks,
Pete
