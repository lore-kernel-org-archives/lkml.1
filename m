Return-Path: <linux-kernel-owner+w=401wt.eu-S1759051AbXIYVVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759051AbXIYVVl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 17:21:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753970AbXIYVVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 17:21:33 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:44612 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752944AbXIYVVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 17:21:33 -0400
Date: Tue, 25 Sep 2007 14:21:29 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Valdis.Kletnieks@vt.edu
cc: Kyle Moffett <mrmacman_g4@mac.com>, Alexey Dobriyan <adobriyan@gmail.com>,
       akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Uninline kcalloc()
In-Reply-To: <5202.1190639853@turing-police.cc.vt.edu>
Message-ID: <Pine.LNX.4.64.0709251421001.4917@schroedinger.engr.sgi.com>
References: <20070922200349.GA2119@martell.zuzino.mipt.ru>
 <25045.1190612108@turing-police.cc.vt.edu>           
 <902BC866-59A0-4E50-8299-64D38D9E93B1@mac.com> <5202.1190639853@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Sep 2007, Valdis.Kletnieks@vt.edu wrote:

> I think I looked at that, and it wasn't as easy as it looked, because there
> were ugly corner cases for what __builtin_return_address() returned depending
> on exactly what did or didn't get inlined. Basically, it's ugly stuff - if you
> try to use __builtin_retur_address inside kcalloc to pass to __kmalloc, and
> then kcalloc gets inlined, you end up passing not the routine you wanted (the
> caller of kcalloc), but the *parent* of that...

Note that this can be done in a clean way in SLUB using slab_alloc() which 
takes a address parameter as obtained from __builtin_return_address().

