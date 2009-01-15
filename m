Return-Path: <linux-kernel-owner+w=401wt.eu-S1759121AbZAOF6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759121AbZAOF6u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 00:58:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755200AbZAOF6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 00:58:41 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52481 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755131AbZAOF6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 00:58:41 -0500
Date: Wed, 14 Jan 2009 21:58:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org, dst@ioremap.net,
       Arjan van de Ven <arjan@infradead.org>,
       David Howells <dhowells@redhat.com>
Subject: Re: [4/7] dst: thread pool.
Message-Id: <20090114215810.674569fc.akpm@linux-foundation.org>
In-Reply-To: <1231887933-17843-5-git-send-email-zbr@ioremap.net>
References: <1231887933-17843-1-git-send-email-zbr@ioremap.net>
	<1231887933-17843-2-git-send-email-zbr@ioremap.net>
	<1231887933-17843-3-git-send-email-zbr@ioremap.net>
	<1231887933-17843-4-git-send-email-zbr@ioremap.net>
	<1231887933-17843-5-git-send-email-zbr@ioremap.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2009 02:05:30 +0300 Evgeniy Polyakov <zbr@ioremap.net> wrote:

> Kernel currently does not allow to queue work into some entity which
> will perform it in the process context and have simple way to extend
> number of worker and work with them not as separate objects, but with
> pool as a whole. So thread pool model was implemented in the DST.
> 
> Thread pool abstraction allows to schedule a work to be performed
> on behalf of kernel thread. One does not operate with threads itself,
> instead user provides setup and cleanup callbacks for thread pool itself,
> and action and cleanup callbacks for each submitted work.
> 
> Each worker has private data initialized at creation time and data,
> provided by user at scheduling time.
> 
> When action is being performed, thread can not be used by other users,
> instead they will sleep until there is free thread to pick their work.
> 
> Thread pool is used for crypto processing of incoming and outgoing IO
> requests to reduce the overall overhead.

This is at least our fourth thread pool implementation, not counting
kernel/workqueue.c:

1: pdflush

2: David Howells' "slow work" infrastructure

3: Arjan van de Ven's kernel/async.c

4: Your "dst thread pool"


Guys, please.  Let's get our act together here.
