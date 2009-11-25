Return-Path: <linux-kernel-owner+w=401wt.eu-S1758711AbZKYLd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758711AbZKYLd0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 06:33:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758681AbZKYLd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 06:33:26 -0500
Received: from ozlabs.org ([203.10.76.45]:40696 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758676AbZKYLdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 06:33:25 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 3/6] cpumask: truncate task_struct.cpus_allowed for CONFIG_CPUMASK_OFFSTACK
Date: Wed, 25 Nov 2009 22:03:28 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200911191930.59400.rusty@rustcorp.com.au> <200911240918.40418.rusty@rustcorp.com.au> <20091123231440.GA13221@elte.hu>
In-Reply-To: <20091123231440.GA13221@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911252203.28343.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Nov 2009 09:44:40 am Ingo Molnar wrote:
> There's also the problem of cache footprint - we really want to freedom 
> to place the masks (which are not off-stack in the regular case) 
> anywhere in task struct - and task-struct is huge, so cache placement 
> matters.

My initial patch changed it to always be a const cpumask *, with it
pointing to the standard all or single-cpu masks in the normal cases: it
only got its own allocated if we changed it to something unusual.

It was more invasive though, and really needs to be thought about separately.
I'd want to measure how often it is accessed, for example.

> Is the ptr deref really a big problem for off-stack?

I don't think so; slightly suboptimal codegen but it'll still just point to
the end of the struct.

> Changing all users isnt a problem as long as it still looks like a clean 
> data structure with clean usage.

We're still supposed to use a wrapper to avoid a flag day.  It's gratuitous
if we're going to do this, but that's modern kernel life AFAICT.

> Those end-of-struct tricks we play with cpumasks make me really a bit uneasy.

Fair enough.

I don't know when I'll get more cycles on this.  A few more months I expect.

Rusty.
