Return-Path: <linux-kernel-owner+w=401wt.eu-S1762833AbZLKXu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762833AbZLKXu1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:50:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761661AbZLKXuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:50:20 -0500
Received: from exprod6ob113.obsmtp.com ([64.18.1.30]:57443 "EHLO psmtp.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761650AbZLKXuT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:50:19 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: GPIO support for HTC Dream
Date: Fri, 11 Dec 2009 18:50:25 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901FB1100@mi8nycmail19.Mi8.com>
In-Reply-To: <20091211232838.GE12628@n2100.arm.linux.org.uk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: GPIO support for HTC Dream
Thread-Index: Acp6ub5I2J438JcTTrujzNk3VafjbwAAaCtQ
References: <20091208102842.GH12264@elf.ucw.cz> <4B1EB57D.6070408@bluewatersys.com> <20091208214658.GC4164@elf.ucw.cz> <4B1ECEEE.3000209@bluewatersys.com> <4B203575.6050407@bluewatersys.com> <20091210172458.GJ19454@elf.ucw.cz> <4B2150B7.3040207@bluewatersys.com> <BD79186B4FD85F4B8E60E381CAEE190901FB0F92@mi8nycmail19.Mi8.com> <20091211221015.GB24456@elf.ucw.cz> <20091211232838.GE12628@n2100.arm.linux.org.uk>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
       "Pavel Machek" <pavel@ucw.cz>
Cc: "Daniel Walker" <dwalker@codeaurora.org>,
       "Iliyan Malchev" <malchev@google.com>,
       "Brian Swetland" <swetland@google.com>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "Ryan Mallon" <ryan@bluewatersys.com>,
       "Arve Hj?nnev?g" <arve@android.com>,
       "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>
X-OriginalArrivalTime: 11 Dec 2009 23:50:23.0722 (UTC) FILETIME=[B4ADF4A0:01CA7ABC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, December 11, 2009 4:29 PM, Russell King wrote:
> On Fri, Dec 11, 2009 at 11:10:15PM +0100, Pavel Machek wrote:
>> +#include <linux/gpio.h>
> ...
>> +#include <mach/gpio.h>
> ...
>> +#include <asm/gpio.h>
>
> Emm, this is getting really silly.
> 
> include/linux/gpio.h:
>   
>   #ifdef CONFIG_GENERIC_GPIO
>   #include <asm/gpio.h>
>   #else
>   ...
>   #endif
> 
> arch/arm/include/asm/gpio.h:
> 
>   #include <mach/gpio.h>
> 
> There really is no point in including mach/gpio.h nor asm/gpio.h when
> linux/gpio.h will do.  I'm retiscent to add #warnings or #errors into
> these files, but it seems that this is such a common thing that it may
> be beneficial to do so.

Hi Russell,

I think you mentioned last year around this time, when the big header
move occurred, that you were going to add a guideline for mach/*.h
headers to Documentation/arm.  Maybe it's time to add that patch and
just note that the <linux/*.h> version of the common headers should
be used and that the <asm/*.h> and <mach/*.h> header gets pulled in
automatically.

I think the two big ones that everyone screws up are, <linux/gpio.h>
and <linux/io.h>.

Regards,
Hartley
