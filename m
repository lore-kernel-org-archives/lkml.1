Return-Path: <linux-kernel-owner+w=401wt.eu-S1756022AbZGIUmG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022AbZGIUmG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 16:42:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755117AbZGIUlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 16:41:53 -0400
Received: from cantor.suse.de ([195.135.220.2]:38279 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754920AbZGIUlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 16:41:52 -0400
Date: Thu, 9 Jul 2009 13:41:28 -0700
From: Greg KH <gregkh@suse.de>
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
Cc: jmorris@namei.org, sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH] Security/sysfs: Enable security xattrs to be set on
 sysfs files, directories, and symlinks.
Message-ID: <20090709204128.GA27638@suse.de>
References: <1247074106-23405-1-git-send-email-dpquigl@tycho.nsa.gov>
 <20090709151803.GB24302@suse.de>
 <1247159613.4398.215.camel@localhost>
 <20090709175250.GB26378@suse.de>
 <1247167738.4398.229.camel@localhost>
 <20090709201257.GB27124@suse.de>
 <1247170786.4398.242.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247170786.4398.242.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 09, 2009 at 04:19:45PM -0400, David P. Quigley wrote:
> On Thu, 2009-07-09 at 13:12 -0700, Greg KH wrote:
> > On Thu, Jul 09, 2009 at 03:28:58PM -0400, David P. Quigley wrote:
> > > On Thu, 2009-07-09 at 10:52 -0700, Greg KH wrote:
> > > > On Thu, Jul 09, 2009 at 01:13:33PM -0400, David P. Quigley wrote:
> > > > > The issue is that there really aren't any LSM hooks to accommodate that.
> > > > > I have a few LSM hooks for the Labeled NFS work which could be used for
> > > > > this but it still requires us to store the full xattr value somewhere
> > > > > and referencing it in the sysfs_dirent structure.
> > > > 
> > > > A void pointer would handle that properly, right?
> > > 
> > > A void pointer would suffice if we wanted to store the opaque blob. My
> > > argument is that storing that blob is too heavy weight memory wise.
> > 
> > You could use that void pointer to store your id with no memory
> > difference at all, so why would it be "heavy weight"?  It shoud be
> > identical, right?
> > 
> > thanks,
> > 
> > greg k-h
> 
> 
> Not quite. From the memory foot print inside sysfs_dirent it is the same
> (baring a pointer being 64-bit on certain platforms) however that
> pointer needs to be backed by something. The two current interfaces in
> LSM to set an inode security attribute is 1) the xattr, and 2) a secid.
> The issue is if we say some people can store the xattr and some can
> store a secid I then don't know what hook to call to set the security
> information on creation. Which basically boils down to if we have a void
> * in sysfs_dirent it has to be the same void * semantics already used
> which means it needs to have a string with the label backing it. This
> means in the SELinux case I'm now using memory for the string and the
> structure in the security server which is a waste. It seems to me though
> that It might be possible to make the size of the secid correspond to
> the size of a pointer so Casey can return the address of his string as
> the secid and we can return the secid. However, it still needs to have
> the semantics of the secid and not the opaque void *. 
> 
> I could be wrong about this but at the moment the mismatch of semantics
> between the two seem to be a problem. If I'm missing anything feel free
> to point it out.

No, that makes sense as well.  I'll let you and Casey work it out :)

good luck,

greg k-h
