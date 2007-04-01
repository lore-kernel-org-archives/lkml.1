Return-Path: <linux-kernel-owner+w=401wt.eu-S1752051AbXDAHbN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051AbXDAHbN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 03:31:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752093AbXDAHbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 03:31:13 -0400
Received: from smtp.osdl.org ([65.172.181.24]:52475 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051AbXDAHbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 03:31:11 -0400
Date: Sun, 1 Apr 2007 00:30:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>, Sam Ravnborg <sam@ravnborg.org>
Cc: "Paolo 'Blaisorblade' Giarrusso" <blaisorblade@yahoo.it>,
       linux-kernel@vger.kernel.org, Christoph Lameter <clameter@engr.sgi.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 3/3] slab: avoid __initdata warning (may be a bogus one)
Message-Id: <20070401003059.b830fb85.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0704010011390.23774@schroedinger.engr.sgi.com>
References: <20070330230746.19809.2000.stgit@americanbeauty.home.lan>
	<20070330230814.19809.15981.stgit@americanbeauty.home.lan>
	<20070331222813.bd66ae05.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704010011390.23774@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Apr 2007 00:15:06 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:

> On Sat, 31 Mar 2007, Andrew Morton wrote:
> 
> > Yes, I think this is a flase positive - we'll never touch initkmem_list3[]
> > after free_initmem() because of the transitions of g_cpucache_up.
> 
> Correct.
>  
> > (In which case set_up_list3s() shoud be __init, too?)
> 
> Correct. Its only called during slab bootstrap.
> 
> > Christoph, I think you looked at this previously?
> 
> If you change set_up_list3s to __init then we have the same issue with 
> setup_cpu_cache right?

yup.

I wonder if there's a general way in which we can suppress such false
positives.  Say, create a new section called, umm, __nowarn and
__nowarndata and then we can tag functions or data with those tags tag and teach
the checker tools to ignore them?


