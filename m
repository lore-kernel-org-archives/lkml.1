Return-Path: <linux-kernel-owner+w=401wt.eu-S1161394AbXBZXE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161394AbXBZXE0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 18:04:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161399AbXBZXEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 18:04:25 -0500
Received: from wr-out-0506.google.com ([64.233.184.236]:9122 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161394AbXBZXEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 18:04:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=LtQo34xsdVX9YoEFgmr3Xu4N4IRopfokehq8Dd1Z7bOzrnqThB5iThz0ooHNeA6M/KY+1gBovGsRqe82s2fDon8l8HDaab4/CKwLwVgP81GQb32nkEu8KNvLudD9QRuDnkAY7llyQy2+vOGmmbDreto6Ni2iEBj0yxgD2RA1L2s=
Message-ID: <9a8748490702261504n147aa444y779153c03a2d44a2@mail.gmail.com>
Date: Tue, 27 Feb 2007 00:04:19 +0100
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Hang when shutting down - seems umount and NFS related - kernel version 2.6.18.1
Cc: nfs@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have a server that has the sole job of serving up a bunch of NFS
filesystems to webservers. The server is running kernel 2.6.18.1

A few days ago when attempting to reboot the server, the shutdown
process hung with a backtrace on the console. A photo was taken and is
available here:
  http://www.kernel.org/pub/linux/kernel/people/juhl/images/DSC00504.jpg

A quick (incomplete) text transcript of the photo is here:

EIP: [<c01a51a0>] nfs_clear_inode+0x61/0x6b SS:ESP 0068:eb476ee4
BUG: warning at kernel/exit.c:855/do_exit()
 do_exit			do_trap
 do_trap			do_invalid_op
 do_invalid_op			nfs_clear_inode
 scheduler_tick			radix_tree_gang_lookup_tag
 nfs_wait_on_reques_locked	error_code
 nfs3_forget_cached_acls	nfs_clear_inode
 clear_inode			dispose_list
 invalidate_inodes		generic_shutdown_super
 kill_anon_super		nfs_kill_super
 deactivate_super		sys_umount
 sys_readlink			syscall_call
BUG: umount/20593, lock held at task exit time!
  {alloc_super}
.. held by:  umount:20593
... acquired at:     generic_shutdown_super
/etc/rc6.d/S01reboot: line4: 20593 Segmentation fault      $*
                                                          [FAILED]
Unmounting filesystems (retry):

The problem has only manifested itself this once, so unfortunately not
reproducible on demand, but I hope that maybe someone more
knowledgable of NFS internals than me can figure out what went wrong
and a way to fix it in the future (if it's not already fixed) :-)

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
