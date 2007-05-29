Return-Path: <linux-kernel-owner+w=401wt.eu-S1762170AbXE2EbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762170AbXE2EbV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 00:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754369AbXE2EbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 00:31:14 -0400
Received: from wr-out-0506.google.com ([64.233.184.226]:63935 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbXE2EbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 00:31:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GFuZAKP3OHTIPBHb7d/59+bUk1fMT2gketocxS2SNMEQ6uBQMwfaeuymBdzKkRv4+SJrRKrXGlnqbRVN+y2Pv2vSkZ/TNVB2U+iTxjMNn4qz/jXu7RhzVX57qvGczuxMa7db3P6YW0zfP4E/nGWJQaaALKKZUfTdIPzL+iRziTY=
Message-ID: <a8e1da0705282131w72fbed65g8cb28589202298c1@mail.gmail.com>
Date: Tue, 29 May 2007 04:31:12 +0000
From: "young dave" <hidave.darkstar@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: [NFS] [PATCH] NFSD: fix uninitialized variable
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
       "Andrew Morton" <akpm@linux-foundation.org>, neilb@suse.de,
       nfs@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <465B9BB9.7060300@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070527103442.GA10594@havoc.gtf.org>
	 <20070529030050.GB20631@fieldses.org> <465B9BB9.7060300@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Given what you said above, I don't see gcc, on its best day, will ever
> know enough to validate that that variable is indeed always initialized.
>   So I would vote for silencing it on those grounds.

I agree too. How about this one:

diff -dur linux/fs/nfsd/nfs4acl.c linux.new/fs/nfsd/nfs4acl.c
--- linux/fs/nfsd/nfs4acl.c     2007-05-29 12:28:29.000000000 +0000
+++ linux.new/fs/nfsd/nfs4acl.c 2007-05-29 12:30:45.000000000 +0000
@@ -183,8 +183,6 @@
 summarize_posix_acl(struct posix_acl *acl, struct posix_acl_summary *pas)
 {
        struct posix_acl_entry *pa, *pe;
-       pas->users = 0;
-       pas->groups = 0;
        pas->mask = 07;

        pe = acl->a_entries + acl->a_count;
@@ -229,6 +227,7 @@
        int eflag = ((flags & NFS4_ACL_TYPE_DEFAULT) ?
                NFS4_INHERITANCE_FLAGS | NFS4_ACE_INHERIT_ONLY_ACE : 0);

+       memset(pas, 0, sizeof(struct posix_acl_summary);
        BUG_ON(pacl->a_count < 3);
        summarize_posix_acl(pacl, &pas);

Regards
dave
