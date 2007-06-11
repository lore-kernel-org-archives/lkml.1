Return-Path: <linux-kernel-owner+w=401wt.eu-S1756415AbXFKP6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756415AbXFKP6a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 11:58:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753979AbXFKP6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 11:58:15 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:41360 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857AbXFKP6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 11:58:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Xttslqe2JSdCaqDnG3hYHr77duhKPiU5ylt4IsEbwXuIMExP6WO+uqXhYXmSKUN6YlCwBCekOJJpmDG4L7Y9gbreHmk79ICbGISxdq/cpQ+4ih9Q4GgOJl4Kekm5Nhg+32BKIvGuZyAAde+sgGbFYTg6ZOn+AW59qC0udHtHgfU=
Message-ID: <1defaf580706110858r16b1b88bg2346734379574b52@mail.gmail.com>
Date: Mon, 11 Jun 2007 17:58:12 +0200
From: "=?ISO-8859-1?Q?H=E5vard_Skinnemoen?=" <hskinnemoen@gmail.com>
To: "Paul Mundt" <lethal@linux-sh.org>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Christoph Lameter" <clameter@sgi.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
Subject: Re: kernel BUG at mm/slub.c:3689!
In-Reply-To: <20070611153804.GA26209@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070611161926.2a9f8efd@dhcp-255-175.norway.atmel.com>
	 <20070611153804.GA26209@linux-sh.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/11/07, Paul Mundt <lethal@linux-sh.org> wrote:
> On Mon, Jun 11, 2007 at 04:19:26PM +0200, Haavard Skinnemoen wrote:
> > I think the combination that triggered this bug was:
> >   * CONFIG_SLUB_DEBUG=y
> >   * ARCH_KMALLOC_MINALIGN=32
> >   * slub_debug not set at the command line
> >
> ARCH_KMALLOC_MINALIGN and ARCH_SLAB_MINALIGN are both in bytes
> (ARCH_KMALLOC_MINALIGN used to be defined as BYTES_PER_WORD) if I recall
> correctly, are you sure this is what you want?

Yeah, I actually defined it to L1_CACHE_BYTES. The idea is to avoid
cacheline sharing between different kmalloc() allocations, which may
mess up DMA transfers. So 32 bytes alignment is indeed what I want.

Haavard
