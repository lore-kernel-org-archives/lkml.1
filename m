Return-Path: <linux-kernel-owner+w=401wt.eu-S1760333AbXLOQbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760333AbXLOQbp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 11:31:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751317AbXLOQbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 11:31:36 -0500
Received: from waste.org ([66.93.16.53]:56297 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904AbXLOQbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 11:31:35 -0500
Date: Sat, 15 Dec 2007 10:30:10 -0600
From: Matt Mackall <mpm@selenic.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: John Reiser <jreiser@BitWagon.com>, akpm@linux-foundation.org,
       tytso@mit.edu, linux-kernel@vger.kernel.org
Subject: Re: /dev/urandom uses uninit bytes, leaks user data
Message-ID: <20071215163010.GS19691@waste.org>
References: <47632010.6030709@BitWagon.com> <E1J3RD5-0006yU-00@gondolin.me.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1J3RD5-0006yU-00@gondolin.me.apana.org.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 15, 2007 at 03:13:19PM +0800, Herbert Xu wrote:
> John Reiser <jreiser@bitwagon.com> wrote:
> >
> > If speed matters that much, then please recoup 33 cycles on x86
> > by using shifts instead of three divides, such as (gcc 4.1.2):
> > 
> >                add_entropy_words(r, tmp, (bytes + 3) / 4);
> > 
> > 0x8140689 <xfer_secondary_pool+206>:    lea    0x3(%esi),%eax
> > 0x814068c <xfer_secondary_pool+209>:    mov    $0x4,%dl
> > 0x814068e <xfer_secondary_pool+211>:    mov    %edx,%edi
> > 0x8140690 <xfer_secondary_pool+213>:    cltd
> > 0x8140691 <xfer_secondary_pool+214>:    idiv   %edi
> 
> There ought to be a warning about this sort of thing.

Indeed. Seems it would be better to adjust the types appropriately.
Anyway, this is no longer relevant to security@.

-- 
Mathematics is the supreme nostalgia of our time.
