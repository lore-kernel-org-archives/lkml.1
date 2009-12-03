Return-Path: <linux-kernel-owner+w=401wt.eu-S1756320AbZLCPV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756320AbZLCPV3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 10:21:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756191AbZLCPV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 10:21:29 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:54084 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756159AbZLCPV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 10:21:28 -0500
To: ebiederm@xmission.com (Eric W. Biederman)
CC: miklos@szeredi.hu, jlayton@redhat.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, jamie@shareable.org, pavel@ucw.cz,
       viro@ZenIV.linux.org.uk, duaneg@dghda.com
In-reply-to: <m18wdknudi.fsf@fess.ebiederm.org>
Subject: Re: [PATCH 2/2] vfs: force reval on dentry of bind mounted files on FS_REVAL_DOT filesystems
References: <1259783983-26884-1-git-send-email-jlayton@redhat.com>
	<1259783983-26884-3-git-send-email-jlayton@redhat.com>
	<E1NG9OV-0002g5-3D@pomaz-ex.szeredi.hu>
	<m1tyw8nwgk.fsf@fess.ebiederm.org>
	<E1NG9iu-0002jR-1r@pomaz-ex.szeredi.hu> <m18wdknudi.fsf@fess.ebiederm.org>
Message-Id: <E1NGDUe-0003BX-Bf@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 03 Dec 2009 16:21:20 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Dec 2009, Eric W. Biederman wrote:
> Ah.  I thought you were thinking about the mandatory have_submounts()
> check in dentry->d_op->d_revalidate().
> 
> I expect the generic d_invalidate will simply hit the:
> 	spin_lock(&dcache_lock);
> 	if (d_unhashed(dentry)) {
> 		spin_unlock(&dcache_lock);
> 		return 0;
> 	}
> 
> After the distributed filesystem has called d_drop in
> dentry->d_op->d_revalidate (when appropriate.

Ah, right, NFS's d_revalidate does do d_drop().  Okay, I have no
problem with the patch, as long as path lookup performance doesn't
show a regression.

Thanks,
Miklos
