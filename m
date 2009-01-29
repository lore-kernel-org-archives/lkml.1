Return-Path: <linux-kernel-owner+w=401wt.eu-S1755328AbZA2ITS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328AbZA2ITS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 03:19:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752098AbZA2ITE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 03:19:04 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60205 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752009AbZA2ITC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 03:19:02 -0500
Date: Thu, 29 Jan 2009 00:18:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH] migration: migrate_vmas should check "vma"
Message-Id: <20090129001849.9f8fdcb3.akpm@linux-foundation.org>
In-Reply-To: <20090129101623.0d64d81b.nishimura@mxp.nes.nec.co.jp>
References: <20090128162619.2205befd.nishimura@mxp.nes.nec.co.jp>
	<alpine.DEB.1.10.0901281140540.7765@qirst.com>
	<20090128165512.GA22588@cmpxchg.org>
	<20090129101623.0d64d81b.nishimura@mxp.nes.nec.co.jp>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Jan 2009 10:16:23 +0900 Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> On Wed, 28 Jan 2009 17:55:12 +0100, Johannes Weiner <hannes@cmpxchg.org> wrote:
> > On Wed, Jan 28, 2009 at 11:42:36AM -0500, Christoph Lameter wrote:
> > > On Wed, 28 Jan 2009, Daisuke Nishimura wrote:
> > > 
> > > > migrate_vmas() should check "vma" not "vma->vm_next" for for-loop condition.
> > > 
> > > The loop condition is checked before vma = vma->vm_next. So the last
> > > iteration of the loop will now be run with vma = NULL?
> > 
> > No, the condition is always checked before the body is executed.  The
> > assignment to vma->vm_next happens at the end of every body.
> > 
> So, I think in current code the loop body is not executed
> about the last vma in the list.
> 

Yep.

Is this serious enough to bother fixing in 2.6.29?
