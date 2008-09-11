Return-Path: <linux-kernel-owner+w=401wt.eu-S1752960AbYIKOpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960AbYIKOpA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 10:45:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753990AbYIKOot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 10:44:49 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:59384 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbYIKOos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 10:44:48 -0400
To: ebiederm@xmission.com
CC: miklos@szeredi.hu, serue@us.ibm.com, akpm@linux-foundation.org,
       hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <m11vzrge86.fsf@frodo.ebiederm.org>
Subject: Re: unprivileged mounts git tree
References: <E1KYNMl-0000TG-Qs@pomaz-ex.szeredi.hu>
	<20080827184600.GA8069@us.ibm.com>
	<E1KaxLm-0006OD-K8@pomaz-ex.szeredi.hu>
	<20080903220215.GA27705@us.ibm.com>
	<E1Kb0ml-0006qL-5M@pomaz-ex.szeredi.hu>
	<20080903224334.GA726@us.ibm.com>
	<E1Kb8Y0-0008Gh-FP@pomaz-ex.szeredi.hu>
	<20080904132804.GA14709@us.ibm.com>
	<E1KbFU3-0002Ne-Oe@pomaz-ex.szeredi.hu>
	<E1KbGwb-0002rl-49@pomaz-ex.szeredi.hu>
	<20080905153134.GA18367@us.ibm.com>
	<E1Kd3Mh-0001vk-F5@pomaz-ex.szeredi.hu> <m11vzrge86.fsf@frodo.ebiederm.org>
Message-Id: <E1KdnOb-00068L-Eq@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 11 Sep 2008 16:43:45 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Sep 2008, ebiederm@xmission.com (Eric W. Biederman)
> There is a weird corner case I'm trying to wrap my head around.
> unlink and rmdir do not work on dentries that are mount points
> in another mount namespace.
> 
> Which is at least needed for the moment so we don't leak mounts.
> 
> Once we have unprivileged mounts does that introduce a DOS attack?

Hmm, yes.  That's a tough one...

I think if the dentry has only user mounts, unlink should go ahead and
on success dissolve any mounts on the dentry.  Does that sound
workable?

Thanks,
Miklos
