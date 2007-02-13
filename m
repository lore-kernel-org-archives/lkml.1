Return-Path: <linux-kernel-owner+w=401wt.eu-S1750883AbXBMT6J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750883AbXBMT6J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 14:58:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750891AbXBMT6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 14:58:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33415 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883AbXBMT6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 14:58:08 -0500
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SuSE Labs, Novell
To: Greg KH <greg@kroah.com>
Subject: Re: Bug in current -git tree causing dbus and gnome to chew up cpu time
Date: Tue, 13 Feb 2007 11:58:02 -0800
User-Agent: KMail/1.9.5
Cc: torvalds@linux-foundation.org, neilb@suse.de, viro@zeniv.linux.org.uk,
       hch@lst.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <20070213195116.GA5181@kroah.com>
In-Reply-To: <20070213195116.GA5181@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702131158.02809.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 February 2007 11:51, Greg KH wrote:
> Hi,
>
> I've used 'git bisect' to track down a change in the latest git tree
> that is causing dbus-daemon to sit and spin at the time GNOME launches,
> preventing nautlius from ever running.
>
> The bad commit is:
> commit eb3dfb0cb1f4a44e2d0553f89514ce9f2a9fcaf1
> Author: Andreas Gruenbacher <agruen@suse.de>
> Date:   Mon Feb 12 00:51:47 2007 -0800
>
>     [PATCH] Fix d_path for lazy unmounts
>
> With that patch out, GNOME startup works just fine.  I have a strace of
> the dbus process running showing the problem, if anyone thinks that will
> help out any.

I'd like to see that, please.

> I'm running pretty new GNOME and dbus here:
> 	dbus 1.0.2
> 	gnome 2.16.2
> 	hal 0.5.7.1
> 	nautilus 2.16.3
>
> Any ideas of things I can test?

Sorry for the breakage. Printk of the __d_path result may tell:

Index: b/fs/dcache.c
===================================================================
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1803,6 +1803,8 @@ char *__d_path(struct dentry *dentry, st

 out:
        spin_unlock(&dcache_lock);
+	printk(KERN_DEBUG "%s(%d): %s\n", current->comm, current->pid,
+	       IS_ERR(buffer) ? "failed" : buffer);
	return buffer;

 global_root:

Thanks,
Andreas
