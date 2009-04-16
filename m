Return-Path: <linux-kernel-owner+w=401wt.eu-S1753682AbZDPOgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682AbZDPOgX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 10:36:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752501AbZDPOgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 10:36:06 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:42893 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbZDPOgD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 10:36:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=mLYxhjaMKcYdAcpNS4Su0OOEjqFGjAsVzeDlKtRVBxeAt3bVLqSa3EDXPe1lxlAUQ3
         lcZ0f3ymqljM86pomY2fj0vJrGk0wAa5Xdj6XVF3FQb7Usug8cZ/RDwI7as6InruynLQ
         ldn5NKeROt4Rqgpnrak54Vd7B07MhegQoBvA4=
MIME-Version: 1.0
In-Reply-To: <20090416085153.GC9813@elte.hu>
References: <1239680065-25013-1-git-send-email-fweisbec@gmail.com>
	 <20090414045109.GA26908@orion> <20090414090146.GH27003@elte.hu>
	 <a4423d670904151558r4252c7eamd115793fb36a9163@mail.gmail.com>
	 <20090415230736.GA22710@elte.hu> <20090415233533.GA5962@nowhere>
	 <20090416085153.GC9813@elte.hu>
Date: Thu, 16 Apr 2009 16:35:58 +0200
X-Google-Sender-Auth: 8fefe3678d569b40
Message-ID: <63a49ef40904160735w3eab9ea7s3fc5da177ee2ac87@mail.gmail.com>
Subject: Re: [tree] latest kill-the-BKL tree, v12
From: Alessio Igor Bogani <abogani@texware.it>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-nfs@vger.kernel.org,
       netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Jeff Mahoney <jeffm@suse.com>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
       Chris Mason <chris.mason@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Sir Molnar,

2009/4/16 Ingo Molnar <mingo@elte.hu>:
[...]
>> This is still the dependency between bkl and s_umount_key that has
>> been reported recently. I wonder if this is not a problem in the
>> fs layer. I should investigate on it.
>
> The problem seem to be that this NFS call context:
>
> -> #0 (kernel_mutex){+.+.+.}:
>       [<00000000004776d0>] lock_acquire+0x5c/0x74
>       [<00000000006f0ebc>] mutex_lock_nested+0x48/0x380
>       [<00000000006f32dc>] lock_kernel+0x28/0x3c
>       [<00000000006d20ec>] rpc_wait_bit_killable+0x64/0x8c
>       [<00000000006f0620>] __wait_on_bit+0x64/0xc0
>       [<00000000006f06e4>] out_of_line_wait_on_bit+0x68/0x7c
>       [<00000000006d2938>] __rpc_execute+0x150/0x2b4
>       [<00000000006d2ac0>] rpc_execute+0x24/0x34
>       [<00000000006cc338>] rpc_run_task+0x64/0x74
>       [<00000000006cc474>] rpc_call_sync+0x58/0x7c
>       [<00000000005717b0>] nfs3_rpc_wrapper+0x24/0xa0
>       [<0000000000572024>] do_proc_get_root+0x6c/0x10c
>       [<00000000005720dc>] nfs3_proc_get_root+0x18/0x5c
>       [<000000000056401c>] nfs_get_root+0x34/0x17c
>       [<0000000000568adc>] nfs_get_sb+0x9ec/0xa7c
>       [<00000000004b7ec8>] vfs_kern_mount+0x44/0xa4
>       [<00000000004b7f84>] do_kern_mount+0x30/0xcc
>       [<00000000004cf300>] do_mount+0x7c8/0x80c
>       [<00000000004ed2a4>] compat_sys_mount+0x224/0x274
>       [<0000000000406154>] linux_sparc_syscall32+0x34/0x40

Proposed patch that i just sent
(http://marc.info/?l=linux-kernel&m=123989213917572&w=2) seems fix the
lock dependency.
I don't know if it is the right way to solve the problem in any case
but it works on my laptop, at least.

Ciao,
Alessio
