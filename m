Return-Path: <linux-kernel-owner+w=401wt.eu-S1753590AbZLMXii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590AbZLMXii (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 18:38:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752335AbZLMXih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 18:38:37 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:46851 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbZLMXig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:38:36 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: arjan@infradead.org, mingo@redhat.com, hpa@zytor.com,
       Brice.Goglin@inria.fr, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tglx@linutronix.de,
       kosaki.motohiro@jp.fujitsu.com
Subject: Re: [tip:x86/urgent] mm: Adjust do_pages_stat() so gcc can see copy_from_user() is safe
Cc: kosaki.motohiro@jp.fujitsu.com, linux-tip-commits@vger.kernel.org,
       linux-kernel@vger.kernel.org, Brice.Goglin@inria.fr, hpa@zytor.com,
       mingo@redhat.com, arjan@infradead.org, akpm@linux-foundation.org,
       tglx@linutronix.de
In-Reply-To: <tip-b925585039cf39275c2e0e57512e5df27fa73aad@git.kernel.org>
References: <20090926205406.30d55b08@infradead.org> <tip-b925585039cf39275c2e0e57512e5df27fa73aad@git.kernel.org>
Message-Id: <20091214082228.BB96.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 14 Dec 2009 08:38:31 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Commit-ID:  b925585039cf39275c2e0e57512e5df27fa73aad
> Gitweb:     http://git.kernel.org/tip/b925585039cf39275c2e0e57512e5df27fa73aad
> Author:     H. Peter Anvin <hpa@zytor.com>
> AuthorDate: Tue, 8 Dec 2009 14:01:32 -0800
> Committer:  H. Peter Anvin <hpa@zytor.com>
> CommitDate: Fri, 11 Dec 2009 15:27:47 -0800
> 
> mm: Adjust do_pages_stat() so gcc can see copy_from_user() is safe
> 
> Slightly adjust the logic for determining the size of the
> copy_form_user() in do_pages_stat(); with this change, gcc can see
> that the copying is safe.
> 
> Without this, we get a build error for i386 allyesconfig:
> 
> /home/hpa/kernel/linux-2.6-tip.urgent/arch/x86/include/asm/uaccess_32.h:213:
> error: call to ‘copy_from_user_overflow’ declared with attribute
> error: copy_from_user() buffer size is not provably correct
> 
> Unlike an earlier patch from Arjan, this doesn't introduce new
> variables; merely reshuffles the compare so that gcc can see that an
> overflow cannot happen.
> 
> Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> Cc: Brice Goglin <Brice.Goglin@inria.fr>
> Cc: Arjan van de Ven <arjan@infradead.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> LKML-Reference: <20090926205406.30d55b08@infradead.org>
> ---
>  mm/migrate.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 7dbcb22..0bc640f 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -1044,7 +1044,7 @@ static int do_pages_stat(struct mm_struct *mm, unsigned long nr_pages,
>  	int err;
>  
>  	for (i = 0; i < nr_pages; i += chunk_nr) {
> -		if (chunk_nr + i > nr_pages)
> +		if (chunk_nr > nr_pages - i)
>  			chunk_nr = nr_pages - i;

Ah, good. Thank you.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>





