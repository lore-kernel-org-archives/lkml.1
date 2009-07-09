Return-Path: <linux-kernel-owner+w=401wt.eu-S1754843AbZGIRxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843AbZGIRxt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 13:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753854AbZGIRxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 13:53:33 -0400
Received: from cantor.suse.de ([195.135.220.2]:35121 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754179AbZGIRxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 13:53:32 -0400
Date: Thu, 9 Jul 2009 10:52:50 -0700
From: Greg KH <gregkh@suse.de>
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
Cc: jmorris@namei.org, sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH] Security/sysfs: Enable security xattrs to be set on
 sysfs files, directories, and symlinks.
Message-ID: <20090709175250.GB26378@suse.de>
References: <1247074106-23405-1-git-send-email-dpquigl@tycho.nsa.gov>
 <20090709151803.GB24302@suse.de>
 <1247159613.4398.215.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247159613.4398.215.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 09, 2009 at 01:13:33PM -0400, David P. Quigley wrote:
> The issue is that there really aren't any LSM hooks to accommodate that.
> I have a few LSM hooks for the Labeled NFS work which could be used for
> this but it still requires us to store the full xattr value somewhere
> and referencing it in the sysfs_dirent structure.

A void pointer would handle that properly, right?

> The issue here is that there are two ways of presenting security
> information. The first is through the xattr interface which represents
> the security information as an opaque blob which the LSM turns into an
> internal representation. The second which is left over from the early
> days is the secid which I equate to a file handle. The problem I see
> is that the opaque blob (the xattr) is the interface presented to user
> space. It isn't really used internally except to turn it into a data
> structure or to write it to disk for persistence.

That is the way that selinux does it, do the other lsms also handle it
this way?

> The situation we have with sysfs is that there is no persistence for
> labels and the in-core inode maybe evicted so we need a way of
> persisting changes from the default label.

So you put it in the structure you did, which is correct.  You should
also listen to all sysfs netlink messages to be sure to lable things
when they are created, to handle the lack of persistence.

thanks,

greg k-h
