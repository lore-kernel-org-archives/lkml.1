Return-Path: <linux-kernel-owner+w=401wt.eu-S1757685AbYEFGtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757685AbYEFGtX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 02:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753111AbYEFGsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 02:48:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40923 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752933AbYEFGsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 02:48:50 -0400
Date: Mon, 5 May 2008 23:48:17 -0700
From: Greg KH <gregkh@suse.de>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [patch 06/15] sysfs: dont call notify_change
Message-ID: <20080506064817.GB6062@suse.de>
References: <20080505095440.820370974@szeredi.hu> <20080505095516.130659599@szeredi.hu> <20080506041555.GA4655@suse.de> <E1JtGfH-0008Bv-MI@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JtGfH-0008Bv-MI@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2008 at 08:28:39AM +0200, Miklos Szeredi wrote:
> > > sysfs_chmod_file() calls notify_change() to change the permission bits
> > > on a sysfs file.  Replace with explicit call to sysfs_setattr() and
> > > fsnotify_change().
> > > 
> > > This is equivalent, except that security_inode_setattr() is not
> > > called.  This function is called by drivers, so the security checks do
> > > not make any sense.
> > 
> > Are you sure?  As a user, you can chmod the sysfs file and it will
> > stick,
> 
> Right, but that's not sysfs_chmod_file() but sys_chmod(), which calls
> notify_change(), which calls security_inode_setattr().
> 
> sysfs_chmod_file() is just called by a couple of drivers to change the
> file mode during operation, it's never called by user action directly.

Ah, sorry, you are correct, no objection from me for this patch:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

thanks,

greg k-h
