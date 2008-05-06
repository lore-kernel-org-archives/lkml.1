Return-Path: <linux-kernel-owner+w=401wt.eu-S1755378AbYEFEVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378AbYEFEVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 00:21:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192AbYEFEVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 00:21:16 -0400
Received: from mx1.suse.de ([195.135.220.2]:36265 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbYEFEVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 00:21:05 -0400
Date: Mon, 5 May 2008 21:15:55 -0700
From: Greg KH <gregkh@suse.de>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [patch 06/15] sysfs: dont call notify_change
Message-ID: <20080506041555.GA4655@suse.de>
References: <20080505095440.820370974@szeredi.hu> <20080505095516.130659599@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080505095516.130659599@szeredi.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2008 at 11:54:47AM +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> sysfs_chmod_file() calls notify_change() to change the permission bits
> on a sysfs file.  Replace with explicit call to sysfs_setattr() and
> fsnotify_change().
> 
> This is equivalent, except that security_inode_setattr() is not
> called.  This function is called by drivers, so the security checks do
> not make any sense.

Are you sure?  As a user, you can chmod the sysfs file and it will
stick, I thought that is what this function was accomplishing.  You will
want to call the security checks in those cases, right?

thanks,

greg k-h
