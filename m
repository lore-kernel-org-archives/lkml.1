Return-Path: <linux-kernel-owner+w=401wt.eu-S1755107AbZFEJV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107AbZFEJV1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 05:21:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbZFEJVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 05:21:19 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:38882 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180AbZFEJVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 05:21:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=xrPMjBdo8HnIgRZKFaaovLSung/EGgrleqV9qEdyPweHpT2bMEbu+mAGnrS7wAjY0Y
         vvu1RGLB0AFTDadfJ0L0Jab0UnY9lW2qBIBI7XwlcLHI8m36RHembKC//K/0tkEZSQaj
         HVyx3JSwQenc2Xg1rvjb7xM9TavZizKZ1gwtA=
Date: Fri, 5 Jun 2009 17:23:32 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] shm: fix unused warnings on nommu
Message-ID: <20090605092332.GB8354@cr0.nay.redhat.com>
References: <1244174632-19361-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1244174632-19361-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 05, 2009 at 12:03:52AM -0400, Mike Frysinger wrote:
>The massive nommu update (8feae131) resulted in these warnings:
>ipc/shm.c: In function ‘sys_shmdt’:
>ipc/shm.c:974: warning: unused variable ‘size’
>ipc/shm.c:972: warning: unused variable ‘next’
>
>Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>


>---
> ipc/shm.c |    7 +++++--
> 1 files changed, 5 insertions(+), 2 deletions(-)
>
>diff --git a/ipc/shm.c b/ipc/shm.c
>index faa46da..4259716 100644
>--- a/ipc/shm.c
>+++ b/ipc/shm.c
>@@ -969,10 +969,13 @@ SYSCALL_DEFINE3(shmat, int, shmid, char __user *, shmaddr, int, shmflg)
> SYSCALL_DEFINE1(shmdt, char __user *, shmaddr)
> {
> 	struct mm_struct *mm = current->mm;
>-	struct vm_area_struct *vma, *next;
>+	struct vm_area_struct *vma;
> 	unsigned long addr = (unsigned long)shmaddr;
>-	loff_t size = 0;
> 	int retval = -EINVAL;
>+#ifdef CONFIG_MMU
>+	loff_t size = 0;
>+	struct vm_area_struct *next;
>+#endif
> 
> 	if (addr & ~PAGE_MASK)
> 		return retval;
>-- 
>1.6.3.1
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
