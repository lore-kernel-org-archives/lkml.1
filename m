Return-Path: <linux-kernel-owner+w=401wt.eu-S1763894AbXISRln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763894AbXISRln (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 13:41:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763546AbXISRjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 13:39:48 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:45237 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763535AbXISRjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 13:39:46 -0400
Date: Wed, 19 Sep 2007 19:39:45 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Dave Hansen <haveblue@us.ibm.com>
cc: akpm@osdl.org, linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 03/24] create cleanup helper svc_msnfs()
In-Reply-To: <20070917182721.8EF73A09@kernel>
Message-ID: <Pine.LNX.4.64.0709191939080.10201@fbirervta.pbzchgretzou.qr>
References: <20070917182718.70494C9B@kernel> <20070917182721.8EF73A09@kernel>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 17 2007 11:27, Dave Hansen wrote:
>
> lxc-dave/fs/nfsd/vfs.c |   15 +++++++++++----
> 1 file changed, 11 insertions(+), 4 deletions(-)
>
>diff -puN fs/nfsd/vfs.c~create-svc_msnfs-helper fs/nfsd/vfs.c
>--- lxc/fs/nfsd/vfs.c~create-svc_msnfs-helper	2007-09-17 09:43:56.000000000 -0700
>+++ lxc-dave/fs/nfsd/vfs.c	2007-09-17 09:43:56.000000000 -0700
>@@ -865,6 +865,15 @@ static int nfsd_direct_splice_actor(stru
> 	return __splice_from_pipe(pipe, sd, nfsd_splice_actor);
> }
> 
>+static inline int svc_msnfs(struct svc_fh *ffhp)
>+{
>+#ifdef MSNFS
>+	return (ffhp->fh_export->ex_flags & NFSEXP_MSNFS);
>+#else
>+	return 0;
>+#endif
>+}

The name looks kinda confusing. msnfs? almost makes you think
what's got microsoft to do with it..

