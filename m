Return-Path: <linux-kernel-owner+w=401wt.eu-S965528AbXEHQlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965528AbXEHQlP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 12:41:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934310AbXEHQlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 12:41:13 -0400
Received: from wr-out-0506.google.com ([64.233.184.237]:38396 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934152AbXEHQlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 12:41:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rfgz2U5bqHI7aMfYdVmo9UhwBskc1yjLZF0FRWWjRi08QHTwbYW1nFYEncC95SN/SuMvJcKhiNNeIyGLBQbDS2P40XR4czG+yRiI1FV2H9miK5rPDq70aLCHMCRYPwKbLTgMWBTY2TR9y0dISy/Y5FU8ysaQwU36MsROXh55VhA=
Message-ID: <86802c440705080941y69ddd5d6lab170c5f3967f148@mail.gmail.com>
Date: Tue, 8 May 2007 09:41:09 -0700
From: yhlu <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for relocatable bzImage
Cc: vgoyal@in.ibm.com, "H. Peter Anvin" <hpa@zytor.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Gerd Hoffmann" <kraxel@redhat.com>, "Jeff Garzik" <jeff@garzik.org>,
       patches@x86-64.org, linux-kernel@vger.kernel.org,
       virtualization <virtualization@lists.linux-foundation.org>
In-Reply-To: <m1tzuuv24z.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4634483E.9030307@goop.org> <46385A8A.6070405@redhat.com>
	 <4638AB55.20408@goop.org> <4638F9BE.8090508@zytor.com>
	 <4638FC39.4010101@goop.org> <4638FE1B.9050901@zytor.com>
	 <46390523.5010809@goop.org> <463909AF.9040205@zytor.com>
	 <20070503045031.GA5794@in.ibm.com>
	 <m1tzuuv24z.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/2/07, Eric W. Biederman <ebiederm@xmission.com> wrote:
> Vivek Goyal <vgoyal@in.ibm.com> writes:
>
> > On Wed, May 02, 2007 at 02:59:11PM -0700, H. Peter Anvin wrote:
> >> Jeremy Fitzhardinge wrote:
> >> >
> >> > So the bzImage structure is currently:
> >> >
> >> >    1. old-style boot sector
> >> >    2. old-style boot info, followed by 0xaa55 at the end of the sector
> >> >    3. the HdrS boot param block
> >> >    4. setup.S boot code
> >> >    5. the self-decompressing kernel
> >> >

Eric,

With the latest change that make vmlinux to be elf64 and make bzImage
do switch to 64bit long mode, the kernel started via kexec can not get
VGA console. but the serial console works well. I wonder if the
setup.S is skipped in bzImage via kexec path.

or i missed sth?

#!/bin/bash
./kexec -t bzImage -l bzImage_2.6.22_k8.1 --command-line="apic=debug
acpi_dbg_level=0x00000007 pci=routeirq snd-hda-intel.enable_msi=1
ramdisk_size=65536 root=/dev/ram0 rw ip=dhcp console=tty0
console=ttyS0,9600n8" --ramdisk=mydisk8_x86_64.gz


YH
