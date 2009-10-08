Return-Path: <linux-kernel-owner+w=401wt.eu-S1756259AbZJHJJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259AbZJHJJP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 05:09:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756172AbZJHJJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 05:09:14 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:15934 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755956AbZJHJJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 05:09:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=e8/Qdw95lRLR4jcRnstgu0iJ4KDgRXFs1mND7VC4FiGKYzhRebz30eT3V2wyDyO3+r
         AWLzrNPZirF5qFcGg1WwPhc+1wEfhBf1CfEIr7V8RIDnGkFjdblpMtCpEg94ZHOI0v9S
         kB/pULQJUNc6XJQbn3eDzdoI32ja6DaJUh9MM=
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       linux-api@vger.kernel.org
Subject: Re: [PATCH v3][RFC] add MAP_UNLOCKED mmap flag
References: <20091006190316.GB19692@redhat.com>
Date: Thu, 08 Oct 2009 17:10:35 +0800
In-Reply-To: <20091006190316.GB19692@redhat.com> (Gleb Natapov's message of
	"Tue, 6 Oct 2009 21:03:16 +0200")
Message-ID: <874oqap7xw.fsf@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gleb Natapov <gleb@redhat.com> writes:

> If application does mlockall(MCL_FUTURE) it is no longer possible to
> mmap file bigger than main memory or allocate big area of anonymous
> memory. Sometimes it is desirable to lock everything related to program
> execution into memory, but still be able to mmap big file or allocate
> huge amount of memory and allow OS to swap them on demand. MAP_UNLOCKED
> allows to do that.
>
> Signed-off-by: Gleb Natapov <gleb@redhat.com>

<snip>

> diff --git a/mm/mmap.c b/mm/mmap.c
> index 73f5e4b..ecc4471 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -985,6 +985,9 @@ unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
>  		if (!can_do_mlock())
>  			return -EPERM;
>  
> +        if (flags & MAP_UNLOCKED)
> +                vm_flags &= ~VM_LOCKED;
> +
>  	/* mlock MCL_FUTURE? */
>  	if (vm_flags & VM_LOCKED) {
>  		unsigned long locked, lock_limit;

So, if I read it correctly, it is perfectly legal to set
both MAP_LOCKED and MAP_UNLOCKED at the same time? While
the behavior is still same as only setting MAP_UNLOCKED.

Is this what we expect?

Regards.
