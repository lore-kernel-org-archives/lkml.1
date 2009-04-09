Return-Path: <linux-kernel-owner+w=401wt.eu-S935008AbZDIPJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935008AbZDIPJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 11:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934647AbZDIPI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 11:08:59 -0400
Received: from cmpxchg.org ([85.214.51.133]:50247 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758407AbZDIPI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 11:08:58 -0400
Date: Thu, 9 Apr 2009 17:08:43 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] fs: register_filesystem: Don't allow '\t' and '\n'.
Message-ID: <20090409150843.GA3111@cmpxchg.org>
References: <200904092018.GGD57377.FHJOLSMOFQOFVt@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904092018.GGD57377.FHJOLSMOFQOFVt@I-love.SAKURA.ne.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 09, 2009 at 08:18:20PM +0900, Tetsuo Handa wrote:
> Is it legal to use '\t' and '\n' in filesystem's name?
> If legal, we should use \ooo escape for /proc/filesystems .
> 
> ----------
> [RFC PATCH] fs: register_filesystem: Don't allow '\t' and '\n'.
> 
> Registering a filesystem with broken name
> 
>   static struct file_system_type dummy_fs_type = {
>           .name       = "a\tb\nc",
>   };
> 
> results in broken output
> 
>   # cat /proc/filesystems
>   nodev   sysfs
>   nodev   rootfs
>   nodev   bdev
>   nodev   proc
>   nodev   debugfs
>   nodev   sockfs
>   nodev   usbfs
>   nodev   pipefs
>   nodev   anon_inodefs
>   nodev   tmpfs
>   nodev   inotifyfs
>   nodev   devpts
>           ext3
>           ext2
>           cramfs
>   nodev   ramfs
>           vfat
>           iso9660
>   nodev   nfsd
>   nodev   smbfs
>   nodev   a       b
>   c
>   nodev   rpc_pipefs
> 
> Why not forbid '\t' and '\n'?

Which filesystem does that?  Shouldn't the filesystem get changed
instead?

	Hannes
