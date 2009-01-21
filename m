Return-Path: <linux-kernel-owner+w=401wt.eu-S1756626AbZAURaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626AbZAURaa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 12:30:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753276AbZAURaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 12:30:13 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:9171 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058AbZAURaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 12:30:11 -0500
MIME-Version: 1.0
In-Reply-To: <200901211009.48191.bjorn.helgaas@hp.com>
References: <49733678.40006@gmx.de> <200901201742.10155.bjorn.helgaas@hp.com>
	 <4976D517.2070406@gmx.de> <200901211009.48191.bjorn.helgaas@hp.com>
Date: Wed, 21 Jan 2009 18:30:08 +0100
Message-ID: <ac3eb2510901210930r1d9f0609w86bddbb6b363c79a@mail.gmail.com>
Subject: Re: [PATCH] Make PNP IDs all uppercase
From: Kay Sievers <kay.sievers@vrfy.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Philipp Kohlbecher <xt28@gmx.de>, Alessandro Zummo <a.zummo@towertech.it>,
       rtc-linux@googlegroups.com, Vojtech Pavlik <vojtech@ucw.cz>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
       Pau Oliva Fora <pof@eslack.org>, Hans Verkuil <hverkuil@xs4all.nl>,
       "David S. Miller" <davem@davemloft.net>,
       Jaroslav Kysela <perex@perex.cz>, Adam Belay <abelay@mit.edu>,
       Len Brown <lenb@kernel.org>,
       Jonathan Woithe <jwoithe@physics.adelaide.edu.au>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>,
       linux-acpi@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2009 at 18:09, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> On Wednesday 21 January 2009 12:56:07 am Philipp Kohlbecher wrote:
>> Bjorn Helgaas wrote:

>> > Did you trip over an actual problem that is fixed by this patch?  If
>> > so, can you give any more details?
>>
>> Yes. After a package update, hwclock stopped using the "--directisa"
>> switch and could not access the RTC anymore. My RTC is handled by
>> rtc-cmos, which is compiled as a module. However, udev did not load this
>> module, as the device's modalias "acpi:PNP0B00:" did not match any of
>> the module's aliasas, including "acpi*:PNP0b00:*". Thus, the system
>> clock was not set correctly at startup (my hardware clock is set to
>> local time). Changing the PNP IDs in drivers/rtc/rtc-cmos.c to use
>> uppercase hex digits solved that problem for me.
>
> Nice work debugging that problem!  I would include that synopsis in
> the changelog, because it helps people who trip over the same problem
> and are looking for a solution, and it helps people who want to
> understand why the change was made.

We uppercase all acpi alias strings now, so that should be solved:
  http://git.kernel.org/?p=linux/kernel/git/gregkh/patches.git;a=blob;f=driver-core.current/pnp-fix-broken-pnp-lowercasing-for-acpi-module-aliases.patch;hb=HEAD

Kay
