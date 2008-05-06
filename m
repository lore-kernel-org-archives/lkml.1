Return-Path: <linux-kernel-owner+w=401wt.eu-S1758712AbYEFG24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758712AbYEFG24 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 02:28:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751440AbYEFG2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 02:28:47 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:54361 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbYEFG2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 02:28:46 -0400
To: gregkh@suse.de
CC: miklos@szeredi.hu, akpm@linux-foundation.org, hch@infradead.org,
       viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-reply-to: <20080506041555.GA4655@suse.de> (message from Greg KH on Mon, 5
	May 2008 21:15:55 -0700)
Subject: Re: [patch 06/15] sysfs: dont call notify_change
References: <20080505095440.820370974@szeredi.hu> <20080505095516.130659599@szeredi.hu> <20080506041555.GA4655@suse.de>
Message-Id: <E1JtGfH-0008Bv-MI@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 06 May 2008 08:28:39 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > sysfs_chmod_file() calls notify_change() to change the permission bits
> > on a sysfs file.  Replace with explicit call to sysfs_setattr() and
> > fsnotify_change().
> > 
> > This is equivalent, except that security_inode_setattr() is not
> > called.  This function is called by drivers, so the security checks do
> > not make any sense.
> 
> Are you sure?  As a user, you can chmod the sysfs file and it will
> stick,

Right, but that's not sysfs_chmod_file() but sys_chmod(), which calls
notify_change(), which calls security_inode_setattr().

sysfs_chmod_file() is just called by a couple of drivers to change the
file mode during operation, it's never called by user action directly.

Miklos
