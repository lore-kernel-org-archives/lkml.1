Return-Path: <linux-kernel-owner+w=401wt.eu-S934352AbXFFMvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934352AbXFFMvk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 08:51:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763473AbXFFMvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 08:51:33 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60320 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761469AbXFFMvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 08:51:32 -0400
Date: Wed, 6 Jun 2007 13:51:30 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Nitin Gupta <nitingupta910@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Hazelton <dhazelton@enter.net>,
       Richard Purdie <richard@openedhand.com>
Subject: Re: [RFC] LZO de/compression support - take 7
Message-ID: <20070606125130.GA13419@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Nitin Gupta <nitingupta910@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Daniel Hazelton <dhazelton@enter.net>,
	Richard Purdie <richard@openedhand.com>
References: <4cefeab80706060534h2461ddffu35f463d7728519a0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4cefeab80706060534h2461ddffu35f463d7728519a0@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 06:04:17PM +0530, Nitin Gupta wrote:
> Hi,
> 
> This is kernel port of LZO1X-1 compressor and LZO1X decompressor (safe
> version only).
> 
> * Changes since 'take 6' (Full Changelog after this):
> 1) Fixed unaligned memory access problems as pointed out by author --
> LZO_UNALIGNED_OK_{2,4} collapsed to UNALIGNED_OK which is #defined for
> archs that allow unaligned access (see lib/lzo1x/Makefile). For other
> archs, we fall down to byte-by-byte access avoiding any unaligned
> access. In original code, LZO_UNALIGNED_OK_{2,4} resp. describe if we
> can do unaligned access for ushort and uint32.

Please use get_unaligned() for any unaligned access in kernel space.

