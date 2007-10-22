Return-Path: <linux-kernel-owner+w=401wt.eu-S1753864AbXJVRYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864AbXJVRYg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 13:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752233AbXJVRY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 13:24:29 -0400
Received: from rn-out-0910.google.com ([64.233.170.184]:37835 "EHLO
	rn-out-0102.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751903AbXJVRY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 13:24:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=hnQRKJTyhTfSF0grlQPQXMvFn7zQmPkW73n8Hg6SBX7vZgGjSHeyOakf6ROGZaU4O00lhq3kYfigKsD21TmTsJE1yM00cqneLuoz0CsAlXQ1lW+T3EEHd3h2+jrTwaPlU5EiOT1Ymlm/7+F9ikfpwBpkV9OKt9KZNhIB+Cduxmc=
Message-ID: <2c0942db0710221024p54e59a48x32e2986e73e3de1c@mail.gmail.com>
Date: Mon, 22 Oct 2007 10:24:26 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Daniel Cid" <dcid@ossec.net>
Subject: Re: [BUG] Unable to handle kernel NULL pointer dereference
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <44003d360710221017k58ce3c2cqb2feff2939b65dae@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <44003d360710221017k58ce3c2cqb2feff2939b65dae@mail.gmail.com>
X-Google-Sender-Auth: 862ff3cb59eda7d9
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/07, Daniel Cid <dcid@ossec.net> wrote:
> Hi List,
>
> Sorry if it isn't the right place to ask this question, but I was
> reported the following error in the kernel.
>
> Syscheckd (process in the crash) is a userland (no kernel/lkm code)
> file integrity checking tool that scans the system and generates the
> md5/sha1 sum of all the files (if it helps to identify the problem).
>
> I am guessing it is a bug in the kernel, since no user process should
> cause this...
>
>
> [root@ss ossec]# uname -a
> Linux ss 2.6.9-55.0.9.ELsmp #1 SMP Thu Sep 27 18:27:41 EDT 2007 i686 i686
> i386 GNU/Linux
>
>
> Oct 19 11:39:53 ss kernel: Unable to handle kernel NULL pointer dereference
> at virtual address 00000000
> Oct 19 11:39:53 ss kernel: printing eip:
> Oct 19 11:39:53 ss kernel: c0190182
> Oct 19 11:39:53 ss kernel: *pde = 359c6001
> Oct 19 11:39:53 ss kernel: Oops: 0000 [#1]
> Oct 19 11:39:53 ss kernel: SMP
> Oct 19 11:39:53 ss kernel: Modules linked in: parport_pc lp parport autofs4
> crc32c libcrc32c iscsi_sfnet scsi_transport_iscsi i2c_dev i2c_
> core lock_dlm(U) gfs(U) lock_harness(U) dlm(U) cman(U) md5 ipv6 sunrpc button
> battery ac joydev ohci_hcd e1000 floppy sg dm_snapshot dm_zero
> dm_mirror ext3 jbd dm_mod ips mptscsih mptsas mptspi mptfc mptscsi mptbase
> sd_mod scsi_mod
> Oct 19 11:39:53 ss kernel: CPU: 3
> Oct 19 11:39:53 ss kernel: EIP: 0060:[] Not tainted VLI
> Oct 19 11:39:53 ss kernel: EFLAGS: 00010246 (2.6.9-55.0.9.ELsmp)
> Oct 19 11:39:53 ss kernel: EIP is at sysfs_readdir+0x123/0x187
> Oct 19 11:39:53 ss kernel: eax: 00000000 ebx: c7174ec0 ecx: ffffffff
> edx: 00000000
> Oct 19 11:39:53 ss kernel: esi: c7174ec4 edi: 00000000 ebp: e66758c4
> esp: f5ad3f60
> Oct 19 11:39:53 ss kernel: ds: 007b es: 007b ss: 0068
> Oct 19 11:39:53 ss kernel: Process ossec-syscheckd (pid: 4750,
> threadinfo=f5ad3000 task=f5f06eb0)
> Oct 19 11:39:53 ss kernel: Stack: bff835ac f7e63900 c016baf5 f5ad3fa0
> f4e18180 c0332640 f4e18180 f7ddb768
> Oct 19 11:39:53 ss kernel: c016baf5 c016b771 f5ad3fa0 ffffffda
> 08b499e4 f4e18180 00000000 c016bdab
> Oct 19 11:39:54 ss kernel: 08b49b2c 08b49b14 00000eb8 ffffffea
> 00000009 08b499c8 00407ff4 f5ad3000
> Oct 19 11:39:54 ss kernel: Call Trace:
> Oct 19 11:39:54 ss kernel: [] filldir64+0x0/0x11a
> Oct 19 11:39:54 ss kernel: [] filldir64+0x0/0x11a
> Oct 19 11:39:54 ss kernel: [] vfs_readdir+0x7d/0xa5
> Oct 19 11:39:54 ss kernel: [] sys_getdents64+0x80/0xba
> Oct 19 11:39:54 ss kernel: [] syscall_call+0x7/0xb
> Oct 19 11:39:54 ss kernel: [] unix_dgram_sendmsg+0x23c/0x45d
> Oct 19 11:39:54 ss kernel: Code: 04 89 69 0c 8b 75 00 8b 44 24 04 83 c0 0c 39
> c6 74 73 8d 5e fc 83 7b 14 00 74 66 89 d8 e8 07 ec ff ff 89
> c2 83 c9 ff 31 c0 89 d7 ae f7 d1 49 0f b7 43 1c c1 e8 0c 50 ff 73 20 8b 44
> 24 18 ff
> Oct 19 11:39:54 ss kernel: <0>Fatal exception: panic in 5 seconds
>
>
> A similar problem was also reported in here:
> http://lists.centos.org/pipermail/centos/2007-August/085252.html
>
> Any clues?

It's a bug, but if you tell syscheckd to ignore the /sys directory,
the problem will *probably* be avoided. (It shouldn't be checking the
integrity of the /sys directory anyway -- it's volatile just like
/proc is.)

Ray
