Return-Path: <linux-kernel-owner+w=401wt.eu-S1753789AbZIQFzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789AbZIQFzU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 01:55:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753234AbZIQFzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 01:55:18 -0400
Received: from mail-qy0-f200.google.com ([209.85.221.200]:56009 "EHLO
	mail-qy0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870AbZIQFzR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 01:55:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Pk+Z5jdfx53q9xDm00sknvHHedU/zV9GPlSPafnpHqLZJLDjClLxzG9ALRokfk2gqS
         oqcMjq6wL42XpnfZS2bF96flaZkAmdfh0XPtLx10LxT/GFeT1gyvnQcy6eSXja7x0tGI
         Zwqs2At1bkkdylNOuaANd0DOIDfPZY6vXBq+I=
MIME-Version: 1.0
In-Reply-To: <20090917114256.1f3971d8.kamezawa.hiroyu@jp.fujitsu.com>
References: <2375c9f90909160235m1f052df0qb001f8243ed9291e@mail.gmail.com>
	 <1bc66b163326564dafb5a7dd8959fd56.squirrel@webmail-b.css.fujitsu.com>
	 <20090917114138.e14a1183.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090917114256.1f3971d8.kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 17 Sep 2009 13:55:20 +0800
Message-ID: <2375c9f90909162255i3dca34e8w51e496294bb38916@mail.gmail.com>
Subject: Re: [PATCH 1/3][mmotm] kcore: more fixes for init
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 10:42 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>
> proc_kcore_init() doesn't check NULL case.
> fix it and remove unnecessary comments.
>
> Cc: WANG Cong <xiyou.wangcong@gmail.com>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks.

> ---
>  fs/proc/kcore.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> Index: mmotm-2.6.31-Sep14/fs/proc/kcore.c
> ===================================================================
> --- mmotm-2.6.31-Sep14.orig/fs/proc/kcore.c
> +++ mmotm-2.6.31-Sep14/fs/proc/kcore.c
> @@ -606,6 +606,10 @@ static int __init proc_kcore_init(void)
>  {
>        proc_root_kcore = proc_create("kcore", S_IRUSR, NULL,
>                                      &proc_kcore_operations);
> +       if (!proc_root_kcore) {
> +               printk(KERN_ERR "couldn't create /proc/kcore\n");
> +               return 0; /* Always returns 0. */
> +       }
>        /* Store text area if it's special */
>        proc_kcore_text_init();
>        /* Store vmalloc area */
> @@ -615,7 +619,6 @@ static int __init proc_kcore_init(void)
>        /* Store direct-map area from physical memory map */
>        kcore_update_ram();
>        hotplug_memory_notifier(kcore_callback, 0);
> -       /* Other special area, area-for-module etc is arch specific. */
>
>        return 0;
>  }
>
>
