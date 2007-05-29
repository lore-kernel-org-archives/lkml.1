Return-Path: <linux-kernel-owner+w=401wt.eu-S1764192AbXE2H3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764192AbXE2H3f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 03:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761036AbXE2H30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 03:29:26 -0400
Received: from heisenberg.zen.co.uk ([212.23.3.141]:49481 "EHLO
	heisenberg.zen.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761064AbXE2H3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 03:29:25 -0400
Message-ID: <465BD64A.3040302@gmail.com>
Date: Tue, 29 May 2007 08:29:14 +0100
From: Matt Keenan <tank.en.mate@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: young dave <hidave.darkstar@gmail.com>
CC: Jeff Garzik <jeff@garzik.org>, "J. Bruce Fields" <bfields@fieldses.org>,
       Andrew Morton <akpm@linux-foundation.org>, neilb@suse.de,
       nfs@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [NFS] [PATCH] NFSD: fix uninitialized variable
References: <20070527103442.GA10594@havoc.gtf.org>	 <20070529030050.GB20631@fieldses.org> <465B9BB9.7060300@garzik.org> <a8e1da0705282131w72fbed65g8cb28589202298c1@mail.gmail.com>
In-Reply-To: <a8e1da0705282131w72fbed65g8cb28589202298c1@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-Heisenberg-IP: [82.69.27.224]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

young dave wrote:
> Hi,
>
>> Given what you said above, I don't see gcc, on its best day, will ever
>> know enough to validate that that variable is indeed always initialized.
>>   So I would vote for silencing it on those grounds.
>
> I agree too. How about this one:
>
> diff -dur linux/fs/nfsd/nfs4acl.c linux.new/fs/nfsd/nfs4acl.c
> --- linux/fs/nfsd/nfs4acl.c     2007-05-29 12:28:29.000000000 +0000
> +++ linux.new/fs/nfsd/nfs4acl.c 2007-05-29 12:30:45.000000000 +0000
> @@ -183,8 +183,6 @@
> summarize_posix_acl(struct posix_acl *acl, struct posix_acl_summary *pas)
> {
>        struct posix_acl_entry *pa, *pe;
> -       pas->users = 0;
> -       pas->groups = 0;
>        pas->mask = 07;
>
>        pe = acl->a_entries + acl->a_count;
> @@ -229,6 +227,7 @@
>        int eflag = ((flags & NFS4_ACL_TYPE_DEFAULT) ?
>                NFS4_INHERITANCE_FLAGS | NFS4_ACE_INHERIT_ONLY_ACE : 0);
>
> +       memset(pas, 0, sizeof(struct posix_acl_summary);
>        BUG_ON(pacl->a_count < 3);
>        summarize_posix_acl(pacl, &pas);
>
                                                                          
^^^^^

apart from the fact that this patch won't compile let alone run...


Matt

