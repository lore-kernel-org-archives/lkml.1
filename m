Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1758093AbXHAEVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758093AbXHAEVK (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 1 Aug 2007 00:21:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751365AbXHAEU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 00:20:56 -0400
Received: from ozlabs.org ([203.10.76.45]:56408 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501AbXHAEUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 00:20:55 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18096.2592.877510.221163@cargo.ozlabs.ibm.com>
Date: Wed, 1 Aug 2007 14:20:48 +1000
From: Paul Mackerras <paulus@samba.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@ftp.linux.org.uk>, Alexey Dobriyan <adobriyan@sw.ru>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        herbert@gondor.apana.org.au
Subject: Re: WARN_ON() which sometimes sucks
In-Reply-To: <alpine.LFD.0.999.0707312101410.3582@woody.linux-foundation.org>
References: <20070731155527.GB7253@localhost.sw.ru>
	<20070731160248.GK21089@ftp.linux.org.uk>
	<18096.949.934194.648312@cargo.ozlabs.ibm.com>
	<alpine.LFD.0.999.0707312101410.3582@woody.linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds writes:

> Umm. The WARN_ON() might actually get a "long long" value for all we know. 
> Ie it's perfectly possible that the WARN_ON might look like
> 
> 	/* Must not have high bits on */
> 	WARN_ON(offset & 0xffffffff00000000);
> 
> which on a 32-bit pcc would apparently do the wrong thing entirely as it 
> stands now. No?

Actually, because of the typeof in the powerpc WARN_ON, I think it
would fail to build since we'd be passing a long long value to an
inline asm, or at least I hope it would fail to build. :)

But your criticism is correct with regard to the powerpc BUG_ON, and
you're correct that a long wouldn't be sufficient if someone passes in
a long long.  Oh well.  I guess we just wear the extra two
instructions.

Paul.
