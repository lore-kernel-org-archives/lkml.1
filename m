Return-Path: <linux-kernel-owner+w=401wt.eu-S937163AbXG0KBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937163AbXG0KBd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 06:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762347AbXG0KBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 06:01:25 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54920 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758032AbXG0KBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 06:01:24 -0400
Date: Fri, 27 Jul 2007 03:00:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       Frank Kingswood <frank@kingswood-consulting.co.uk>,
       Andi Kleen <andi@firstfloor.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Ray Lee <ray-lk@madrabbit.org>, Jesper Juhl <jesper.juhl@gmail.com>,
       ck list <ck@vds.kolivas.org>, Paul Jackson <pj@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: RFT: updatedb "morning after" problem [was: Re: -mm merge plans
 for 2.6.23]
Message-Id: <20070727030040.0ea97ff7.akpm@linux-foundation.org>
In-Reply-To: <20070727014749.85370e77.akpm@linux-foundation.org>
References: <9a8748490707231608h453eefffx68b9c391897aba70@mail.gmail.com>
	<46A57068.3070701@yahoo.com.au>
	<2c0942db0707232153j3670ef31kae3907dff1a24cb7@mail.gmail.com>
	<46A58B49.3050508@yahoo.com.au>
	<2c0942db0707240915h56e007e3l9110e24a065f2e73@mail.gmail.com>
	<46A6CC56.6040307@yahoo.com.au>
	<p73abtkrz37.fsf@bingen.suse.de>
	<46A85D95.509@kingswood-consulting.co.uk>
	<20070726092025.GA9157@elte.hu>
	<20070726023401.f6a2fbdf.akpm@linux-foundation.org>
	<20070726094024.GA15583@elte.hu>
	<20070726030902.02f5eab0.akpm@linux-foundation.org>
	<1185454019.6449.12.camel@Homer.simpson.net>
	<20070726110549.da3a7a0d.akpm@linux-foundation.org>
	<1185513177.6295.21.camel@Homer.simpson.net>
	<1185521021.6295.50.camel@Homer.simpson.net>
	<20070727014749.85370e77.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jul 2007 01:47:49 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> More sophisticated testing is needed - there's something in
> ext3-tools which will mmap, page in and hold a file for you.

So much for that theory.  afaict mmapped, active pagecache is immune to
updatedb activity.  It just sits there while updatedb continues munching
away at the slab and blockdev pagecache which it instantiated.  I assume
we're never getting the VM into enough trouble to tip it over the
start-reclaiming-mapped-pages threshold (ie: /proc/sys/vm/swappiness).

Start the updatedb on this 128MB machine with 80MB of mapped pagecache, it
falls to 55MB fairly soon and then never changes.

So hrm.  Are we sure that updatedb is the problem?  There are quite a few
heavyweight things which happen in the wee small hours.

