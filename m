Return-Path: <linux-kernel-owner+w=401wt.eu-S1753552AbYDXUqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552AbYDXUqa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 16:46:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752958AbYDXUqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 16:46:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51897 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756558AbYDXUqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 16:46:15 -0400
Date: Thu, 24 Apr 2008 13:45:51 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RxRPC: Fix a regression in the RXKAD security module
In-Reply-To: <20080424193856.14737.16718.stgit@warthog.procyon.org.uk>
Message-ID: <alpine.LFD.1.10.0804241248290.2779@woody.linux-foundation.org>
References: <20080424193856.14737.16718.stgit@warthog.procyon.org.uk>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 24 Apr 2008, David Howells wrote:
>
> Fix a regression in the RXKAD security module introduced in:
> 
> 	commit 91e916cffec7c0153c5cbaa447151862a7a9a047
> 	Author: Al Viro <viro@ftp.linux.org.uk>
> 	Date:   Sat Mar 29 03:08:38 2008 +0000
> 
> 	net/rxrpc trivial annotations
> 
> A variable was declared as a 16-bit type rather than a 32-bit type.

Ok, that looks stupid, and should even have had a warning (shifting a u16 
right by 16 should warn about it being pointless, but doesn't, because the 
compiler quietly expands it to "int" in the meantime).

Hmm. I could do something to sparse that warns about that too. 

		Linus
