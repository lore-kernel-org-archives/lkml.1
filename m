Return-Path: <linux-kernel-owner+w=401wt.eu-S1761821AbZE1MYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761821AbZE1MYe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 08:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755458AbZE1MY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 08:24:27 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:59978 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584AbZE1MY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 08:24:26 -0400
Subject: Re: [GIT PULL] scheduler fixes
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Nick Piggin <npiggin@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Jeff Garzik <jgarzik@pobox.com>, Alexander Viro <viro@ftp.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, cl@linux-foundation.org,
       mpm@selenic.com
In-Reply-To: <20090528121222.GK6920@wotan.suse.de>
References: <20090525051521.GC23032@elte.hu>
	 <Pine.LNX.4.64.0905251142140.32568@melkki.cs.Helsinki.FI>
	 <20090525112504.GB24071@wotan.suse.de>
	 <84144f020905250437x585e66a2oc1124a4f1f43059d@mail.gmail.com>
	 <20090525114127.GE24071@wotan.suse.de>
	 <Pine.LNX.4.64.0905251443390.4115@melkki.cs.Helsinki.FI>
	 <alpine.LFD.2.01.0905250930530.3435@localhost.localdomain>
	 <4A1AE5CC.1000209@cs.helsinki.fi> <20090526073813.GE21496@wotan.suse.de>
	 <1243512400.11533.33.camel@penberg-laptop>
	 <20090528121222.GK6920@wotan.suse.de>
Date: Thu, 28 May 2009 15:24:26 +0300
Message-Id: <1243513466.11533.57.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-28 at 14:12 +0200, Nick Piggin wrote:
> Oh right, I didn't actually look. An initcall should be fine, but
> I wonder why it is crashing if you move it before vfs_caches_init_early?
> Those just allocate inode and dentry hash tables...

That's because we pass HASH_EARLY to alloc_large_system_hash(). Should
be easy enough to fix, though.

