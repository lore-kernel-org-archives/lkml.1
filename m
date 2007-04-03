Return-Path: <linux-kernel-owner+w=401wt.eu-S1753699AbXDCX1D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699AbXDCX1D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 19:27:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753705AbXDCX1D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 19:27:03 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33506 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753699AbXDCX1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 19:27:01 -0400
Date: Tue, 3 Apr 2007 16:27:00 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Badari Pulavarty <pbadari@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc5-mm4
In-Reply-To: <1175642398.6185.9.camel@dyn9047017100.beaverton.ibm.com>
Message-ID: <Pine.LNX.4.64.0704031626020.12109@schroedinger.engr.sgi.com>
References: <20070402224745.71a25af7.akpm@linux-foundation.org> 
 <1175637332.6185.4.camel@dyn9047017100.beaverton.ibm.com>
 <1175642398.6185.9.camel@dyn9047017100.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Apr 2007, Badari Pulavarty wrote:

> On Tue, 2007-04-03 at 14:55 -0700, Badari Pulavarty wrote:
> > On Mon, 2007-04-02 at 22:47 -0700, Andrew Morton wrote:
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm4/
> > 
> > 
> > 
> > SLUB code paniced my x86-64 box also :(
> 
> More on this panic.. line of code causing the issue is:
> 
> mm/slub.c:1133
>     2df1:       49 8b 04 c4             mov    (%r12,%rax,8),%rax
>     2df5:       48 89 43 20             mov    %rax,0x20(%rbx)
>       
> page->freelist = object[page->offset];
> 
> Hope this helps.

Yes. Could you boot with "slub_debug" set? Looks like a slab object may 
be getting corrupted.

x86_64 with numa emulation 4 nodes boots fine here.

