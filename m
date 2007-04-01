Return-Path: <linux-kernel-owner+w=401wt.eu-S932837AbXDAHPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932837AbXDAHPI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 03:15:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932835AbXDAHPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 03:15:08 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:36808 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932878AbXDAHPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 03:15:07 -0400
Date: Sun, 1 Apr 2007 00:15:06 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: "Paolo 'Blaisorblade' Giarrusso" <blaisorblade@yahoo.it>,
       linux-kernel@vger.kernel.org, Christoph Lameter <clameter@engr.sgi.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 3/3] slab: avoid __initdata warning (may be a bogus one)
In-Reply-To: <20070331222813.bd66ae05.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0704010011390.23774@schroedinger.engr.sgi.com>
References: <20070330230746.19809.2000.stgit@americanbeauty.home.lan>
 <20070330230814.19809.15981.stgit@americanbeauty.home.lan>
 <20070331222813.bd66ae05.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Mar 2007, Andrew Morton wrote:

> Yes, I think this is a flase positive - we'll never touch initkmem_list3[]
> after free_initmem() because of the transitions of g_cpucache_up.

Correct.
 
> (In which case set_up_list3s() shoud be __init, too?)

Correct. Its only called during slab bootstrap.

> Christoph, I think you looked at this previously?

If you change set_up_list3s to __init then we have the same issue with 
setup_cpu_cache right?
