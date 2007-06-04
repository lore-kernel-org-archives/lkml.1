Return-Path: <linux-kernel-owner+w=401wt.eu-S1755519AbXFDNdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519AbXFDNdd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 09:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752765AbXFDNdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 09:33:25 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:1277 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914AbXFDNdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 09:33:24 -0400
X-AuthUser: davidel@xmailserver.org
Date: Mon, 4 Jun 2007 06:33:23 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: [patch 1/2] ufd v1 - unsequential O(1) fdmap core
In-Reply-To: <20070604152540.985c186a.dada1@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0706040631170.30231@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.24319.1180825145.1>
 <46633047.1020707@cosmosbay.com> <Pine.LNX.4.64.0706031536000.13247@alien.or.mcafeemobile.com>
 <20070603230859.5000424d.akpm@linux-foundation.org> <20070604080537.GA22898@elte.hu>
 <20070604080941.GA23537@elte.hu> <20070604013449.ea3acca8.akpm@linux-foundation.org>
 <20070604122857.1399e3fc.dada1@cosmosbay.com>
 <Pine.LNX.4.64.0706040523150.30231@alien.or.mcafeemobile.com>
 <20070604152540.985c186a.dada1@cosmosbay.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jun 2007, Eric Dumazet wrote:

> Bitmaps are already there, you didnt zap them.
> 
> Your proposal is going to double size taken by file table, since you need two long words
> per file instead of one pointer.
> 
> You add conditional branches on very hot spots.
> 
> When you open/close a file, you need to access previous and next cells, so you need 3 cache lines, exactly like
> current *legacy* code. (one for file pointer, one on each bitmap flags(open/close_on_exec) )
> 
> O(1) lookup doesnt imply it needs to be super-fast. You make a confusion about this.
> 
> O(128) is still O(1) for instance. Having to search a bit in a PAGE is a sensible compromise, if we dont add overhead
> on each fget() calls.
> 
> Instead of adding complexity and a pile of new bugs  (see how long it takes to bring RCU on files to a stable state), we can take a safe path. Then if it happens to still be a problem, we can consider the painfull way.
> 
> I probably can code a < 100 lines patch, later this evening after my day job.

fdmap.c is 300 lines of code, w/out comments. You're trying to fit the 
wrong structure. It is *that* simple.


- Davide


