Return-Path: <linux-kernel-owner+w=401wt.eu-S1756834AbYAGTjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834AbYAGTjn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 14:39:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753276AbYAGTje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 14:39:34 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59983 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751517AbYAGTje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 14:39:34 -0500
Date: Mon, 7 Jan 2008 11:38:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: kamalesh@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, bunk@kernel.org,
       apw@shadowen.org, balbir@linux.vnet.ibm.com
Subject: Re: Linux 2.6.24-rc7 Build-Failure at
 __you_cannot_kmalloc_that_much
Message-Id: <20080107113831.0865cf5e.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0801071014450.22642@schroedinger.engr.sgi.com>
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org>
	<478200A4.4090707@linux.vnet.ibm.com>
	<20080107100733.3655f74f.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0801071014450.22642@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jan 2008 10:31:53 -0800 (PST)
Christoph Lameter <clameter@sgi.com> wrote:

> On Mon, 7 Jan 2008, Andrew Morton wrote:
> 
> > > : undefined reference to `__you_cannot_kmalloc_that_much'
> 
> There is also a kernel.org bugzilla for this at
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=9669
> For some reason my adds to this do not show up.
> 
> In both cases we have a 
> 
> k(z/m)alloc(sizeof(*pointer), ...)
> 
> that is for some reason failing. I guess what happens is that the function 
> in which this occurs is too complex for gcc 3.2. Thus it stops constant 
> folding the sizeof(*pointer) in the complex inline-if-cascade that SLAB 
> needs to determine the cache and does not eliminate the 
> __you_cannot_kmalloc_that_much branch().
> 
> SLUB in that case just puts a series of if comparisions in the code. This 
> means compilation does not fail but a large amount of code is generated.

ug.  Silent and nasty.

> We could replace the __you_cannot_kmalloc_that_much() with a BUG() 
> statement so we have the same effect in SLAB?

I think it'd be better to just put suitable workarounds at the offending
callsites.  We've only seen three or four of them in several months.

