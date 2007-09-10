Return-Path: <linux-kernel-owner+w=401wt.eu-S1758792AbXIJMWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758792AbXIJMWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 08:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757498AbXIJMWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 08:22:07 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50303 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757563AbXIJMWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 08:22:05 -0400
Date: Mon, 10 Sep 2007 13:21:51 +0100
From: Christoph Hellwig <hch@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: hch@infradead.org, bunk@kernel.org, akpm@linux-foundation.org,
       perex@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] unexport sys_{open,read}
Message-ID: <20070910122151.GA7097@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	David Miller <davem@davemloft.net>, bunk@kernel.org,
	akpm@linux-foundation.org, perex@suse.cz,
	linux-kernel@vger.kernel.org
References: <20070909202527.GT3563@stusta.de> <20070909203920.GA11764@infradead.org> <20070910.051838.41660444.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070910.051838.41660444.davem@davemloft.net>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2007 at 05:18:38AM -0700, David Miller wrote:
> I'm happy to see this go too, but please add the necessary
> export to arch/sparc64/kernel/sparc64_ksyms.S so that the
> solaris system call table reference in
> arch/sparc64/solaris/systbls.S can be satisfied.
> 
> This keeps coming up, and people keep missing the reference
> in the solaris compatibility module.

Solaris emulation has it's own solaris_open which chains through
to sparc32_open, not sys_open.  Similarly for read it uses the
CHAIN macro which seems to go directly to the syscall table
instead of using the sys_read symbol.
