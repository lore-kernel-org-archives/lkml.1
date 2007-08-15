Return-Path: <linux-kernel-owner+w=401wt.eu-S1762726AbXHOB4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762726AbXHOB4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 21:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756307AbXHOB4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 21:56:08 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:49017 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754412AbXHOB4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 21:56:06 -0400
Date: Tue, 14 Aug 2007 18:56:03 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Michael Ellerman <michael@ellerman.id.au>
cc: Lucio Correia <ljhc@br.ibm.com>, linux-kernel@vger.kernel.org,
       Arnd Bergmann <arndb@arndb.de>
Subject: Re: SLUB doesn't work with kdump kernel on Cell
In-Reply-To: <dc1166600708141757q26c005d7o4c9c4d69e9d28460@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0708141854040.1334@schroedinger.engr.sgi.com>
References: <1186604151.3608.46.camel@localhost.localdomain> 
 <Pine.LNX.4.64.0708081321400.14478@schroedinger.engr.sgi.com> 
 <1187106239.3298.2.camel@localhost.localdomain> 
 <Pine.LNX.4.64.0708141241450.30435@schroedinger.engr.sgi.com>
 <dc1166600708141757q26c005d7o4c9c4d69e9d28460@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Aug 2007, Michael Ellerman wrote:

> > Yes SLUB will fall back but not during bootstrap. Bootstrap needs to
> > carefully place structures on the right nodes. We fail during bootstrap
> > because there is *no* memory available on it.
> 
> Sure, you want to have the structures on the right node if possible.
> But seeing as there's no memory available, what is wrong with just
> falling back?

Then you have a useless kmem_cache_node structure that will never be used.

What I could do is an alloc without GFP_THISNODE, check the location of 
the allocated memory and then print out a big fat warning that the memory 
setup is screwed up?

