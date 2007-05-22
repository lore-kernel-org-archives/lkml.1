Return-Path: <linux-kernel-owner+w=401wt.eu-S1759006AbXEVUKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759006AbXEVUKd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 16:10:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755936AbXEVUK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 16:10:26 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33302 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755346AbXEVUKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 16:10:25 -0400
Date: Tue, 22 May 2007 13:08:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Maxim Uvarov <muvarov@ru.mvista.com>
Cc: LKML <linux-kernel@vger.kernel.org>, <linuxppc-dev@ozlabs.org>
Subject: Re: [PATCH] Performance Stats: Kernel patch
Message-Id: <20070522130824.a78976aa.akpm@linux-foundation.org>
In-Reply-To: <20070522171950.23728.95735.stgit@localhost.localdomain>
References: <20070522171950.23728.95735.stgit@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2007 17:19:52 +0000
Maxim Uvarov <muvarov@ru.mvista.com> wrote:

> Sorry for bothering you. I know you are very busy but could 
> you please tell me what is situation of this patch?

I'd like to add the context-switch accounting to the taskstats payload.

As we'd then need to uprev the taskstats payload and version it makes sense
to have a look around, see if there's anything else which should be in
there but got missed.



I don't think we can accept the number-of-syscalls accounting feature.  It
adds a memory increment into the kernel's number-one hotpath.  Something
which people like to obsessively microbenchmark.

And as I said earlier, a 32-bit counter can be overflowed in mere seconds,
so that needs to become 64-bit, in which case we add a memory increment and
a test-n-branch to that hottest path.


There _is_ some cumulative overhead here, and I don't see how the value of
the syscall counter can justify it.
