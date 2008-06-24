Return-Path: <linux-kernel-owner+w=401wt.eu-S1760051AbYFXRjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760051AbYFXRjU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 13:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756156AbYFXRit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 13:38:49 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:26863 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252AbYFXRir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 13:38:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=S61iVGI4ypbhRSdIlRVUqu2aAjjw6DHh7OyqzxKJCP0oTVmgxuMlyFu8tfEzv/RLrO
         YD4UaK3OVyfYIBMuFLojWLfbfrwsAMDu1y/DhvGctJDsONpiKPFULMmCpC1K/nzIGOwh
         6R66r7v+/QBpv6vLdldGRUrw1bFvmC5sa9858=
Message-ID: <2f11576a0806241038s45a93ec0l54bd826973433c17@mail.gmail.com>
Date: Wed, 25 Jun 2008 02:38:47 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Lee Schermerhorn" <Lee.Schermerhorn@hp.com>
Subject: Re: [PATCH] fix2 to putback_lru_page()/unevictable page handling rework v3
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       "Rik van Riel" <riel@redhat.com>
In-Reply-To: <1214328572.6563.31.camel@lts-notebook>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080621185408.E832.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20080624114006.D81C.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <1214328572.6563.31.camel@lts-notebook>
X-Google-Sender-Auth: d3f89f41321bbd91
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
>
>  include/linux/mm.h |    7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>
> Index: linux-2.6.26-rc5-mm3/include/linux/mm.h
> ===================================================================
> --- linux-2.6.26-rc5-mm3.orig/include/linux/mm.h        2008-06-24 12:54:41.000000000 -0400
> +++ linux-2.6.26-rc5-mm3/include/linux/mm.h     2008-06-24 13:25:29.000000000 -0400
> @@ -706,13 +706,12 @@ static inline int page_mapped(struct pag
>  extern void show_free_areas(void);
>
>  #ifdef CONFIG_SHMEM
> -extern struct address_space *shmem_lock(struct file *file, int lock,
> -                                       struct user_struct *user);
> +extern int shmem_lock(struct file *file, int lock, struct user_struct *user);
>  #else
> -static inline struct address_space *shmem_lock(struct file *file, int lock,
> +static inline int shmem_lock(struct file *file, int lock,
>                                        struct user_struct *user)
>  {
> -       return NULL;
> +       return 0;
>  }
>  #endif
>  struct file *shmem_file_setup(char *name, loff_t size, unsigned long flags);

Sure.
I forgot "quilt add mm.h" operation ;-)

Thank you!

     Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
