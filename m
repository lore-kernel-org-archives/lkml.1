Return-Path: <linux-kernel-owner+w=401wt.eu-S1753493AbYGDXH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbYGDXH3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 19:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751056AbYGDXHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 19:07:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54392 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750721AbYGDXHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 19:07:18 -0400
Date: Fri, 4 Jul 2008 16:07:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: kernel-testers@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: 2.6.26-rc8-mm1: unable to mount nfs shares
Message-Id: <20080704160711.299f26a3.akpm@linux-foundation.org>
In-Reply-To: <200807050049.33287.m.kozlowski@tuxland.pl>
References: <20080703020236.adaa51fa.akpm@linux-foundation.org>
	<200807050049.33287.m.kozlowski@tuxland.pl>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Jul 2008 00:49:33 +0200 Mariusz Kozlowski <m.kozlowski@tuxland.pl> wrote:

> $ mount some/nfs/share
> mount.nfs: Input/output error
> 
> dmesg says: RPC: transport (0) not supported
> 
> but I guess it's known issue http://lkml.org/lkml/2008/7/1/438 ?
> 

OK, thanks, I put Trond's fix into hot-fixes/

--- a/fs/nfs/super.c~nfs-fix-the-mount-protocol-defaults-for-binary-mounts
+++ a/fs/nfs/super.c
@@ -1571,6 +1571,7 @@ static int nfs_validate_mount_data(void 
 
 		if (!(data->flags & NFS_MOUNT_TCP))
 			args->nfs_server.protocol = XPRT_TRANSPORT_UDP;
+		nfs_set_transport_defaults(args);
 		/* N.B. caller will free nfs_server.hostname in all cases */
 		args->nfs_server.hostname = kstrdup(data->hostname, GFP_KERNEL);
 		args->namlen		= data->namlen;
_

