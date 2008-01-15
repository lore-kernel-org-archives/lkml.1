Return-Path: <linux-kernel-owner+w=401wt.eu-S1756926AbYAOKQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926AbYAOKQp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 05:16:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754301AbYAOKQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 05:16:35 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:39791 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345AbYAOKQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 05:16:34 -0500
To: serue@us.ibm.com
CC: miklos@szeredi.hu, akpm@linux-foundation.org, hch@infradead.org,
       serue@us.ibm.com, viro@ftp.linux.org.uk, ebiederm@xmission.com,
       kzak@redhat.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org,
       util-linux-ng@vger.kernel.org
In-reply-to: <20080114222305.GD6704@sergelap.austin.ibm.com>
	(serue@us.ibm.com)
Subject: Re: [patch 4/9] unprivileged mounts: propagate error values from
	clone_mnt
References: <20080108113502.184459371@szeredi.hu> <20080108113624.898035951@szeredi.hu> <20080114222305.GD6704@sergelap.austin.ibm.com>
Message-Id: <E1JEipn-0000tq-3Q@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 15 Jan 2008 11:15:55 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Quoting Miklos Szeredi (miklos@szeredi.hu):
> > From: Miklos Szeredi <mszeredi@suse.cz>
> > 
> > Allow clone_mnt() to return errors other than ENOMEM.  This will be used for
> > returning a different error value when the number of user mounts goes over the
> > limit.
> > 
> > Fix copy_tree() to return EPERM for unbindable mounts.
> > 
> > Don't propagate further from dup_mnt_ns() as that copy_tree() can only fail
> > with -ENOMEM.
> 
> I see what you're saying, but it just seems like it's bound to be more
> confusing this way.

Ah yes, this is indeed confusing.  Last time dup_mnt_ns() returned a
namespace pointer or NULL.  But now I see it returns an ERR_PTR(error)
instead, which means it's cleaner to just propagate the error value.
I'll fix this.

Thanks,
Miklos
