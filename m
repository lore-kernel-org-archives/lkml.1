Return-Path: <linux-kernel-owner+w=401wt.eu-S1762914AbZFKLxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762914AbZFKLxU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 07:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797AbZFKLxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 07:53:12 -0400
Received: from smtp-out.google.com ([216.239.33.17]:17321 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbZFKLxL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 07:53:11 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=aUP5Ai8O/KiYr7XS8/178wDNEpw/9/n+Y1qCaHRWA95iT4pwO1aUMlJEQ71syriO/
	iPKA9GBVyudTUPUvGpVWQ==
MIME-Version: 1.0
In-Reply-To: <20090611114825.GD7523@elf.ucw.cz>
References: <20090610103131.GB13885@elf.ucw.cz>
	 <a55d774e0906101043q580fc5e5iad25a79203dc52c@mail.gmail.com>
	 <20090611081012.GD8592@elf.ucw.cz>
	 <a55d774e0906110127k1633dd90x96863c3dd6f888cf@mail.gmail.com>
	 <20090611110946.GA7523@elf.ucw.cz>
	 <a55d774e0906110424q631c83d5l5a5ba8bc0a1093b8@mail.gmail.com>
	 <20090611114825.GD7523@elf.ucw.cz>
Date: Thu, 11 Jun 2009 04:53:10 -0700
Message-ID: <a55d774e0906110453g517d11of810e951a4a894f@mail.gmail.com>
Subject: Re: HTC Dream aka. t-mobile g1 support
From: Brian Swetland <swetland@google.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       san@android.com, rlove@google.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 4:48 AM, Pavel Machek<pavel@ucw.cz> wrote:
>>
>> You'll need to fastboot boot arch/arm/boot/zImage ramdisk.img
>
> Aha, fastboot implies that ramdisk is optional.. apparently it is not.

Well, it *is* optional -- but the kernel as we build it needs an
initrd to do much that's visible.  Could probably enable fb console
and provide a commandline that points console there (-c "kernel
commandline"  argument to fastboot).

>> Extracting the ramdisk.img from the boot.img in the boot partition on
>> an existing device is a pain.  If you happen to have a cupcake
>> userspace built from source that ramdisk.img should be suitable.  If
>> not, I'll try to dig up a suitable ramdisk image tomorrow -- it's just
>> init, init.rc, and adb, but it is necessary to boot.
>
> I tried using ramdisk.img from sdk:
>
> root@amd:/data/l/android# ./fastboot boot
> /data/l/linux-msm/arch/arm/boot/uImage
> /data/l/android/sdk/platforms/android-1.5/images/ramdisk.img
>
> ...no luck :-(.

Is a uImage compatible with zImage (if the bootloader copies it to
0x10008000 and jumps there will it start?)

> Better Kconfig description would certainly be nice. Renaming
> board-trout* to board-dream* would be also nice (and should be doable
> without any intrusive changes...?)

Ah, I see.  Yes, renaming the files would be easy to do and that's
totally reasonable.  I thought you wanted the machine type name
changed.

Brian
