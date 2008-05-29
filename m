Return-Path: <linux-kernel-owner+w=401wt.eu-S1758308AbYE2Qj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758308AbYE2Qj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 12:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752134AbYE2QjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 12:39:13 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:53992 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758194AbYE2QjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 12:39:12 -0400
X-Greylist: delayed 1501 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 May 2008 12:39:11 EDT
Date: Thu, 29 May 2008 13:14:01 -0300
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: casey@schaufler-ca.com
Cc: miklos@szeredi.hu, linux-kernel@vger.kernel.org
Subject: 2.6.24-rc4: mount.ntfs-3g hangs when smack is enabled
Message-ID: <20080529131401.7429568d@mandriva.com.br>
Organization: Mandriva
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 Hi Casey,

 I'm not sure whether this is a smack problem, but Mandriva users are
reporting that mount.ntfs-3g (ntfs driver, uses FUSE) hangs when
they try to mount their NTFS partition.

 I could reproduce the problem with a vanilla 2.6.24-rc4 kernel, and it
only happens when Smack is enabled.

 Besides that, I've been told that a similar problem happens with unionfs,
but I haven't tried to reproduce it yet.

 What follows is the output of SysRq+D:

"""
Showing all locks held in the system:
1 lock held by mingetty/4193:
 #0:  (&tty->atomic_read_lock){--..}, at: [<c0229650>] read_chan+0x1e5/0x605
1 lock held by mingetty/4194:
 #0:  (&tty->atomic_read_lock){--..}, at: [<c0229650>] read_chan+0x1e5/0x605
1 lock held by mingetty/4195:
 #0:  (&tty->atomic_read_lock){--..}, at: [<c0229650>] read_chan+0x1e5/0x605
1 lock held by mingetty/4196:
 #0:  (&tty->atomic_read_lock){--..}, at: [<c0229650>] read_chan+0x1e5/0x605
1 lock held by mingetty/4197:
 #0:  (&tty->atomic_read_lock){--..}, at: [<c0229650>] read_chan+0x1e5/0x605
2 locks held by mount.ntfs-3g/4667:
 #0:  (&type->s_umount_key#19){--..}, at: [<c01726f0>] sget+0x202/0x350
 #1:  (&isp->smk_lock){--..}, at: [<c01c7f87>] smack_d_instantiate+0x39/0x129
1 lock held by bash/4844:
 #0:  (&tty->atomic_read_lock){--..}, at: [<c0229650>] read_chan+0x1e5/0x605
1 lock held by bash/5389:
 #0:  (&tty->atomic_read_lock){--..}, at: [<c0229650>] read_chan+0x1e5/0x605
1 lock held by bash/5498:
 #0:  (&tty->atomic_read_lock){--..}, at: [<c0229650>] read_chan+0x1e5/0x605
"""

 Let me know if you need more information.

 Best regards.

-- 
Luiz Fernando N. Capitulino
