Return-Path: <linux-kernel-owner+w=401wt.eu-S934807AbXEWP0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934807AbXEWP0l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 11:26:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756670AbXEWP0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 11:26:31 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:33287 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755168AbXEWP0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 11:26:30 -0400
To: viro@ftp.linux.org.uk
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
In-reply-to: <20070523150602.GZ4095@ftp.linux.org.uk> (message from Al Viro on
	Wed, 23 May 2007 16:06:02 +0100)
Subject: Re: [RFC PATCH] file as directory
References: <E1HqZPd-0008Dh-00@dorka.pomaz.szeredi.hu> <20070523095127.GQ4095@ftp.linux.org.uk> <E1HqnmR-0001dI-00@dorka.pomaz.szeredi.hu> <20070523102437.GS4095@ftp.linux.org.uk> <E1HqoGh-0001kd-00@dorka.pomaz.szeredi.hu> <20070523113925.GT4095@ftp.linux.org.uk> <20070523121620.GU4095@ftp.linux.org.uk> <E1HqqTC-00023W-00@dorka.pomaz.szeredi.hu> <20070523135140.GW4095@ftp.linux.org.uk> <E1HqrtF-0002Fb-00@dorka.pomaz.szeredi.hu> <20070523150602.GZ4095@ftp.linux.org.uk>
Message-Id: <E1Hqsij-000338-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 23 May 2007 17:25:49 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > How will this work with copy_tree() and namespace duplication, which
> > currently walk the tree with only namespace_sem held?
> 
> Easy - grab namespace_sem, grab vfsmount_lock, walk the subtree and bump
> mnt_busy on everything (by 1 + number of non-busy children).  Then drop
> vfsmount_lock and do as usual, dropping references in tree being copied
> as you go.  Nothing will get attached or detached due to namespace_sem,
> nothing will get evicted by anybody other than you since you've got all
> that stuff pinned down.  End of story...

Right.

Do you have some code?

Should I try to code something up?

Miklos
