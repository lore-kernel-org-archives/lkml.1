Return-Path: <linux-kernel-owner+w=401wt.eu-S1758306AbXIVG0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758306AbXIVG0A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 02:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752099AbXIVGZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 02:25:54 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:34583 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbXIVGZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 02:25:53 -0400
Date: Sat, 22 Sep 2007 00:25:51 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Olof Johansson <olof@lixom.net>, linuxppc-dev@ozlabs.org,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
       hch@lst.de
Subject: Re: [PATCH v2] pcmcia: Convert io_req_t to use kio_addr_t
Message-ID: <20070922062551.GE10625@parisc-linux.org>
References: <20070905142742.GA1760@lixom.net> <20070914034854.1658a9cf.akpm@linux-foundation.org> <20070921221516.GA7926@lixom.net> <20070921233936.2aeb2504@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070921233936.2aeb2504@the-village.bc.nu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2007 at 11:39:36PM +0100, Alan Cox wrote:
> On Fri, 21 Sep 2007 17:15:16 -0500
> Olof Johansson <olof@lixom.net> wrote:
> 
> > Convert the io_req_t members to kio_addr_t, to allow use on machines with
> > more than 16 bits worth of IO ports (i.e. secondary busses on ppc64, etc).
> 
> What about the formatting and field widths ?
> 
> ulong would probably be a lot saner than kio_addr_t and yet more type
> obfuscation.

I don't think anyone uses ioports > 32bit.  Certainly i386 takes an int
port as parameter to {in,out}[bwl] (and it really only uses 16-bits).
parisc uses 24 bits.  I don't know what the various ppcs do, but pci
bars can only be 32-bit for ioports.  So my opinion is that ioports
should be uint, not ulong.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
