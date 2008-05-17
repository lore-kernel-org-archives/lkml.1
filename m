Return-Path: <linux-kernel-owner+w=401wt.eu-S1757076AbYEQPjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757076AbYEQPjT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 11:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753657AbYEQPjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 11:39:08 -0400
Received: from gate.crashing.org ([63.228.1.57]:40973 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753643AbYEQPjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 11:39:07 -0400
Subject: Re: [PATCH] remove double indirection on tlb parameter to
	free_pgd_range()& Co
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Jan Beulich <jbeulich@novell.com>
Cc: Hugh Dickins <hugh@veritas.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrea Arcangeli <andrea@qumranet.com>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
In-Reply-To: <482DC4A9.76E4.0078.0@novell.com>
References: <482C6917.76E4.0078.0@novell.com>
	 <Pine.LNX.4.64.0805161517510.8758@blonde.site>
	 <482DC4A9.76E4.0078.0@novell.com>
Content-Type: text/plain
Date: Sat, 17 May 2008 10:27:43 -0500
Message-Id: <1211038063.8297.133.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-05-16 at 16:30 +0100, Jan Beulich wrote:
> >>> Hugh Dickins <hugh@veritas.com> 16.05.08 16:39 >>>
> >    Pass mmu_gather** in the
> >    public interfaces, since we might want to add latency lockdrops later;
> >    but no attempt to do so yet, going by vma should itself reduce latency.
> >...
> >But, returning to the start, please let's hold yours back after all.
> 
> If you want to keep and actively use the double indirection, would you
> guarantee current semantics like ->mm and ->fullmm to always be what
> was specified at the start of the operation? Verifying this was what
> made me go through that call tree in the first place, and obviously this
> is harder to verify when there is potential for the whole structure
> pointed to to be replaced by another one.

In my patches, I did drop the double indirection and just updated the
fields inside of the batch. Worked fine.

Ben.


