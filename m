Return-Path: <linux-kernel-owner+w=401wt.eu-S1761134AbYBYWvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761134AbYBYWvv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 17:51:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758184AbYBYWvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 17:51:42 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:36496 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757177AbYBYWvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 17:51:41 -0500
Date: Mon, 25 Feb 2008 14:49:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pekka Paalanen <pq@iki.fi>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>, Pavel Roskin <proski@gnu.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: [RFC] mmiotrace full patch, preview 1
Message-Id: <20080225144922.ae716e7d.akpm@linux-foundation.org>
In-Reply-To: <20080224190323.77adf683@daedalus.pq.iki.fi>
References: <20080224190323.77adf683@daedalus.pq.iki.fi>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Feb 2008 19:03:23 +0200 Pekka Paalanen <pq@iki.fi> wrote:

>  arch/x86/Kconfig.debug      |   33 +++
>  arch/x86/mm/Makefile        |    5 +
>  arch/x86/mm/fault.c         |   13 +
>  arch/x86/mm/kmmio.c         |  541 +++++++++++++++++++++++++++++++++++++++++++
>  arch/x86/mm/mmio-mod.c      |  541 +++++++++++++++++++++++++++++++++++++++++++
>  arch/x86/mm/pageattr.c      |    1 +
>  arch/x86/mm/pf_in.c         |  489 ++++++++++++++++++++++++++++++++++++++
>  arch/x86/mm/pf_in.h         |   39 +++
>  arch/x86/mm/testmmiotrace.c |   76 ++++++
>  include/linux/mmiotrace.h   |  104 +++++++++

Please feed the diff through scritps/checkpatch.pl and consider addressing
the things which it finds.

> +static DECLARE_MUTEX(kmmio_init_mutex);

That's not a mutex.

> +	down(&kmmio_init_mutex);

It's a semaphore.  Please do convert it to a mutex.

Andy, I'd say that addition of new semaphores is worth a warning - they're
rarely legitimate.

