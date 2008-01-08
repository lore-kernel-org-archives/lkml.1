Return-Path: <linux-kernel-owner+w=401wt.eu-S1754716AbYAHTKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbYAHTKd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 14:10:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbYAHTKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 14:10:23 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:47689 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbYAHTKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 14:10:22 -0500
To: haveblue@us.ibm.com
CC: akpm@linux-foundation.org, hch@infradead.org, serue@us.ibm.com,
       viro@ftp.linux.org.uk, ebiederm@xmission.com, kzak@redhat.com,
       linux-fsdevel@vger.kernel.org, containers@lists.osdl.org,
       util-linux-ng@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <1199815958.9834.58.camel@localhost> (message from Dave Hansen on
	Tue, 08 Jan 2008 10:12:38 -0800)
Subject: Re: [patch 5/9] unprivileged mounts: allow unprivileged bind mounts
References: <20080108113502.184459371@szeredi.hu>
	 <20080108113626.895583537@szeredi.hu> <1199815958.9834.58.camel@localhost>
Message-Id: <E1JCJoQ-0003g9-Nk@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 08 Jan 2008 20:08:34 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 2008-01-08 at 12:35 +0100, Miklos Szeredi wrote:
> > +static int reserve_user_mount(void)
> > +{
> > +       int err = 0;
> > +
> > +       spin_lock(&vfsmount_lock);
> > +       if (nr_user_mounts >= max_user_mounts && !capable(CAP_SYS_ADMIN))
> > +               err = -EPERM;
> > +       else
> > +               nr_user_mounts++;
> > +       spin_unlock(&vfsmount_lock);
> > +       return err;
> > +} 
> 
> Would -ENOSPC or -ENOMEM be a more descriptive error here?  

The logic behind EPERM, is that this failure is only for unprivileged
callers.  ENOMEM is too specifically about OOM.  It could be changed
to ENOSPC, ENFILE, EMFILE, or it could remain EPERM.  What do others
think?

Miklos
