Return-Path: <linux-kernel-owner+w=401wt.eu-S1756864AbYLaWyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864AbYLaWyj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 17:54:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752326AbYLaWyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 17:54:31 -0500
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:39291 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbYLaWyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 17:54:31 -0500
Date: Wed, 31 Dec 2008 16:53:28 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: miaox@cn.fujitsu.com, menage@google.com, penberg@cs.helsinki.fi,
       mpm@selenic.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] cpuset,mm: fix allocating page cache/slab object on the
 unallowed node when memory spread is set
In-Reply-To: <20081230142805.3c6f78e3.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0812311648250.21443@quilx.com>
References: <49547B93.5090905@cn.fujitsu.com> <20081230142805.3c6f78e3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Dec 2008, Andrew Morton wrote:

> d) How does slub handle this problem?

SLUB understands memory policies to apply to the pages from which
objects are acquired. MPOL_INTERLEAVE applies to the pages acquired
by the allocator not to individual objects acquired by the user of the
allocator from these pages.

With that point of view most of the memory policy handling can be pushed
into the page allocator.


