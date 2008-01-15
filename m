Return-Path: <linux-kernel-owner+w=401wt.eu-S1751883AbYAOOVM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883AbYAOOVM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 09:21:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750791AbYAOOU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 09:20:59 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:59556 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702AbYAOOU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 09:20:57 -0500
Date: Tue, 15 Jan 2008 08:21:15 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: serue@us.ibm.com, akpm@linux-foundation.org, hch@infradead.org,
       viro@ftp.linux.org.uk, ebiederm@xmission.com, kzak@redhat.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, util-linux-ng@vger.kernel.org
Subject: Re: [patch 8/9] unprivileged mounts: propagation: inherit owner
	from parent
Message-ID: <20080115142115.GC4453@sergelap.austin.ibm.com>
References: <20080108113502.184459371@szeredi.hu> <20080108113632.895453887@szeredi.hu> <20080114231340.GG6704@sergelap.austin.ibm.com> <E1JEjCG-0000wz-BS@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JEjCG-0000wz-BS@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Miklos Szeredi (miklos@szeredi.hu):
> > Quoting Miklos Szeredi (miklos@szeredi.hu):
> > > From: Miklos Szeredi <mszeredi@suse.cz>
> > > 
> > > On mount propagation, let the owner of the clone be inherited from the
> > > parent into which it has been propagated.  Also if the parent has the
> > > "nosuid" flag, set this flag for the child as well.
> > 
> > What about nodev?
> 
> Hmm, I think the nosuid thing is meant to prevent suid mounts being
> introduced into a "suidless" namespace.  This doesn't apply to dev
> mounts, which are quite safe in a suidless environment, as long as the
> user is not able to create devices.  But that should be taken care of
> by capability tests.
> 
> I'll update the description.

Hmm,

Part of me wants to say the safest thing for now would be to refuse
mounts propagation from non-user mounts to user mounts.

I assume you're thinking about a fully user-mounted chroot, where
the user woudl still want to be able to stick in a cdrom and have
it automounted under /mnt/cdrom, propagated from the root mounts ns?

But then are there no devices which the user could create on a floppy
while inserted into his own laptop, owned by his own uid, then insert
into this machine, and use the device under the auto-mounted /dev/floppy
to gain inappropriate access?

-serge
