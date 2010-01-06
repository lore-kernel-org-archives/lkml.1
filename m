Return-Path: <linux-kernel-owner+w=401wt.eu-S1754840Ab0AFAz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab0AFAz4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 19:55:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753853Ab0AFAzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 19:55:55 -0500
Received: from mail-iw0-f194.google.com ([209.85.223.194]:64374 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844Ab0AFAzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 19:55:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=oyFWi5Qt9brzWfw04I5ElVJnSBiAKtuUKZZG7SQzWII4RFPf/MHrFUytZVCg5eZFSk
         uIt24Jxu5qnMQ6lkyDETYJddIIK9Kz/fjj+gF/y+FK29SOQW4IY1y1/D+nOQ7/e84dbV
         1kfwIdcaFYGZRYyGVGcWo1JGiMz3iOXBznI+o=
Message-ID: <4B43DF97.7080208@gmail.com>
Date: Tue, 05 Jan 2010 18:55:51 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Anders Eriksson <aeriksson@fastmail.fm>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: Memory probing fails after 2.6.30 (bisected)
References: <20100105110256.D2DF133C4B0@tippex.mynet.homeunix.org>
In-Reply-To: <20100105110256.D2DF133C4B0@tippex.mynet.homeunix.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2010 05:02 AM, Anders Eriksson wrote:
>
> Hi,
>
> Upgrading my laptop's kernel, I discovered that it reboots immediately after
> boot on .31 and later kernels. Grub loads it, but I cannot get one line of
> text out of it before it reboots, even using boot_delay.
>
> Bisecting I came up with the following:
>
> git bisect start
> # good: [07a2039b8eb0af4ff464efd3dfd95de5c02648c6] Linux 2.6.30
> git bisect good 07a2039b8eb0af4ff464efd3dfd95de5c02648c6
> # bad: [74fca6a42863ffacaf7ba6f1936a9f228950f657] Linux 2.6.31
> git bisect bad 74fca6a42863ffacaf7ba6f1936a9f228950f657
> # bad: [925d74ae717c9a12d3618eb4b36b9fb632e2cef3] V4L/DVB (11736): videobuf: modify return value of VIDIOC_REQBUFS ioctl
> git bisect bad 925d74ae717c9a12d3618eb4b36b9fb632e2cef3
> # bad: [e349792a385ed47390d156155b1a1e19af1bf163] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6
> git bisect bad e349792a385ed47390d156155b1a1e19af1bf163
> # bad: [c9059598ea8981d02356eead3188bf7fa4d717b8] Merge branch 'for-2.6.31' of git://git.kernel.dk/linux-2.6-block
> git bisect bad c9059598ea8981d02356eead3188bf7fa4d717b8
> # bad: [59c288ffb6dfb55bdd6bfe6826ab6203ff791930] Merge branches 'frv' and 'mn10300'
> git bisect bad 59c288ffb6dfb55bdd6bfe6826ab6203ff791930
> # bad: [3f6280ddf25fa656d0e17960588e52bee48a7547] Merge branch 'iommu-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
> git bisect bad 3f6280ddf25fa656d0e17960588e52bee48a7547
> # good: [c44e3ed539e4fc17d6bcb5eaecb894a94de4cc5f] Merge branch 'x86-cpu-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
> git bisect good c44e3ed539e4fc17d6bcb5eaecb894a94de4cc5f
> # bad: [be15f9d63b97da0065187696962331de6cd9de9e] Merge branch 'x86-xen-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
> git bisect bad be15f9d63b97da0065187696962331de6cd9de9e
> # bad: [9b29e8228a5c2a169436a1a90a60b1f88cb35cd1] Merge branch 'x86-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
> git bisect bad 9b29e8228a5c2a169436a1a90a60b1f88cb35cd1
> # bad: [35d5a9a61490bf39d2e48d7f499c8c801a39ebe9] x86: fix system without memory on node0 --->  Got a BIOS-88 map
> git bisect bad 35d5a9a61490bf39d2e48d7f499c8c801a39ebe9
> # bad: [45fbe3ee01b8e463b28c2751b5dcc0cbdc142d90] x86, e820, pci: reserve extra free space near end of RAM --->  Got a BIOS-88 map
> git bisect bad 45fbe3ee01b8e463b28c2751b5dcc0cbdc142d90
> # bad: [2b72394e4089643f11669d9610907a1442fe044a] x86: move max_pfn_mapped and max_low_pfn_mapped to setup.c --->  Got a BIOS-88 map
> git bisect bad 2b72394e4089643f11669d9610907a1442fe044a
> # good: [6424fb38667fffbbb1b90be0ffd9a0c540db6a4b] x86: remove (null) in /sys kernel_page_tables
> git bisect good 6424fb38667fffbbb1b90be0ffd9a0c540db6a4b
> # bad: [89388913f2c88a2cd15d24abab571b17a2596127] x86: unify noexec handling -->  Got a BIOS-88 map
> git bisect bad 89388913f2c88a2cd15d24abab571b17a2596127
> # bad: [8ecee4620e76aae418bfa0e8cc830e92cb559bbb] Merge branch 'linus' into x86/mm --->  Got a BIOS-88 map
> git bisect bad 8ecee4620e76aae418bfa0e8cc830e92cb559bbb
>
>

Think you missed posting which was the actual bad commit it reported?
