Return-Path: <linux-kernel-owner+w=401wt.eu-S933775AbZHGU1E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933775AbZHGU1E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 16:27:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933707AbZHGU1C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 16:27:02 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55481 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933685AbZHGU1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 16:27:01 -0400
Message-ID: <4A7C8CD3.1090404@zytor.com>
Date: Fri, 07 Aug 2009 13:21:39 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Albin Tonnerre <albin.tonnerre@free-electrons.com>,
       Matthieu CASTET <matthieu.castet@parrot.com>,
       Alain Knaff <alain@knaff.lu>, "sam@ravnborg.org" <sam@ravnborg.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-embedded@vger.kernel.org" <linux-embedded@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/6] Add support for LZO-compressed kernels for ARM
References: <1249311501-23102-3-git-send-email-albin.tonnerre@free-electrons.com> <1249311501-23102-4-git-send-email-albin.tonnerre@free-electrons.com> <20090806224055.GH31579@n2100.arm.linux.org.uk> <20090807092423.GA4455@laptop> <4A7BF5B8.4030907@knaff.lu> <20090807102117.GB4455@laptop> <4A7C14EB.1060701@parrot.com> <20090807130130.GE4455@laptop> <4A7C2BA4.7030408@parrot.com> <20090807135524.GF4455@laptop> <20090807200001.GE31543@n2100.arm.linux.org.uk>
In-Reply-To: <20090807200001.GE31543@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2009 01:00 PM, Russell King - ARM Linux wrote:
> On Fri, Aug 07, 2009 at 03:55:24PM +0200, Albin Tonnerre wrote:
>> That's true for the actual kernel image, but not for the bootstrap code we use
>> when compiling compressed kernels. arch/arm/boot/compressed/Makefile uses
>> libgcc, unless I'm overlooking something here:
>>
>>   arm-unknown-linux-uclibcgnueabi-ld -EL    --defsym zreladdr=0x20008000
>>   --defsym initrd_phys=0x20410000 --defsym params_phys=0x20000100 -p
>>   --no-undefined -X
>>   /home/albin/x-tools/arm-unknown-linux-uclibcgnueabi/lib/gcc/arm-unknown-linux-uclibcgnueabi/4.3.2/libgcc.a
>>   -T arch/arm/boot/compressed/vmlinux.lds arch/arm/boot/compressed/head.o
>>   arch/arm/boot/compressed/piggy.gzip.o arch/arm/boot/compressed/misc.o -o
>>   arch/arm/boot/compressed/vmlinux
> 
> It's because libgcc appears in the wrong place in the command line, and
> due to the way kbuild works, we can't get it into the right place easily.
> 
> Linkers are sensitive to the order of archives on the command line - its
> pointless having an archive as the first file argument because none of
> the contained objects will ever be pulled in.
> 
> Sam - any ideas how to solve this?

Can we use the group feature of ld for this?

	-hpa

