Return-Path: <linux-kernel-owner+w=401wt.eu-S1764569AbXE2Icw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764569AbXE2Icw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 04:32:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754729AbXE2Ico
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 04:32:44 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:29075 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894AbXE2Icn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 04:32:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MvRKvfw9loKYl40lMPGvqWMbxOAWWA2RfzeE6PtTjbBTSuKVlBihycKChAy4WG5sQQx1TLdRjrsEGHxDEEpE1HlUEZBLs/byv3CYM2Aw3T1y6ESxwOKyFOoI7oZ38chk3MwXV3IBTLXT+F7KkDVfiH5d+S/EQDJnaFrv3AjL3+I=
Message-ID: <a8e1da0705290132l328f1e4t10d2c0495d46f5fe@mail.gmail.com>
Date: Tue, 29 May 2007 08:32:42 +0000
From: "young dave" <hidave.darkstar@gmail.com>
To: "Matt Keenan" <tank.en.mate@gmail.com>
Subject: Re: [NFS] [PATCH] NFSD: fix uninitialized variable
Cc: "Jeff Garzik" <jeff@garzik.org>, "J. Bruce Fields" <bfields@fieldses.org>,
       "Andrew Morton" <akpm@linux-foundation.org>, neilb@suse.de,
       nfs@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <465BD64A.3040302@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070527103442.GA10594@havoc.gtf.org>
	 <20070529030050.GB20631@fieldses.org> <465B9BB9.7060300@garzik.org>
	 <a8e1da0705282131w72fbed65g8cb28589202298c1@mail.gmail.com>
	 <465BD64A.3040302@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, matt
embarrassed :)
below resend it.

diff -dur linux/fs/nfsd/nfs4acl.c linux.new/fs/nfsd/nfs4acl.c
--- linux/fs/nfsd/nfs4acl.c     2007-05-29 12:28:29.000000000 +0000
+++ linux.new/fs/nfsd/nfs4acl.c 2007-05-29 16:32:26.000000000 +0000
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

+       memset(pas, 0, sizeof(struct posix_acl_summary));
        BUG_ON(pacl->a_count < 3);
        summarize_posix_acl(pacl, &pas);
