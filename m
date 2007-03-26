Return-Path: <linux-kernel-owner+w=401wt.eu-S933006AbXCZABB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933006AbXCZABB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 20:01:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933045AbXCZABA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 20:01:00 -0400
Received: from smtp.osdl.org ([65.172.181.24]:36478 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933006AbXCZAA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 20:00:59 -0400
Date: Sun, 25 Mar 2007 16:00:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 2/3] only allow nonlinear vmas for ram backed
 filesystems
Message-Id: <20070325160050.fe7cb284.akpm@linux-foundation.org>
In-Reply-To: <E1HVEQJ-0006gF-00@dorka.pomaz.szeredi.hu>
References: <E1HVEOB-0006fX-00@dorka.pomaz.szeredi.hu>
	<E1HVEQJ-0006gF-00@dorka.pomaz.szeredi.hu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Mar 2007 23:09:19 +0100 Miklos Szeredi <miklos@szeredi.hu> wrote:

> Dirty page accounting/limiting doesn't work for nonlinear mappings,

Doesn't it?  iirc the problem is that we don't correctly re-clean the ptes
while starting writeout.  And the dirty-page accounting is in fact correct
(it'd darn well better be).

> so
> for non-ram backed filesystems emulate with linear mappings.  This
> retains ABI compatibility with previous kernels at minimal code cost.
> 
> All known users of nonlinear mappings actually use tmpfs, so this
> shouldn't have any negative effect.

Unless someone is using remap_file_pages() against an ext3 file, in which
case their application stops working?

That would be a problem.  These guys:
http://www.technovelty.org/code/linux/fremap.html, for example, will be in
for a little surprise.

