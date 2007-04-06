Return-Path: <linux-kernel-owner+w=401wt.eu-S1751048AbXDFTCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751048AbXDFTCq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 15:02:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751443AbXDFTCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 15:02:45 -0400
Received: from waste.org ([66.93.16.53]:47595 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048AbXDFTCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 15:02:44 -0400
Date: Fri, 6 Apr 2007 13:50:11 -0500
From: Matt Mackall <mpm@selenic.com>
To: Milind Arun Choudhary <milindchoudhary@gmail.com>
Cc: kernel-janitors@lists.osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [KJ][RFC]NAME_OFFSET macro
Message-ID: <20070406185011.GW10459@waste.org>
References: <20070406085813.GA12105@arun.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070406085813.GA12105@arun.site>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 06, 2007 at 02:28:13PM +0530, Milind Arun Choudhary wrote:
> 
> milind@arun:~/src/linux> egrep -rin "#define.*NAME_?OFFSET" .
> ./arch/alpha/kernel/osf_sys.c:95:#define NAME_OFFSET    offsetof (struct osf_dirent, d_name)
> ./arch/mips/kernel/sysirix.c:1738:#define NAME_OFFSET32(de) ((int) ((de)->d_name - (char *) (de)))
> ./arch/mips/kernel/sysirix.c:1840:#define NAME_OFFSET64(de) ((int) ((de)->d_name - (char *) (de)))
> ./arch/parisc/hpux/fs.c:72:#define NAME_OFFSET(de) ((int) ((de)->d_name - (char __user *) (de)))
> ./arch/parisc/kernel/sys_parisc32.c:315:#define NAME_OFFSET(de) ((int) ((de)->d_name - (char __user *) (de)))
> ./arch/powerpc/kernel/sys_ppc32.c:57:#define NAME_OFFSET(de) ((int) ((de)->d_name - (char __user *) (de)))
> ./arch/sparc/kernel/sys_sunos.c:324:#define NAME_OFFSET(de) ((int) ((de)->d_name - (char __user *) (de)))
> ./arch/sparc64/kernel/sys_sunos32.c:275:#define NAME_OFFSET(de) ((int) ((de)->d_name - (char __user *) (de)))
> ./drivers/isdn/hardware/eicon/s_4bri.c:184:#define FPGA_NAME_OFFSET         0x10
> ./fs/compat.c:903:#define NAME_OFFSET(de) ((int) ((de)->d_name - (char __user *) (de)))
> ./fs/readdir.c:54:#define NAME_OFFSET(de) ((int) ((de)->d_name - (char __user *) (de)))
> ./include/linux/fuse.h:342:#define FUSE_NAME_OFFSET ((unsigned) ((struct fuse_dirent *) 0)->name)
> 
> 
> just working out different options before putting it in kernel.h
> 
> as all the dirent structures have used the 
> same name for the d_name member,so we can use
> 
> #define NAME_OFFSET(dirent) ((int) ((dirent)->d_name - (char __user *) (dirent)))
> 
> but then it becomes binding on the future users
>  to maintain the same naming  convention.
> 
> #define NAME_OFFSET(dirent,d_name) ((int) ((dirent)->d_name - (char __user *) (dirent)))
> 
> #define NAME_OFFSET(dirent,d_name) offsetof(struct dirent,d_name)
> 
> though ..the first one seem to be just fine
> 
> thoughts

Delete all instances of the macro. Replace all uses of it with
offsetof(foo, name). You wouldn't wrap a simple sizeof in a macro like
this, there's no reason to do so with offsetof except for ignorance of
offsetof's existence.

Actually most of the above are probably copy and paste of code predating the
kernel having a global offsetof definition.

-- 
Mathematics is the supreme nostalgia of our time.
