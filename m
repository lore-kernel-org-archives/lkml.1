Return-Path: <linux-kernel-owner+w=401wt.eu-S1755899AbXIDWdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899AbXIDWdT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 18:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753872AbXIDWdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 18:33:10 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57438 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424AbXIDWdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 18:33:09 -0400
Date: Tue, 4 Sep 2007 23:33:04 +0100
From: Christoph Hellwig <hch@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christian Ehrhardt <lk@c--e.de>
Subject: Re: [GIT PULL] x86 setup: work around bug in Xen HVM
Message-ID: <20070904223303.GA22306@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Christian Ehrhardt <lk@c--e.de>
References: <200709041655.l84GtjiJ008962@tazenda.hos.anvin.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709041655.l84GtjiJ008962@tazenda.hos.anvin.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2007 at 09:55:45AM -0700, H. Peter Anvin wrote:
>     
>     Apparently XEN does not keep the contents of the 48-bit gdt_48 data
>     structure that is passed to lgdt in the XEN machine state. Instead it
>     appears to save the _address_ of the 48-bit descriptor
>     somewhere. Unfortunately this data happens to reside on the stack and
>     is probably no longer availiable at the time of the actual protected
>     mode jump.
>     
>     This is Xen bug but given that there is a one-line patch to work
>     around this problem, the linux kernel should probably do this.  My fix
>     is to make the gdt_48 description in setup_gdt static (in setup_idt
>     this is already the case). This allows the kernel to boot under
>     Xen HVM again.

> -	struct gdt_ptr gdt;
> +	static struct gdt_ptr gdt;

It might make sense to add your above commit message to the code as a comment.
