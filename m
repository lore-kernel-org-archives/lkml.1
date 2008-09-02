Return-Path: <linux-kernel-owner+w=401wt.eu-S1753228AbYIBNia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228AbYIBNia (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 09:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751422AbYIBNiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 09:38:19 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:34931 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390AbYIBNiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 09:38:18 -0400
Subject: Re: (repost) Confirmation of methods for calculating requested
	pathname.
From: Stephen Smalley <sds@tycho.nsa.gov>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Kentaro Takeda <takedakn@nttdata.co.jp>, viro@ZenIV.linux.org.uk,
       linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, miklos@szeredi.hu, hch@infradead.org,
       akpm@linux-foundation.org, Toshiharu Harada <haradats@nttdata.co.jp>
In-Reply-To: <20080902131127.GA5951@hallyn.com>
References: <48AA49DE.6000006@nttdata.co.jp>
	 <48BCC1B6.5030901@nttdata.co.jp>  <20080902131127.GA5951@hallyn.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Tue, 02 Sep 2008 09:37:20 -0400
Message-Id: <1220362640.26711.69.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-09-02 at 08:11 -0500, Serge E. Hallyn wrote:
> Quoting Kentaro Takeda (takedakn@nttdata.co.jp):
> > Al, could you answer the following question?
> > 
> > 
> > The current Linux kernel is not designed to pass vfsmount parameter
> > that is crucial for pathname-based security including AppArmor and
> > TOMOYO Linux, to LSM. Though both projects have been proposing
> > patches to calculate pathname, none of them have been accepted as
> > you know.
> > 
> > To find the reason for NACK, we examined past proposals and the
> > threads. And we came to understand that you oppose accessing vfsmount
> > inside vfs helper functions. Is our understanding correct?
> > 
> > If our understanding is correct, we would like to propose a new
> > method that does not require modifications to vfs helper functions.
> > Attached patch is a trial of this method.
> > 
> > vfs helper functions are surrounded by mnt_want_write() and
> > mnt_drop_write() pairs which receive "struct vfsmount" parameter
> 
> I thought Al and others (Stephen?) had made it clear that the thing to do was
> add new lsm hooks there.  So whereas inode_permission takes only an inode and
> ends up calling security_inode_permission, you would add a
> security_path_permission() or somesuch before or after the call to
> inode_permission(), where as you've noted the path is available.  You're
> *close* to doing the right thing by having a helper who is called at the right
> place catch the vfsmount, but you refuse to send a patch doing exactly what
> has been suggested.

No, that idea seemingly died because both Al and Miklos thought it was
wrong to add new security hooks to the same code path (vs. moving the
existing ones to the callers), but I was opposed to moving the existing
hooks as they are presently exactly where SELinux needs them, and moving
them to the callers raises concerns both with ensuring invocation on all
code paths (possible, but an ongoing maintenance concern) and with
performing DAC checks first where possible (which I think is also a
concern for TOMOYO et al).  Miklos' vfs path API showed more promise but
was rejected.

-- 
Stephen Smalley
National Security Agency

