Return-Path: <linux-kernel-owner+w=401wt.eu-S1754184AbZCLIdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbZCLIdJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 04:33:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbZCLIcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 04:32:55 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33251 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbZCLIcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 04:32:54 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH 1/2] mm: use list.h for vma list
Cc: kosaki.motohiro@jp.fujitsu.com, Daniel Lowengrub <lowdanie@gmail.com>,
       linux-mm@kvack.org, Ingo Molnar <mingo@elte.hu>, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org
In-Reply-To: <200903112254.56764.nickpiggin@yahoo.com.au>
References: <8c5a844a0903110255q45b7cdf4u1453ce40d495ee2c@mail.gmail.com> <200903112254.56764.nickpiggin@yahoo.com.au>
Message-Id: <20090312172619.43BA.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Thu, 12 Mar 2009 17:32:49 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wednesday 11 March 2009 20:55:48 Daniel Lowengrub wrote:
> > Use the linked list defined list.h for the list of vmas that's stored
> > in the mm_struct structure.  Wrapper functions "vma_next" and
> > "vma_prev" are also implemented.  Functions that operate on more than
> > one vma are now given a list of vmas as input.
> 
> I'd love to be able to justify having a doubly linked list for vmas...
> It's easier than managing singly linked lists by hand :) So if you have
> such a good increase with lookups, it might be a good idea. I wouldn't
> like to see vm_area_struct go above 192 bytes on any config if possible
> though.

Currently, sizeof(struct vm_area_struct) on x86_64 is 176.
if we assume 32byte cache-line, 176byte is 6 cache-line.
then, making coubly linked list don't cause d-cache pollution. 

Therefore, We can merge this patch after some cleanups.
(of cource, your opining cleanups is obiously necessary...)



