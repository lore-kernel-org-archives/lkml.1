Return-Path: <linux-kernel-owner+w=401wt.eu-S1755273AbZICMOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273AbZICMOz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 08:14:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755177AbZICMOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 08:14:54 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:45400 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754711AbZICMOx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 08:14:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ovKNXi093Rl5WTariRCfoO2LfQ/FDqhqOg8mWLXTrOHKIB0DF4pOyr7E1Jv9JzpUeT
         gb2RwCwvDqRuLRIYZj1z/bkKzrs+vbJ0j9hbDZNHc1+gWLHRWBuxcxtVCmCu3lNsDcSs
         CVq6Pqf450YKy1sfnfNrP8UYlPGJs6+hHW+aA=
MIME-Version: 1.0
In-Reply-To: <20090903113428.GA6986@craig-wood.com>
References: <20090903113428.GA6986@craig-wood.com>
Date: Thu, 3 Sep 2009 15:14:55 +0300
X-Google-Sender-Auth: 36fd24d4e7d4d9a9
Message-ID: <84144f020909030514k1d9fe596pf2c4d8ffa45f7af@mail.gmail.com>
Subject: Re: Reading /proc/kcore causes a BUG()
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Nick Craig-Wood <nick@craig-wood.com>
Cc: linux-kernel@vger.kernel.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 3, 2009 at 2:34 PM, Nick Craig-Wood<nick@craig-wood.com> wrote:
> Is a fix for this going to make 2.6.31?
>
> To replicate
>
>  cat /proc/kcore >/dev/null
>
> See also
>
>  http://bugzilla.kernel.org/show_bug.cgi?id=13850
>
> To get
>
> BUG: unable to handle kernel paging request at eda08000
> IP: [<c01a0e98>] read_kcore+0x27f/0x341
> *pdpt = 0000000071809027
> Oops: 0000 [#1] SMP
> last sysfs file: /sys/class/net/lo/operstate
>
> Pid: 2361, comm: cat Not tainted (2.6.31.git-x1 #1)
> EIP: 0061:[<c01a0e98>] EFLAGS: 00010286 CPU: 1
> EIP is at read_kcore+0x27f/0x341
> EAX: c04404fc EBX: 00001000 ECX: 00000400 EDX: eda09000
> ESI: eda08000 EDI: ec129000 EBP: ec60bf48 ESP: ec60bf10
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0069
> Process cat (pid: 2361, ti=ec60a000 task=ecf800b0 task.ti=ec60a000)
> Stack:
>  00001000 08051000 00000000 00001000 00000003 eda08000 ec129000 c04404fc
> <0> eda09000 00000000 00001000 ecd39380 fffffffb c01a0c19 ec60bf6c c019a907
> <0> ec60bf98 00001000 08051000 eccbab00 eccbab00 c019a8af 00001000 ec60bf8c
> Call Trace:
>  [<c01a0c19>] ? read_kcore+0x0/0x341
>  [<c019a907>] ? proc_reg_read+0x58/0x6c
>  [<c019a8af>] ? proc_reg_read+0x0/0x6c
>  [<c016905e>] ? vfs_read+0x87/0x110
>  [<c0169180>] ? sys_read+0x3b/0x60
>  [<c0106a4d>] ? syscall_call+0x7/0xb
> Code: d3 29 f3 89 f8 29 f0 39 d7 0f 46 d8 8d 0c 33 89 4d e8 29 5d ec 8b 45 e4 f6 40 0c 01 75 18 89 d9 c1 e9 02 89 f7 2b 7d dc 03 7d e0 <f3> a5 89 d9 83 e1 03 74 02 f3 a4 8b 55 e4 8b 12 89 55 e4 83 7d
> EIP: [<c01a0e98>] read_kcore+0x27f/0x341 SS:ESP 0069:ec60bf10
> CR2: 00000000eda08000
> ---[ end trace 4387f828fd1590eb ]---
>
> I tried this on the latest git checkout (as of 2009-09-03 11:00 GMT)
> under Xen as a domU.  The bugzilla report states it happens on non xen
> machines also.
>
> I know reading /proc/kcore isn't such a good idea, but badly written
> backup scripts are triggering this on our customer's servers :-(

AFAICT the bug was fixed but I can't seem to find the patches in
Linus' git either. Lets CC Andrew and Hiroyuki-san.

                        Pekka
