Return-Path: <linux-kernel-owner+w=401wt.eu-S1031274AbXFHShD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031274AbXFHShD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 14:37:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968937AbXFHSgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 14:36:54 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33552 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968169AbXFHSgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 14:36:53 -0400
Date: Fri, 8 Jun 2007 11:35:56 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Theodore Tso <tytso@mit.edu>
cc: Davide Libenzi <davidel@xmailserver.org>,
       Ulrich Drepper <drepper@redhat.com>, Eric Dumazet <dada1@cosmosbay.com>,
       Kyle Moffett <mrmacman_g4@mac.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
In-Reply-To: <20070608120746.GD12687@thunk.org>
Message-ID: <alpine.LFD.0.98.0706081132150.4205@woody.linux-foundation.org>
References: <466741BD.20106@redhat.com> <20070607110432.73be7960@the-village.bc.nu>
 <B8B9EC80-2E36-433E-87EB-5B31FF42FBCF@mac.com> <20070607151243.22caab9e.dada1@cosmosbay.com>
 <Pine.LNX.4.64.0706071243090.6445@alien.or.mcafeemobile.com>
 <466864F8.2050903@cosmosbay.com> <46686810.6030805@redhat.com>
 <Pine.LNX.4.64.0706071438020.6445@alien.or.mcafeemobile.com>
 <466880A4.3090908@redhat.com> <Pine.LNX.4.64.0706071534280.6445@alien.or.mcafeemobile.com>
 <20070608120746.GD12687@thunk.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 8 Jun 2007, Theodore Tso wrote:
>
> ... and it's not like sys_close() or sys_open() is a majorly critical 
> path, is it?

open/close/stat/lstat are _the_ most important system calls, so yes, it's 
a majorly critical path. MUCH more so than opening a new TCP connection.

You _may_ open a few hundred TCP connections a second (yeah, yeah, don't 
tell me about unrealistic benchmarks that do more), but that's on a server 
with good bandwidth etc. open/closes easily happen tens of _thousands_ of 
times a second. We're talking sub-microsecond system calls.

Whether get_random_int() is noticeable or not, I dunno. But that path is a 
hell of a lot more performance-sensitive than pretty much anything else.

		Linus
