Return-Path: <linux-kernel-owner+w=401wt.eu-S1423375AbXBJACQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423375AbXBJACQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 19:02:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423368AbXBJACQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 19:02:16 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:57280 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946760AbXBJACP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 19:02:15 -0500
X-Greylist: delayed 509 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Feb 2007 19:02:15 EST
Message-ID: <45CD069C.20606@cosmosbay.com>
Date: Sat, 10 Feb 2007 00:41:16 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: Dave Hansen <hansendc@us.ibm.com>
CC: linux-kernel@vger.kernel.org, akpm@osdl.org, hch@infradead.org
Subject: Re: [PATCH 02/22] r/o bind mounts: add vfsmount writer counts
References: <20070209225329.27619A62@localhost.localdomain> <20070209225330.42133693@localhost.localdomain>
In-Reply-To: <20070209225330.42133693@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Sat, 10 Feb 2007 00:41:25 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen a écrit :

> @@ -56,6 +57,7 @@ struct vfsmount {
>  	struct vfsmount *mnt_master;	/* slave is on master->mnt_slave_list */
>  	struct mnt_namespace *mnt_ns;	/* containing namespace */
>  	struct user_namespace *mnt_user_ns; /* namespace for uid interpretation */
> +	int mnt_writers;		/* nr files open for write */
>  	/*
>  	 * We put mnt_count & mnt_expiry_mark at the end of struct vfsmount
>  	 * to let these frequently modified fields in a separate cache line
> @@ -72,7 +74,26 @@ static inline struct vfsmount *mntget(st
>  		atomic_inc(&mnt->mnt_count);
>  	return mnt;

Dave, please read again this comment in struct vfsmount definition.

If I understand your infrastructure, mnt_writers is going to be frequently 
modified, so it should be placed at the end of struct vfsmount, in the same 
cache line than mnt_count.

Thank you
Eric

