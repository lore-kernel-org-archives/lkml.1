Return-Path: <linux-kernel-owner+w=401wt.eu-S1760081AbZEKVoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760081AbZEKVoa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 17:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756510AbZEKVoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 17:44:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55731 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759395AbZEKVoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 17:44:18 -0400
Date: Mon, 11 May 2009 14:39:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: gregkh@suse.de, npiggin@suse.de, mel@csn.ul.ie, a.p.ziljstra@chello.nl,
       cl@linux-foundation.org, dave@linux.vnet.ibm.com, san@android.com,
       arve@android.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 10/11 -mmotm] oom: avoid oom kill if no interruptible
 tasks
Message-Id: <20090511143906.1cde5f6e.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.0905101502470.18804@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0905101458430.18804@chino.kir.corp.google.com>
	<alpine.DEB.2.00.0905101502470.18804@chino.kir.corp.google.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 May 2009 15:07:25 -0700 (PDT)
David Rientjes <rientjes@google.com> wrote:

> If there are no interruptible system tasks other than kthreads,

It's unclear what the term "system task" means.  Just "task"?

> no task
> should be chosen for oom kill since they won't respond to the SIGKILL
> anyway.  Instead, we choose to simply fail page allocations if reclaim
> cannot free memory and hope for the best.

But plain old user processes enter and leave D state all the time.  The
task may well just be sitting there waiting for a disk read to
complete.  It will respond to the SIGKILL shortly after the IO
completes, so an appropriate action here is to just wait for that to
happen.

