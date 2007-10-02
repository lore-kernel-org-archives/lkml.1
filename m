Return-Path: <linux-kernel-owner+w=401wt.eu-S1757425AbXJBMTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425AbXJBMTt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 08:19:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955AbXJBMTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 08:19:40 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:2072 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757336AbXJBMTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 08:19:38 -0400
Date: Tue, 2 Oct 2007 13:19:15 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Thayne Harbaugh <thayne@c2.net>
cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, discuss@x86-64.org
Subject: Re: [PATCH] Inconsistent mmap()/mremap() flags
In-Reply-To: <1191308772.5200.66.camel@phantasm.home.enterpriseandprosperity.com>
Message-ID: <Pine.LNX.4.64.0710021304230.26719@blonde.wat.veritas.com>
References: <1190958393.5128.85.camel@phantasm.home.enterpriseandprosperity.com>
  <200710011313.30171.andi@firstfloor.org> 
 <1191293830.5200.22.camel@phantasm.home.enterpriseandprosperity.com> 
 <20071002051526.GA29615@one.firstfloor.org>
 <1191308772.5200.66.camel@phantasm.home.enterpriseandprosperity.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Oct 2007, Thayne Harbaugh wrote:
> On Tue, 2007-10-02 at 07:15 +0200, Andi Kleen wrote:
> 
> > For mmap you can emulate it by passing a low hint != 0 (e.g. getpagesize()) 
> > in address but without MAP_FIXED and checking if the result is not beyond
> > your range.
> 
> Cool.  That's a much better solution for multiple reasons - like you
> mention, MAP_32BIT is only 2GB as well as it's only available on x86_64.
> 
> > > > Given for mremap() it is not that easy because there is no "hint" argument
> > > > without MREMAP_FIXED; but unless someone really needs it i would prefer
> > > > to not propagate the hack. If it's really needed it's probably better
> > > > to implement a start search hint for mremap()

I think you can do it already, without us complicating mremap further
with such a start search hint.

First call mmap with a low hint address, the new size you'll be wanting
from the mremap, PROT_NONE, MAP_ANONYMOUS, -1, 0.  Then call mremap with
old address, old size, new size, MREMAP_MAYMOVE|MREMAP_FIXED, and new
address as returned by the preparatory mmap.

Hugh
