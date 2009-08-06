Return-Path: <linux-kernel-owner+w=401wt.eu-S1753184AbZHFAOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184AbZHFAOJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 20:14:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751806AbZHFAOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 20:14:08 -0400
Received: from kroah.org ([198.145.64.141]:41366 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751338AbZHFAOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 20:14:07 -0400
Date: Wed, 5 Aug 2009 17:06:59 -0700
From: Greg KH <greg@kroah.com>
To: Alan Jenkins <sourcejedi.lkml@googlemail.com>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Jan Blunck <jblunck@suse.de>, gregkh@suse.de,
       Harald Hoyer <harald@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based
 /dev
Message-ID: <20090806000659.GA22754@kroah.com>
References: <20090805171513.GA10443@kroah.com>
 <9b2b86520908051355o79699e99ke045b635c6b443ad@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b2b86520908051355o79699e99ke045b635c6b443ad@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 05, 2009 at 09:55:49PM +0100, Alan Jenkins wrote:
> On 8/5/09, Greg KH <greg@kroah.com> wrote:
> > Here's the devtmpfs patch again.  For .32 it's a simple and clean patch.
> > It's been tested and agreed by three major distros that this is a good
> > idea.  SuSE has been shipping this in their kernels for a while now with
> > no problems, and actual speedups measured on their boot times.  Gentoo
> > also has been testing it, but we haven't gotten a tested-by: line from
> > them yet, hopefully that will happen soon.
> >
> > A number of embedded distros have also privately said they would be
> > using this patch, I really don't understand why they don't publically
> > want to state this, but oh well...
> >
> > It's been in linux-next for many months now, with no reported
> > regressions at all as well.
> >
> > thanks,
> >
> > greg k-h
> >
> > --------------
> >
> >
> > From: Kay Sievers <kay.sievers@vrfy.org>
> >
> > Devtmpfs lets the kernel create a tmpfs instance called devtmpfs
> > very early at kernel initialization, before any driver-core device
> > is registered. Every device with a major/minor will provide a
> > device node in devtmpfs.
> >
> > Devtmpfs can be changed and altered by userspace at any time,
> > and in any way needed - just like today's udev-mounted tmpfs.
> > Unmodified udev versions will run just fine on top of it, and will
> > recognize an already existing kernel-created device node and use it.
> > The default node permissions are root:root 0600. Proper permissions
> > and user/group ownership, meaningful symlinks, all other policy still
> > needs to be applied by userspace.
> 
> > +	err = vfs_path_lookup(dev_mnt->mnt_root, dev_mnt,
> > +			      path, LOOKUP_PARENT, &nd);
> > +	if (err == 0) {
> > +		struct dentry *dentry;
> > +
> > +		/* create directory right away */
> > +		dentry = lookup_create(&nd, 1);
> > +		if (!IS_ERR(dentry)) {
> > +			err = vfs_mkdir(nd.path.dentry->d_inode,
> > +					dentry, 0775);
> 
> Is there a typo here?  I think the mode should be 0755.   0755 is used
> below, and that does fit better with the 0600 mode for device nodes.

Yeah, I think you are correct.  Kay, any objection to me making this
change?

thanks,

greg k-h
