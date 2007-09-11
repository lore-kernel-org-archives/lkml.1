Return-Path: <linux-kernel-owner+w=401wt.eu-S966949AbXIKUQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966949AbXIKUQS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 16:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965670AbXIKUHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 16:07:11 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55754 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965617AbXIKUHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 16:07:07 -0400
Date: Tue, 11 Sep 2007 13:07:06 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
cc: Nick Piggin <nickpiggin@yahoo.com.au>, andrea@suse.de,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
In-Reply-To: <20070911121225.GE13132@lazybastard.org>
Message-ID: <Pine.LNX.4.64.0709111303590.25781@schroedinger.engr.sgi.com>
References: <20070911060349.993975297@sgi.com> <200709110452.20363.nickpiggin@yahoo.com.au>
 <20070911121225.GE13132@lazybastard.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1700579579-144647362-1189541226=:25781"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1700579579-144647362-1189541226=:25781
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Tue, 11 Sep 2007, J=F6rn Engel wrote:

> While I agree with your concern, those numbers are quite silly.  The
> chances of 99.8% of pages being free and the remaining 0.2% being
> perfectly spread across all 2MB large_pages are lower than those of SHA1
> creating a collision.  I don't see anyone abandoning git or rsync, so
> your extreme example clearly is the wrong one.
>=20
> Again, I agree with your concern, even though your example makes it look
> silly.

You may want to consider Mel's antifrag approaches which certainly=20
decreases the chance of this occurring. Reclaim can open up the needed=20
linear memory hole in a intentional way. The memory compaction approach=20
can even move pages to open up these 2M holes. The more pages we make=20
movable (see f.e. the targeted slab reclaim patchset that makes slab=20
pages movable) the more reliable higher order allocations become.

---1700579579-144647362-1189541226=:25781--
