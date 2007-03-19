Return-Path: <linux-kernel-owner+w=401wt.eu-S1753457AbXCSLbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbXCSLbY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 07:31:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753466AbXCSLbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 07:31:24 -0400
Received: from smtp.osdl.org ([65.172.181.24]:57233 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753457AbXCSLbX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 07:31:23 -0400
Date: Mon, 19 Mar 2007 03:31:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: ast@domdv.de, clameter@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab: deal with NULL pointers passed to kmem_cache_free
Message-Id: <20070319033108.b51bed63.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703191022310.8671@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0703191022310.8671@sbz-30.cs.Helsinki.FI>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2007 10:27:18 +0200 (EET) Pekka J Enberg <penberg@cs.helsinki.fi> wrote:

> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> This changes kmem_cache_free() to deal with NULL objects passed to it. The 
> current behavior is inconsistent with kfree() so there are callers 
> passing NULL to kmem_cache_free().

err, we don't want to do this, do we?  It adds overhead for something which
we've carefully taught all our programmers to not do.  The only known code
which will benefit from this is buggy.

> Andreas, can you please confirm this fixes the oops you reported on 
> linux-scsi?

s/fix/hide/
