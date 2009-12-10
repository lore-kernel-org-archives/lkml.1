Return-Path: <linux-kernel-owner+w=401wt.eu-S1759315AbZLJBDE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759315AbZLJBDE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 20:03:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752255AbZLJBC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 20:02:57 -0500
Received: from claw.goop.org ([74.207.240.146]:60987 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755330AbZLJBC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 20:02:56 -0500
Message-ID: <4B2048C6.6030307@goop.org>
Date: Wed, 09 Dec 2009 17:03:02 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091125 Fedora/3.0-3.12.rc1.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jaya Kumar <jayakumar.lkml@gmail.com>,
       Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Xen fbdev fixups
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are some small updates to fbdev to make the Xen fbdev driver work 
properly.  The bulk of the change is to make sure we only set VM_IO on 
vmas which actually map device memory, and not set it on plain old 
vmalloc memory.  This is necessary in Xen, because we end up using that 
flag to determine whether the ptes are mapping real machine physical 
memory or guest pseudo-physical memory.

We also do this on the other fbdev drivers which allocate vmalloc 
framebuffers for consistency.

Thanks,
     J

The following changes since commit 74fca6a42863ffacaf7ba6f1936a9f228950f657:
   Linus Torvalds (1):
         Linux 2.6.31

are available in the git repository at:

   git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git xen/fbdev

Konrad Rzeszutek Wilk (4):
       Fix toogle whether xenbus driver should be built as module or part of kernel.
       fb-defio: If FBINFO_VIRTFB is defined, do not set VM_IO flag.
       fb-defio: Inhibit VM_IO flag to be set on vmalloc-ed framebuffers.
       xen pvfb: Inhibit VM_IO flag to be set on vmalloc-ed framebuffers.

  drivers/input/Kconfig        |    1 +
  drivers/video/Kconfig        |    1 +
  drivers/video/broadsheetfb.c |    2 +-
  drivers/video/fb_defio.c     |    4 +++-
  drivers/video/hecubafb.c     |    2 +-
  drivers/video/metronomefb.c  |    2 +-
  drivers/video/xen-fbfront.c  |    2 +-
  include/linux/fb.h           |    1 +
  8 files changed, 10 insertions(+), 5 deletions(-)


