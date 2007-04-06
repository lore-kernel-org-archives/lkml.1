Return-Path: <linux-kernel-owner+w=401wt.eu-S1751884AbXDFI4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884AbXDFI4x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 04:56:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752324AbXDFI4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 04:56:53 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:34261 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbXDFI4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 04:56:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=lGfJkz0xobk+qDjd5Quy3Td5QxXV3VTjxbkLWAkXIfq5xzQz1DIvC0N1pdvv53lKHvHW/fdjMbcRJrsG6Ffy674/s0zdB7KXJjosozvH7Z/nh9YeSizbfv6RtfkmB5k3xaV5U9B+IgVr6hoQoXW1rR2uCSKGrO7ycB4kNjy9x+I=
Date: Fri, 6 Apr 2007 14:28:13 +0530
From: Milind Arun Choudhary <milindchoudhary@gmail.com>
To: kernel-janitors@lists.osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [KJ][RFC]NAME_OFFSET macro
Message-ID: <20070406085813.GA12105@arun.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


milind@arun:~/src/linux> egrep -rin "#define.*NAME_?OFFSET" .
./arch/alpha/kernel/osf_sys.c:95:#define NAME_OFFSET    offsetof (struct osf_dirent, d_name)
./arch/mips/kernel/sysirix.c:1738:#define NAME_OFFSET32(de) ((int) ((de)->d_name - (char *) (de)))
./arch/mips/kernel/sysirix.c:1840:#define NAME_OFFSET64(de) ((int) ((de)->d_name - (char *) (de)))
./arch/parisc/hpux/fs.c:72:#define NAME_OFFSET(de) ((int) ((de)->d_name - (char __user *) (de)))
./arch/parisc/kernel/sys_parisc32.c:315:#define NAME_OFFSET(de) ((int) ((de)->d_name - (char __user *) (de)))
./arch/powerpc/kernel/sys_ppc32.c:57:#define NAME_OFFSET(de) ((int) ((de)->d_name - (char __user *) (de)))
./arch/sparc/kernel/sys_sunos.c:324:#define NAME_OFFSET(de) ((int) ((de)->d_name - (char __user *) (de)))
./arch/sparc64/kernel/sys_sunos32.c:275:#define NAME_OFFSET(de) ((int) ((de)->d_name - (char __user *) (de)))
./drivers/isdn/hardware/eicon/s_4bri.c:184:#define FPGA_NAME_OFFSET         0x10
./fs/compat.c:903:#define NAME_OFFSET(de) ((int) ((de)->d_name - (char __user *) (de)))
./fs/readdir.c:54:#define NAME_OFFSET(de) ((int) ((de)->d_name - (char __user *) (de)))
./include/linux/fuse.h:342:#define FUSE_NAME_OFFSET ((unsigned) ((struct fuse_dirent *) 0)->name)


just working out different options before putting it in kernel.h

as all the dirent structures have used the 
same name for the d_name member,so we can use

#define NAME_OFFSET(dirent) ((int) ((dirent)->d_name - (char __user *) (dirent)))

but then it becomes binding on the future users
 to maintain the same naming  convention.

#define NAME_OFFSET(dirent,d_name) ((int) ((dirent)->d_name - (char __user *) (dirent)))

#define NAME_OFFSET(dirent,d_name) offsetof(struct dirent,d_name)

though ..the first one seem to be just fine

thoughts

-- 
Milind Arun Choudhary
