Return-Path: <linux-kernel-owner+w=401wt.eu-S1755553AbYFSCdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbYFSCdS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 22:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751596AbYFSCdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 22:33:10 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:23126 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbYFSCdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 22:33:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=ctel8SOum9GhicfL6ufJNfAiRB4nh1wTBtQ27rqIkRpImq2KGTeQbTNWgCHY+4uZmX
         /vvgLVYJvdOwsAB5HiKg7QdpPphIN3o9CZT9StU20gw8s3IrCq8PYN1mO8sdXFQKb+HV
         W33sljy2pTgQFl1cglbNm8JDLHX18pgIAq4XM=
Message-ID: <6278d2220806181933l74719bdbkea02f697ee424157@mail.gmail.com>
Date: Thu, 19 Jun 2008 03:33:08 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Ian Soboroff" <isoboroff@gmail.com>
Subject: Re: Oops in NFS (RHEL4, but also in kernel bugzilla)
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ian,

On 17 Jun, 17:10, Ian Soboroff <isoboroff@gmail.com> wrote:
> I have a server that hosts some large XFS filesystems and serves them
> out over NFS.  Every so often I get the following Oops, and then the
> machine locks hard with blinky keyboard lights.  ("Every so often" == I
> can't reproduce this reliably.  It comes up about once a week, we've
> seen it three times.)
>
> Unable to handle kernel NULL pointer dereference at virtual address 00000000
>  printing eip:
> 00000000
> *pde = 355bf001
> Oops: 0000 [#1]
> SMP
> Modules linked in: nfs nfsd exportfs lockd nfs_acl md5 ipv6 parport_pc lp parport autofs4 i2c_dev i2c_core sunrpc button battery ac ohci_hcd tg3 floppy dm_snapshot dm_zero dm_mirror ext3 jbd dm_mod aacraid aic7xxx sd_mod scsi_m
> od
> CPU:    0
> EIP:    0060:[<00000000>]    Not tainted VLI
> EFLAGS: 00010282   (2.6.9-67.0.15.ELirsmp)
> EIP is at 0x0
> eax: e1c86c30   ebx: c04ba260   ecx: 00000000   edx: d820304c
> esi: d820304c   edi: f6ecbf00   ebp: 00000000   esp: f6ecbee4
> ds: 007b   es: 007b   ss: 0068
> Process nfsd (pid: 4339, threadinfo=f6ecb000 task=f6c470b0)
> Stack: c0168c5f e1c86c30 ffffffff f5f96090 60229cac cc751afc c0168cd3 60229cac
>        00000008 f5f96088 e1c86ca0 e1c86ca0 e1c86c30 cc751afc f5f95004 f8bcee28
>        f5f96088 f7e6ba00 f7d351c0 f7e6ba00 f8b2b46a f5f95800 f5f95000 f5f951d4
> Call Trace:
>  [<c0168c5f>] __lookup_hash+0x70/0x89
>  [<c0168cd3>] lookup_one_len+0x54/0x63
>  [<f8bcee28>] nfsd_lookup+0x321/0x3ad [nfsd]
>  [<f8b2b46a>] svcauth_unix_set_client+0xa7/0xb5 [sunrpc]
>  [<f8bd6b49>] nfsd3_proc_lookup+0xa9/0xb3 [nfsd]
>  [<f8bd8b37>] nfs3svc_decode_diropargs+0x0/0xfa [nfsd]
>  [<f8bcc681>] nfsd_dispatch+0xba/0x16d [nfsd]
>  [<f8b2862d>] svc_process+0x444/0x6f3 [sunrpc]
>  [<f8bcc45a>] nfsd+0x1cc/0x339 [nfsd]
>  [<f8bcc28e>] nfsd+0x0/0x339 [nfsd]
>  [<c01041f5>] kernel_thread_helper+0x5/0xb
> Code:  Bad EIP value.
>  <0>Fatal exception: panic in 5 seconds

Has 4KB stacks been disabled? You can check the config file for CONFIG_4KSTACKS.

It may also be worth feeding that into the bugzilla entry, to
eliminate one possibility, as 'bad EIP value' looks suspicious of
stack corrption.

Daniel

> This machine is running RHEL4, using the stock kernel but with XFS
> enabled.  I would have reported it to Redhat instead, but in googling
> around found a nearly identical kernel bugzilla report:
>
> http://bugzilla.kernel.org/show_bug.cgi?id=7809
>
> In there, the bug reporter has tracked the Oops to __lookup_hash() in
> fs/namei.c, and includes a patch which basically just takes care to not
> dereference inode->i_op->lookup without checking it first.
>
> I looked at the latest fs/namei.c via gitweb and it's the same code.  So
> here I am reporting it here, where more knowledgable and responsive
> people lurk anyway.
>
> Is this a NFS problem, or an XFS one?  (Since XFS is common in both my
> report and in the bugzilla one... I'm not sure whether the 'inode' in
> question is NFS or from the underlying filesystem).
>
> Is the bugzilla report's patch papering over a real problem, or does it
> fix a real possible null-pointer case in __lookup_hash?
>
> Thanks,
> Ian
-- 
Daniel J Blueman
