Return-Path: <linux-kernel-owner+w=401wt.eu-S1754109AbYE3E7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbYE3E7m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 00:59:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752844AbYE3E64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 00:58:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55184 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752186AbYE3E6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 00:58:53 -0400
Date: Thu, 29 May 2008 21:58:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>, Eric Dumazet <dada1@cosmosbay.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>
Subject: Re: [patch 00/41] cpu alloc / cpu ops v3: Optimize per cpu access
Message-Id: <20080529215827.b659d032.akpm@linux-foundation.org>
In-Reply-To: <20080530035620.587204923@sgi.com>
References: <20080530035620.587204923@sgi.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008 20:56:20 -0700 Christoph Lameter <clameter@sgi.com> wrote:

> In various places the kernel maintains arrays of pointers indexed by
> processor numbers. These are used to locate objects that need to be used
> when executing on a specirfic processor. Both the slab allocator
> and the page allocator use these arrays and there the arrays are used in
> performance critical code. The allocpercpu functionality is a simple
> allocator to provide these arrays.

All seems reasonable to me.  The obvious question is "how do we size
the arena".  We either waste memory or, much worse, run out.

And running out is a real possibility, I think.  Most people will only
mount a handful of XFS filesystems.  But some customer will come along
who wants to mount 5,000, and distributors will need to cater for that,
but how can they?

I wonder if we can arrange for the default to be overridden via a
kernel boot option?


Another obvious question is "how much of a problem will we have with
internal fragmentation"?  This might be a drop-dead showstopper.

