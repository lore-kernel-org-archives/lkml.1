Return-Path: <linux-kernel-owner+w=401wt.eu-S1753416AbZF1Uk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbZF1Uk7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 16:40:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752696AbZF1Ukv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 16:40:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56652 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbZF1Ukv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 16:40:51 -0400
Date: Sun, 28 Jun 2009 16:40:46 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Julien Tinnes <jt@cr0.org>
Cc: hch@infradead.org, security@kernel.org, taviso@sdf.lonestar.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/1] personality handling: fix PER_CLEAR_ON_SETID for
	security reasons
Message-ID: <20090628204046.GA21363@infradead.org>
References: <deb7a2310906261127v2fd1564elb823716ae03fc0d4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <deb7a2310906261127v2fd1564elb823716ae03fc0d4@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 26, 2009 at 08:27:40PM +0200, Julien Tinnes wrote:
> Hello,
> 
> We have found that the current PER_CLEAR_ON_SETID mask on Linux
> doesn't include neither ADDR_COMPAT_LAYOUT, nor MMAP_PAGE_ZERO.
> 
> The current mask is READ_IMPLIES_EXEC|ADDR_NO_RANDOMIZE.
> 
> We believe it is important to add MMAP_PAGE_ZERO, because by using
> this personality it is possible to have the first page mapped inside a
> process running as setuid root. This could be used in those scenarios:

I agree.

> Less importantly, we believe ADDR_COMPAT_LAYOUT should also be added
> since on x86 32bits it will in practice disable most of the address
> space layout randomization (only the stack will remain randomized).

Agree on this on, too.

> -#define PER_CLEAR_ON_SETID (READ_IMPLIES_EXEC|ADDR_NO_RANDOMIZE)
> +#define PER_CLEAR_ON_SETID
> (READ_IMPLIES_EXEC|ADDR_NO_RANDOMIZE|ADDR_COMPAT_LAYOUT|MMAP_PAGE_ZERO)

#define PER_CLEAR_ON_SETID \
	(READ_IMPLIES_EXEC | \
	 ADDR_NO_RANDOMIZE | \
	 ADDR_COMPAT_LAYOUT | \
	 MMAP_PAGE_ZERO)

to make it a little more readable (and work around your mailer
corrupting long lines :))
