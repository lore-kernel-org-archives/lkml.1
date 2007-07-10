Return-Path: <linux-kernel-owner+w=401wt.eu-S1764086AbXGJVKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764086AbXGJVKf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 17:10:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754776AbXGJVKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 17:10:20 -0400
Received: from gate.crashing.org ([63.228.1.57]:59314 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752956AbXGJVKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 17:10:19 -0400
In-Reply-To: <4693EF48.1080209@zytor.com>
References: <11840359321823-git-send-email-hpa@zytor.com> <11840373002601-git-send-email-hpa@zytor.com> <108510B6-B9BE-49D4-BDCA-E25CA20CB29B@kernel.crashing.org> <200707101721.58937.ak@suse.de> <D6BECE27-25FA-4914-B293-4070392258D2@kernel.crashing.org> <4693EF48.1080209@zytor.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <763AC431-73A6-4A5F-9453-A66A86D7DEEB@kernel.crashing.org>
Cc: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org
Content-Transfer-Encoding: 7bit
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [x86 setup 13/33] Header file to produce 16-bit code with gcc
Date: Tue, 10 Jul 2007 23:10:05 +0200
To: "H. Peter Anvin" <hpa@zytor.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> It seems to me GCC should grow an option to insert .code16gcc
>> by itself (-m16 perhaps?)

> -m16 is the right thing,

Probably not actually, -m16 might have 16-bit "int" etc.
-mabi=16 is closer to what other architectures do here.

> and it also provides a proper hook for
> eventually having a real 16-bit backend (there are at least two  
> projects
> for doing that.)

Those would use -m16, yes.

> For now, I have:
>
> CFLAGS          := $(LINUXINCLUDE) -g -Os -D_SETUP -D__KERNEL__ \
>                    $(cflags-$(ARCH)) \
>                    -Wall -Wstrict-prototypes \
>                    -march=i386 -mregparm=3 \
>                    -include $(srctree)/$(src)/code16gcc.h \
>                    -fno-strict-aliasing -fomit-frame-pointer \
>                    $(call cc-option, -ffreestanding) \
>                    $(call cc-option, -fno-unit-at-a-time) \
>                    $(call cc-option, -fno-toplevel-reorder) \
>                    $(call cc-option, -fno-stack-protector) \
>                    $(call cc-option, -mpreferred-stack-boundary=2)
>
> ... since that will require less violence to eventually hack in the
> proper -m16 option if/when it becomes available.

Looks good, except you don't want -fno-unit-at-a-time if
-fno-toplevel-reorder works.  And of course it would be
good to get rid of -fno-strict-aliasing, but let's not
go there today ;-P


Segher

