Return-Path: <linux-kernel-owner+w=401wt.eu-S1756307AbXJYAn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307AbXJYAn5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 20:43:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753134AbXJYAnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 20:43:50 -0400
Received: from [198.99.130.12] ([198.99.130.12]:43040 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753055AbXJYAnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 20:43:49 -0400
Date: Wed, 24 Oct 2007 20:43:29 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       sparclinux@vger.kernel.org
Subject: Re: [uml-devel] User Mode Linux still doesn't build in 2.6.23-final.
Message-ID: <20071025004329.GA12372@c2.user-mode-linux.org>
References: <200710111754.46854.rob@landley.net> <20071024152240.GA7733@c2.user-mode-linux.org> <200710241646.54942.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710241646.54942.rob@landley.net>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2007 at 04:46:54PM -0500, Rob Landley wrote:
> Prebuilt for Ubuntu 7.04:
> http://landley.net/code/firmware/downloads/cross-compiler/host-i686/cross-compiler-sparc.tar.bz2
> 
> Source code:
> Or http://landley.net/code/firmware/downloads/firmware-0.2.2.tar.bz2

Thanks - I already got Dan Kegel's crosstools, and they did the trick.

What I'd like to do is have linux/swap.h include linux/pagemap.h, but
there's this scary comment about that not working on sparc.

When I fix this bug "correctly", sparc expodes into a mess of
interconnected headers which seem to boil down to sparc including
swap.h in pgtable.h when no one else does.

The thing is, sparc looks like it's doing things more correctly than
anyone else.  asm/pgtable.h (i386 and UML, and probably everyone
else except sparc) refers to swp_entry_t, which is defined in
linux/swap.h, without including swap.h and that's somehow OK.

So, from a quick look, it seems like this is a case of our headers
being too interconnected and sparc had to opt out in order to do
things more correctly.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
