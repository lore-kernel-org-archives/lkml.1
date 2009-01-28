Return-Path: <linux-kernel-owner+w=401wt.eu-S1755189AbZA1Qzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189AbZA1Qzq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 11:55:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751850AbZA1Qzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 11:55:37 -0500
Received: from cmpxchg.org ([85.214.51.133]:49925 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508AbZA1Qzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 11:55:36 -0500
Date: Wed, 28 Jan 2009 17:55:12 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH] migration: migrate_vmas should check "vma"
Message-ID: <20090128165512.GA22588@cmpxchg.org>
References: <20090128162619.2205befd.nishimura@mxp.nes.nec.co.jp> <alpine.DEB.1.10.0901281140540.7765@qirst.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0901281140540.7765@qirst.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2009 at 11:42:36AM -0500, Christoph Lameter wrote:
> On Wed, 28 Jan 2009, Daisuke Nishimura wrote:
> 
> > migrate_vmas() should check "vma" not "vma->vm_next" for for-loop condition.
> 
> The loop condition is checked before vma = vma->vm_next. So the last
> iteration of the loop will now be run with vma = NULL?

No, the condition is always checked before the body is executed.  The
assignment to vma->vm_next happens at the end of every body.

Try this:

		int a = 2;

		for (puts("init"); puts("cond"), a; puts("next"))
			a--;

	Hannes
