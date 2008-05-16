Return-Path: <linux-kernel-owner+w=401wt.eu-S1759469AbYEPPaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759469AbYEPPaU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 11:30:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750998AbYEPPaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 11:30:05 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:36845 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbYEPPaE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 11:30:04 -0400
Message-Id: <482DC4A9.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Fri, 16 May 2008 16:30:17 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Hugh Dickins" <hugh@veritas.com>
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
       "Andrea Arcangeli" <andrea@qumranet.com>,
       "Christoph Lameter" <clameter@sgi.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] remove double indirection on tlb parameter to
	free_pgd_range()& Co
References: <482C6917.76E4.0078.0@novell.com>
 <Pine.LNX.4.64.0805161517510.8758@blonde.site>
In-Reply-To: <Pine.LNX.4.64.0805161517510.8758@blonde.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Hugh Dickins <hugh@veritas.com> 16.05.08 16:39 >>>
>    Pass mmu_gather** in the
>    public interfaces, since we might want to add latency lockdrops later;
>    but no attempt to do so yet, going by vma should itself reduce latency.
>...
>But, returning to the start, please let's hold yours back after all.

If you want to keep and actively use the double indirection, would you
guarantee current semantics like ->mm and ->fullmm to always be what
was specified at the start of the operation? Verifying this was what
made me go through that call tree in the first place, and obviously this
is harder to verify when there is potential for the whole structure
pointed to to be replaced by another one.

Jan

