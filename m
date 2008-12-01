Return-Path: <linux-kernel-owner+w=401wt.eu-S1756765AbYLAAuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765AbYLAAuY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 19:50:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752160AbYLAAuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 19:50:09 -0500
Received: from ozlabs.org ([203.10.76.45]:48115 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033AbYLAAuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 19:50:08 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18739.13487.859058.857227@cargo.ozlabs.ibm.com>
Date: Mon, 1 Dec 2008 11:49:51 +1100
From: Paul Mackerras <paulus@samba.org>
To: eranian@gmail.com
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, x86@kernel.org, andi@firstfloor.org,
       sfr@canb.auug.org.au, "Roland McGrath" <roland@redhat.com>,
       "Oleg Nesterov" <oleg@redhat.com>
Subject: Re: [patch 20/24] perfmon: system calls interface
In-Reply-To: <7c86c4470811270622s540a17d8r73462dfa93d1bc6d@mail.gmail.com>
References: <492d0c0b.170e660a.15ba.ffffdabf@mx.google.com>
	<20081126140027.GC6562@elte.hu>
	<7c86c4470811270622s540a17d8r73462dfa93d1bc6d@mail.gmail.com>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

stephane eranian writes:

> Perfmon requires ptrace ONLY to stop the thread you want to operate
> on. For instance, to read the counters in a thread via pfm_read(), you
> need to have that thread stopped, so perfmon can extract the machine
> state safely.

What would happen if the thread wasn't stopped?  Is it just that the
numbers would be inaccurate, or is there some kind of security
exposure?

If it's just that the numbers would be inaccurate, then I don't think
the kernel needs to enforce it.  The monitoring program *should*
ensure that the thread is stopped or blocked, one way or another, but
it could do that simply by sending a SIGSTOP to the thread.  I don't
see that it would necessarily have to use ptrace.

Paul.
