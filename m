Return-Path: <linux-kernel-owner+w=401wt.eu-S965461AbXDLQrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965461AbXDLQrg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 12:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965451AbXDLQrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 12:47:35 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:52733 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965148AbXDLQrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 12:47:33 -0400
Message-Id: <20070412164541.580374744@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 12 Apr 2007 18:45:41 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org, serue@us.ibm.com, viro@ftp.linux.org.uk,
       linuxram@us.ibm.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
Subject: [patch 00/10] (resend) mount ownership and unprivileged mount syscall
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds support for keeping mount ownership information in
the kernel, and allow unprivileged mount(2) and umount(2) in certain
cases.

This can be useful for the following reasons:

- mount(8) can store ownership ("user=XY" option) in the kernel
  instead, or in addition to storing it in /etc/mtab.  For example if
  private namespaces are used with mount propagations /etc/mtab
  becomes unworkable, but using /proc/mounts works fine

- fuse won't need a special suid-root mount/umount utility.  Plain
  umount(8) can easily be made to work with unprivileged fuse mounts

- users can use bind mounts without having to pre-configure them in
  /etc/fstab

Unprivileged mounts are restricted to private namespaces created with
a special clone flag.

Changes from the previous submission:

 - add namespace flag for allowing user mounts
 - add clone flag to set above namespace flag
 - make max number of user mounts default to 1024, since now the
   namespace flag will prevent user mounts by default

--
