Return-Path: <linux-kernel-owner+w=401wt.eu-S967009AbZLIAjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967009AbZLIAjJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 19:39:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966989AbZLIAjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 19:39:04 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:64857 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966953AbZLIAjD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 19:39:03 -0500
MIME-Version: 1.0
In-Reply-To: <20091208224550.GA26915@n2100.arm.linux.org.uk>
References: <20091208102842.GH12264@elf.ucw.cz>
	 <20091208224550.GA26915@n2100.arm.linux.org.uk>
Date: Tue, 8 Dec 2009 16:39:09 -0800
Message-ID: <d6200be20912081639mdd853bg4080f415116d018c@mail.gmail.com>
Subject: Re: GPIO support for HTC Dream
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>,
       Daniel Walker <dwalker@codeaurora.org>,
       Iliyan Malchev <malchev@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 8, 2009 at 2:45 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Tue, Dec 08, 2009 at 11:28:43AM +0100, Pavel Machek wrote:
>> Add GPIO support for HTC Dream.
>>
>> Signed-off-by: Pavel Machek <pavel@ucw.cz>
>>
>> diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
>> index f780086..774c50e 100644
>> --- a/arch/arm/mach-msm/Kconfig
>> +++ b/arch/arm/mach-msm/Kconfig
>> @@ -40,4 +40,8 @@ config MACH_TROUT
>>       help
>>         Support for the HTC Dream, T-Mobile G1, Android ADP1 devices.
>>
>> +config GENERIC_GPIO
>> +     bool
>> +     default y
>
> Please arrange for this to be handled just like every other ARM
> platform via a 'select' statement - eg:
>
> config ARCH_AT91
>        bool "Atmel AT91"
>        select GENERIC_GPIO
>        select ARCH_REQUIRE_GPIOLIB
>        select HAVE_CLK
>
> It is not nice to have multiple definitions of the same symbol scattered
> throughout the Kconfig files.
>

Why did this code get pulled into the dream gpio code? The original
change that adds msm gpio support already selects GENERIC_GPIO
(http://android.git.kernel.org/?p=kernel/msm.git;a=commit;h=5ae9f4403530a5782478c35d29753081750c4188).
Since you copied half of the files from that change anyway, it would
be better to just include that change in you patch set.

-- 
Arve Hjønnevåg
