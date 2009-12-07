Return-Path: <linux-kernel-owner+w=401wt.eu-S935537AbZLGUhJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935537AbZLGUhJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 15:37:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935153AbZLGUhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 15:37:07 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38328 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932195AbZLGUhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 15:37:05 -0500
Date: Mon, 7 Dec 2009 12:36:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Veaceslav Falico <vfalico@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>, Al Viro <viro@zeniv.linux.org.uk>,
       Miloslav Trmac <mitr@redhat.com>, James Morris <jmorris@namei.org>,
       Alan Cox <alan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Renaud Lottiaux <renaud.lottiaux@kerlabs.com>,
       Louis Rilling <louis.rilling@kerlabs.com>,
       David Howells <dhowells@redhat.com>,
       Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: [PATCH v2 1/4] copy_signal cleanup: use zalloc and remove
 initializations
Message-Id: <20091207123615.fc841a83.akpm@linux-foundation.org>
In-Reply-To: <20091204142814.GH10052@darkmag.usersys.redhat.com>
References: <20091201221036.GA10052@darkmag.usersys.redhat.com>
	<20091202135759.GA791@redhat.com>
	<20091204142814.GH10052@darkmag.usersys.redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Dec 2009 15:28:14 +0100
Veaceslav Falico <vfalico@redhat.com> wrote:

> Use kmem_cache_zalloc() on signal creation and remove unneeded initialization
> lines in copy_signal().
> 
> Signed-off-by: Veaceslav Falico <vfalico@redhat.com>
> ---
> 
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 166b8c4..160477d 100644
> @@ -855,7 +844,7 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)

For some reason this patch is missing its headers and doesn't apply.

I fixed that up and it still doesn't apply, because there are pending
changes in this area in -mm.

Normally I'd fix that up, but this one is looking a bit non-trivial, so
I'm afraid I'm going to ask you to redo the patches against
http://userweb.kernel.org/~akpm/mmotm/

Alternatively, we could just hold them off until 2.6.34.  Wait until
2.6.33-rc1 is released then resend the patch series based on
2.6.33-rc1.  Perhaps this is a better approach, as we are now in the
2.6.33 merge window and it's a bit late to be introducing new material.

Either way, please do ensure that the next patch series retains all the
acked-by:'s which people have sent. 

Thanks. 
