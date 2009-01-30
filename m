Return-Path: <linux-kernel-owner+w=401wt.eu-S1758604AbZA3AoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758604AbZA3AoV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 19:44:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754418AbZA3AoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 19:44:10 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:42368 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201AbZA3AoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 19:44:08 -0500
Date: Fri, 30 Jan 2009 09:30:18 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       nishimura@mxp.nes.nec.co.jp
Subject: Re: [PATCH] migration: migrate_vmas should check "vma"
Message-Id: <20090130093018.c209d70d.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20090129001849.9f8fdcb3.akpm@linux-foundation.org>
References: <20090128162619.2205befd.nishimura@mxp.nes.nec.co.jp>
	<alpine.DEB.1.10.0901281140540.7765@qirst.com>
	<20090128165512.GA22588@cmpxchg.org>
	<20090129101623.0d64d81b.nishimura@mxp.nes.nec.co.jp>
	<20090129001849.9f8fdcb3.akpm@linux-foundation.org>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Jan 2009 00:18:49 -0800, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 29 Jan 2009 10:16:23 +0900 Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> 
> > On Wed, 28 Jan 2009 17:55:12 +0100, Johannes Weiner <hannes@cmpxchg.org> wrote:
> > > On Wed, Jan 28, 2009 at 11:42:36AM -0500, Christoph Lameter wrote:
> > > > On Wed, 28 Jan 2009, Daisuke Nishimura wrote:
> > > > 
> > > > > migrate_vmas() should check "vma" not "vma->vm_next" for for-loop condition.
> > > > 
> > > > The loop condition is checked before vma = vma->vm_next. So the last
> > > > iteration of the loop will now be run with vma = NULL?
> > > 
> > > No, the condition is always checked before the body is executed.  The
> > > assignment to vma->vm_next happens at the end of every body.
> > > 
> > So, I think in current code the loop body is not executed
> > about the last vma in the list.
> > 
> 
> Yep.
> 
> Is this serious enough to bother fixing in 2.6.29?
IIUC, there is no user of vm_ops->migrate() now, so this bug causes
no practical problems.

I think it's trival and simple enough to go in .29, but I don't have
any objection if you postpone this patch.


Thanks,
Daisuke Nishimura.
