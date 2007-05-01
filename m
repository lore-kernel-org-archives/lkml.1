Return-Path: <linux-kernel-owner+w=401wt.eu-S1754369AbXEAQX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369AbXEAQX2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 12:23:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754375AbXEAQX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 12:23:28 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54545 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754369AbXEAQX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 12:23:27 -0400
Date: Tue, 1 May 2007 09:23:08 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [AF_RXRPC]: Make the in-kernel AFS filesystem use AF_RXRPC.
In-Reply-To: <Pine.LNX.4.64.0705011734410.27246@anakin>
Message-ID: <alpine.LFD.0.98.0705010918550.3808@woody.linux-foundation.org>
References: <200704271707.l3RH7H5Z032671@hera.kernel.org>
 <Pine.LNX.4.64.0705011734410.27246@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 1 May 2007, Geert Uytterhoeven wrote:
> 
> This causes a compile failure on m68k:
> 
> | linux/fs/afs/fsclient.c: In function 'afs_deliver_fs_fetch_data':
> | linux/fs/afs/fsclient.c:269: warning: dereferencing 'void *' pointer
> | linux/fs/afs/fsclient.c:269: error: request for member 'virtual' in something not a structure or union
> 
> Probably you wanted to assign call->reply3 to a struct page pointer first, like you do for the call->unmarshall == 2 case.

Hmm. Wouldn't it be nicer to make "kmap_atomic()" be an inline function 
instead? That way, if you pass it a "void *", it still just works, and you 
get a much nicer/more readable error message too when the types actually 
don't match?

Of course, there may be some reason why <linux/highmem.h> does those with 
#define's rather than inline functions. Maybe "page_address()" or 
"pagefault_disabled()" is not declared at that point, and asking it to be 
declared might cause header file inclusion recursion?

		Linus
