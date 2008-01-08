Return-Path: <linux-kernel-owner+w=401wt.eu-S1756434AbYAHUzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756434AbYAHUzt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 15:55:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753272AbYAHUzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 15:55:39 -0500
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:35254 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133AbYAHUzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 15:55:37 -0500
X-Greylist: delayed 699 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Jan 2008 15:55:37 EST
Date: Tue, 8 Jan 2008 22:44:20 +0200 (MET DST)
From: Szabolcs Szakacsits <szaka@ntfs-3g.org>
X-X-Sender: szaka@dhcppc1
To: Miklos Szeredi <miklos@szeredi.hu>
cc: haveblue@us.ibm.com, akpm@linux-foundation.org, hch@infradead.org,
       serue@us.ibm.com, viro@ftp.linux.org.uk, ebiederm@xmission.com,
       kzak@redhat.com, linux-fsdevel@vger.kernel.org,
       containers@lists.osdl.org, util-linux-ng@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 5/9] unprivileged mounts: allow unprivileged bind mounts
In-Reply-To: <E1JCJoQ-0003g9-Nk@pomaz-ex.szeredi.hu>
Message-ID: <Pine.LNX.4.61.0801082227050.4441@dhcppc1>
References: <20080108113502.184459371@szeredi.hu>  <20080108113626.895583537@szeredi.hu>
 <1199815958.9834.58.camel@localhost> <E1JCJoQ-0003g9-Nk@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Antivirus: VAMS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 8 Jan 2008, Miklos Szeredi wrote:
> > On Tue, 2008-01-08 at 12:35 +0100, Miklos Szeredi wrote:
> > > +static int reserve_user_mount(void)
> > > +{
> > > +       int err = 0;
> > > +
> > > +       spin_lock(&vfsmount_lock);
> > > +       if (nr_user_mounts >= max_user_mounts && !capable(CAP_SYS_ADMIN))
> > > +               err = -EPERM;
> > > +       else
> > > +               nr_user_mounts++;
> > > +       spin_unlock(&vfsmount_lock);
> > > +       return err;
> > > +} 
> > 
> > Would -ENOSPC or -ENOMEM be a more descriptive error here?  
> 
> The logic behind EPERM, is that this failure is only for unprivileged
> callers.  ENOMEM is too specifically about OOM.  It could be changed
> to ENOSPC, ENFILE, EMFILE, or it could remain EPERM.  What do others
> think?

I think it would be important to log the non-trivial errors. Several 
mount(8) hints to check for the reason by dmesg since it's already too 
challanging to figure out what's exactly the problem by the errno value. 
This could also prevent to mislead troubleshooters with the mount/sysctl 
race.

	Szaka

-- 
NTFS-3G:  http://ntfs-3g.org
