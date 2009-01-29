Return-Path: <linux-kernel-owner+w=401wt.eu-S1755698AbZA2BXH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698AbZA2BXH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 20:23:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751453AbZA2BWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 20:22:54 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:65487 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbZA2BWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 20:22:53 -0500
Date: Thu, 29 Jan 2009 10:16:23 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       nishimura@mxp.nes.nec.co.jp
Subject: Re: [PATCH] migration: migrate_vmas should check "vma"
Message-Id: <20090129101623.0d64d81b.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20090128165512.GA22588@cmpxchg.org>
References: <20090128162619.2205befd.nishimura@mxp.nes.nec.co.jp>
	<alpine.DEB.1.10.0901281140540.7765@qirst.com>
	<20090128165512.GA22588@cmpxchg.org>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jan 2009 17:55:12 +0100, Johannes Weiner <hannes@cmpxchg.org> wrote:
> On Wed, Jan 28, 2009 at 11:42:36AM -0500, Christoph Lameter wrote:
> > On Wed, 28 Jan 2009, Daisuke Nishimura wrote:
> > 
> > > migrate_vmas() should check "vma" not "vma->vm_next" for for-loop condition.
> > 
> > The loop condition is checked before vma = vma->vm_next. So the last
> > iteration of the loop will now be run with vma = NULL?
> 
> No, the condition is always checked before the body is executed.  The
> assignment to vma->vm_next happens at the end of every body.
> 
So, I think in current code the loop body is not executed
about the last vma in the list.


Thanks,
Daisuke Nishimura.

> Try this:
> 
> 		int a = 2;
> 
> 		for (puts("init"); puts("cond"), a; puts("next"))
> 			a--;
> 
> 	Hannes
