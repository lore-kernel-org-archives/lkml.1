Return-Path: <linux-kernel-owner+w=401wt.eu-S1758838AbXK1PEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758838AbXK1PEk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 10:04:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864AbXK1PEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 10:04:33 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:41513 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbXK1PEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 10:04:32 -0500
Date: Wed, 28 Nov 2007 10:03:38 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [uml-devel] leak in do_ubd_request
Message-ID: <20071128150338.GA5501@c2.user-mode-linux.org>
References: <E1Ix3Du-0002aL-Ac@dorka.pomaz.szeredi.hu> <E1Ix58o-0004J5-Mz@dorka.pomaz.szeredi.hu> <20071127201105.GA9332@c2.user-mode-linux.org> <E1Ix73b-0004aI-Px@dorka.pomaz.szeredi.hu> <20071127222020.GA10096@c2.user-mode-linux.org> <20071127213801.4def3c23.akpm@linux-foundation.org> <E1IxJMf-00067v-2r@dorka.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1IxJMf-00067v-2r@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2007 at 10:37:53AM +0100, Miklos Szeredi wrote:
> > Do we have any idea which patch this patch fixes?
> 
> I seems like a mainline bug, and has been present for some time
> (forever?).
> 
> I have no idea why this wasn't noticed earlier.

Not forever, but it's been there for a while - it was introduced here:

commit 2adcec2197897365e0a0f657f1098cbfdb44bc8b
Author: Jeff Dike <jdike@addtoit.com>
Date:   Sun May 6 14:51:37 2007 -0700

    uml: send pointers instead of structures to I/O thread
    
    Instead of writing entire structures between UML and the I/O thread, we send
    pointers.  This cuts down on the amount of data being copied and possibly
    allows more requests to be pending between the two.
    
    This requires that the requests be kmalloced and freed instead of living on
    the stack.
    
    Signed-off-by: Jeff Dike <jdike@linux.intel.com>
    Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

				Jeff

-- 
Work email - jdike at linux dot intel dot com
