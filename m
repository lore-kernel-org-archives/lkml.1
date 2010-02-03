Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612Ab0BCOjN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 09:39:13 -0500
Received: from cantor.suse.de ([195.135.220.2]:36121 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754484Ab0BCOjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 09:39:08 -0500
Date: Wed, 3 Feb 2010 06:22:18 -0800
From: Greg KH <gregkh@suse.de>
To: Jean Delvare <khali@linux-fr.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       Serge Hallyn <serue@us.ibm.com>
Subject: Re: sysfs_chmod_file() broken in 2.6.33-rc4-git6
Message-ID: <20100203142218.GA27676@suse.de>
References: <20100120131602.12aa48f7@hyperion.delvare> <m1ocko6fkx.fsf@fess.ebiederm.org> <20100120160008.7d59688b@hyperion.delvare> <20100122041913.GC4302@suse.de> <20100203091138.1ababf5e@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100203091138.1ababf5e@hyperion.delvare>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 03, 2010 at 09:11:38AM +0100, Jean Delvare wrote:
> On Thu, 21 Jan 2010 20:19:13 -0800, Greg KH wrote:
> > On Wed, Jan 20, 2010 at 04:00:08PM +0100, Jean Delvare wrote:
> > > On Wed, 20 Jan 2010 06:01:02 -0800, Eric W. Biederman wrote:
> > > > Does this fix your issue?
> > > > 
> > > > Eric
> > > > 
> > > > 
> > > > diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
> > > > index 220b758..6a06a1d 100644
> > > > --- a/fs/sysfs/inode.c
> > > > +++ b/fs/sysfs/inode.c
> > > > @@ -81,24 +81,23 @@ int sysfs_sd_setattr(struct sysfs_dirent *sd, struct iattr * iattr)
> > > >  		if (!sd_attrs)
> > > >  			return -ENOMEM;
> > > >  		sd->s_iattr = sd_attrs;
> > > > -	} else {
> > > > -		/* attributes were changed at least once in past */
> > > > -		iattrs = &sd_attrs->ia_iattr;
> > > > -
> > > > -		if (ia_valid & ATTR_UID)
> > > > -			iattrs->ia_uid = iattr->ia_uid;
> > > > -		if (ia_valid & ATTR_GID)
> > > > -			iattrs->ia_gid = iattr->ia_gid;
> > > > -		if (ia_valid & ATTR_ATIME)
> > > > -			iattrs->ia_atime = iattr->ia_atime;
> > > > -		if (ia_valid & ATTR_MTIME)
> > > > -			iattrs->ia_mtime = iattr->ia_mtime;
> > > > -		if (ia_valid & ATTR_CTIME)
> > > > -			iattrs->ia_ctime = iattr->ia_ctime;
> > > > -		if (ia_valid & ATTR_MODE) {
> > > > -			umode_t mode = iattr->ia_mode;
> > > > -			iattrs->ia_mode = sd->s_mode = mode;
> > > > -		}
> > > > +	}
> > > > +	/* attributes were changed at least once in past */
> > > > +	iattrs = &sd_attrs->ia_iattr;
> > > > +
> > > > +	if (ia_valid & ATTR_UID)
> > > > +		iattrs->ia_uid = iattr->ia_uid;
> > > > +	if (ia_valid & ATTR_GID)
> > > > +		iattrs->ia_gid = iattr->ia_gid;
> > > > +	if (ia_valid & ATTR_ATIME)
> > > > +		iattrs->ia_atime = iattr->ia_atime;
> > > > +	if (ia_valid & ATTR_MTIME)
> > > > +		iattrs->ia_mtime = iattr->ia_mtime;
> > > > +	if (ia_valid & ATTR_CTIME)
> > > > +		iattrs->ia_ctime = iattr->ia_ctime;
> > > > +	if (ia_valid & ATTR_MODE) {
> > > > +		umode_t mode = iattr->ia_mode;
> > > > +		iattrs->ia_mode = sd->s_mode = mode;
> > > >  	}
> > > >  	return 0;
> > > >  }
> > > 
> > > Yes, this fixes my problem. Thanks for the fast fix!
> > 
> > Great, Eric, care to resend this so that I can submit it for inclusion?
> 
> Ping Eric, the patch is still not in Linus' tree.

Nor mine :)

Eric, care to send it to me?

thanks,

greg k-h
