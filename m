Return-Path: <linux-kernel-owner+w=401wt.eu-S1758103AbYBLBBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103AbYBLBBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 20:01:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752174AbYBLBBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 20:01:04 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:39156 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbYBLBBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 20:01:01 -0500
Message-ID: <47B0EEB8.7060701@ak.jp.nec.com>
Date: Tue, 12 Feb 2008 09:56:24 +0900
From: Kohei KaiGai <kaigai@ak.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: "Andrew G. Morgan" <morgan@kernel.org>
CC: "Serge E. Hallyn" <serue@us.ibm.com>, akpm@osdl.org, jmorris@namei.org,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH] exporting capability code/name pairs (try #4)
References: <47997122.3070504@ak.jp.nec.com> <479990A1.3050103@kernel.org> <4799CAE0.7010400@ak.jp.nec.com> <47A2AB60.5000403@ak.jp.nec.com> <20080204162103.GA20130@sergelap.ibm.com> <47A91B00.9080301@ak.jp.nec.com> <20080206050805.GD3258@sergelap.austin.ibm.com> <47AC23F1.5030300@ak.jp.nec.com> <47AC87E1.7090803@kernel.org>
In-Reply-To: <47AC87E1.7090803@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew G. Morgan wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> KaiGai,
> 
> Thanks for trying to accommodate me :-)
> 
> Kohei KaiGai wrote:
> | In addition, Andrew suggested me to export these translation by symlinks
> | to reduce the number of invocation of system call.
> 
> Yes, I wanted to make use of readlink() instead of open()/read()/close()
> to access each unknown capability.
> 
> | However, current sysfs interface does not allows to create symlinks with
> | invalid indication.
> 
> :-(
> 
> | Thus, this patch exports them as regular files.
> 
> What about using symlinks for the name files and text content for the
> numeric ones? You could even drop the names/ and codes/ subdirectories too:
> 
> $ cat /sys/kernel/capability/20
> cap_sys_pacct
> $ ls -l /sys/kernel/capability/cap_mknod
> lr--r--r--  1 root root 64 Feb  8 08:26 cap_mknod -> 27
> $ cat /sys/kernel/capability/names/cap_mknod
> cap_mknod

Sysfs does not support to create symbolic links to regular files now.

The sysfs_create_link() is a function to create a symbolic link on sysfs.
However, it requires two kobjects as its arguments. One is to specify its
parent directory, the other is to specify the target of indirection.
It means the indicated target have to be a directory.

At include/linux/sysfs.h:
int __must_check sysfs_create_link(struct kobject *kobj, struct kobject *target,
                                    const char *name);

Please tell me, if I have any misunderstandings.

Thanks,
-- 
OSS Platform Development Division, NEC
KaiGai Kohei <kaigai@ak.jp.nec.com>
