Return-Path: <linux-kernel-owner+w=401wt.eu-S1757822AbYHTOWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757822AbYHTOWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 10:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbYHTOWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 10:22:03 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:25400 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbYHTOWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 10:22:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=YQS2SgKPrhAf691+famlTC5QELPFZQGP2jl5/VSFLP3flk19Pm8sFiRRJrlEFzsrBx
         WpUxSBayF4KvS6JcEYk5g9WpVmLnQwok8JkkyQmHza0V1VN2kIP0VD6LoveK0GNK528X
         N1nuKcpkmjiDD5F7XMDZFrdvgEKkcSe1XVO4k=
Message-ID: <a4423d670808200721i3e9add4cn216da7991f0616f3@mail.gmail.com>
Date: Wed, 20 Aug 2008 18:21:59 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: "David Howells" <dhowells@redhat.com>
Subject: Re: [PATCH] CRED: Further fix execve error handling
Cc: jmorris@namei.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
In-Reply-To: <20080820135624.10583.99230.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080820135624.10583.99230.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/8/20 David Howells <dhowells@redhat.com>:
> Further fix [compat_]do_execve() error handling.  free_bprm() will release the
> cred_exec_mutex, but only if bprm->cred is not NULL.
>
> Signed-off-by: David Howells <dhowells@redhat.com>

David, I applied this patch and got the following.
Is it a different problem?
I think it is. If yes I will create another topic.

[   91.266507] [ INFO: possible recursive locking detected ]
[   91.266862] 2.6.27-rc3-next-20080820-dirty #3
[   91.267170] ---------------------------------------------
[   91.267522] sshd/1455 is trying to acquire lock:
[   91.267840]  (&tty->termios_mutex){--..}, at: [<00000000005b8ca0>]
tty_do_resize+0x44/0x128
[   91.268405]
[   91.268411] but task is already holding lock:
[   91.268885]  (&tty->termios_mutex){--..}, at: [<00000000005b8c74>]
tty_do_resize+0x18/0x128
[   91.269436]
[   91.269442] other info that might help us debug this:
[   91.269944] 1 lock held by sshd/1455:
[   91.270219]  #0:  (&tty->termios_mutex){--..}, at:
[<00000000005b8c74>] tty_do_resize+0x18/0x128
[   91.270812]
[   91.270818] stack backtrace:
[   91.271229] Call Trace:
[   91.271474]  [000000000047757c] __lock_acquire+0xfcc/0x1900
[   91.271839]  [0000000000477f0c] lock_acquire+0x5c/0x74
[   91.272198]  [00000000006af2a8] mutex_lock_nested+0xf0/0x310
[   91.272565]  [00000000005b8ca0] tty_do_resize+0x44/0x128
[   91.272916]  [00000000005ba3cc] tty_ioctl+0x360/0x99c
[   91.273266]  [00000000004c0050] vfs_ioctl+0x2c/0x94
[   91.273600]  [00000000004c03b4] do_vfs_ioctl+0x2fc/0x31c
[   91.273953]  [00000000004c0408] sys_ioctl+0x34/0x5c
[   91.274296]  [00000000004e98f0] do_ioctl32_pointer+0x18/0x2c
[   91.274666]  [00000000004ebb04] compat_sys_ioctl+0x3b8/0x40c
[   91.275043]  [0000000000406154] linux_sparc_syscall32+0x34/0x40
