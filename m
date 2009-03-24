Return-Path: <linux-kernel-owner+w=401wt.eu-S1761627AbZCXPgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761627AbZCXPgW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 11:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756772AbZCXPgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 11:36:10 -0400
Received: from kroah.org ([198.145.64.141]:57660 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757226AbZCXPgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 11:36:09 -0400
Date: Tue, 24 Mar 2009 08:33:29 -0700
From: Greg KH <greg@kroah.com>
To: hooanon05@yahoo.co.jp
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Q. DEBUG_FS and SYSFS config (Re: [RFC Aufs2 #3 2/2] split
	'xino' entry under sysfs)
Message-ID: <20090324153329.GA13705@kroah.com>
References: <20090320004539.GF18781@kroah.com> <3934.1237515949@jrobl> <20090320024249.GA19989@kroah.com> <4443.1237517709@jrobl> <20090320030608.GA2638@kroah.com> <5142.1237521581@jrobl> <20090320041811.GA3352@kroah.com> <6218.1237526149@jrobl> <20090320054437.GC3993@kroah.com> <2778.1237882600@jrobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2778.1237882600@jrobl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 05:16:40PM +0900, hooanon05@yahoo.co.jp wrote:
> 
> Greg KH:
> > No one disables sysfs that I know of.  Heck, my phone enables sysfs...
> > 
> > > Addition to set limit, there is one more reason to adopt seq_file.
> > > Because the printed string is a path, it may contain unprintable
> > > characters. seq_file has a good interface seq_path() which supports
> > > escaping such characters.
> > 
> > That is true.  Ok, let's see the final result and I'll be glad to look
> > at it.
> 
> Hi Greg,
> 
> Currently I am testing locally about new aufs entries under debugfs, and
> I found a strange issue about configuration.
> 
> First, configure "normaly".
> General setup
>   [ ] Configure standard kernel features (for small systems)  --->
> 
> $ egrep -i '(sysfs|debug_fs)' .config
> CONFIG_SYSFS_DEPRECATED=y
> CONFIG_SYSFS_DEPRECATED_V2=y

You should disable those two options, no modern distro needs them
anymore.

> CONFIG_SYSFS=y
> CONFIG_DEBUG_FS=y
> # CONFIG_FAULT_INJECTION_DEBUG_FS is not set
> 
> Next, enable EMBEDED, and then disable SYSFS.
> General setup
>   [*] Configure standard kernel features (for small systems)  --->
> File systems
>   Pseudo filesystems  --->
>     [ ] sysfs file system support
> 
> $ egrep -i '(sysfs|debug_fs)' .config
> # CONFIG_SYSFS is not set
> CONFIG_DEBUG_FS=y
> 
> SYSFS is disabled expectedly, but DEBUG_FS is still enabled,
> while "depends on SYSFS" is specified for DEBUG_FS.
> 
> Is this expected behaviour?
> In other words, can I assume "when DEBUG_FS is enabled, SYSFS must be
> enabled too" safely?

Your code should not worry about either of these, it will "just work"
either way.

As for if there is a bug here, I don't know, the kbuild dependancies
should fix it up if you run "make oldconfig" right?

thanks,

greg k-h
