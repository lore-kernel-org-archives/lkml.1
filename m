Return-Path: <linux-kernel-owner+w=401wt.eu-S1753225AbYLHMmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbYLHMmm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 07:42:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751855AbYLHMmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 07:42:33 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:5576 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbYLHMmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 07:42:33 -0500
Message-ID: <ac3eb2510812080442u749eb997o1ad6d6036b6d7c5c@mail.gmail.com>
Date: Mon, 8 Dec 2008 13:42:31 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Geert Uytterhoeven" <geert@linux-m68k.org>
Subject: Re: Badness at mm/backing-dev.c:179
Cc: "Mark Jackson" <mpfj@mimc.co.uk>,
       "Linux Kernel Development" <linux-kernel@vger.kernel.org>,
       "Haavard Skinnemoen" <haavard.skinnemoen@atmel.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "David Woodhouse" <dwmw2@infradead.org>,
       "Linux/m68k" <linux-m68k@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0812080915120.14941@anakin>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <49367691.5060007@mimc.co.uk>
	 <ac3eb2510812030422n15f1be2cn77aa5f66f1046933@mail.gmail.com>
	 <Pine.LNX.4.64.0812080915120.14941@anakin>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 8, 2008 at 09:16, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Wed, 3 Dec 2008, Kay Sievers wrote:
>> On Wed, Dec 3, 2008 at 13:07, Mark Jackson <mpfj@mimc.co.uk> wrote:
>> > The following commit causes a "Badness at mm/backing-dev.c:179":-
>> >
>> > f1d0b063d993527754f062c589b73f125024d216 is first bad commit
>> > commit f1d0b063d993527754f062c589b73f125024d216
>> > Author: Kay Sievers <kay.sievers@vrfy.org>
>> > Date:   Tue Dec 2 10:31:50 2008 -0800
>> >
>> >    bdi: register sysfs bdi device only once per queue
>>
>> > Below is the extract from dmesg:-
>> >
>> > ------------[ cut here ]------------
>> > Badness at mm/backing-dev.c:179
>>
>> That's a known issue, and will not cause any harm besides printing
>> this warning. Andrew added the warning to catch drivers who use one
>> single request queue for multiple devices. Currently known are mtd and
>> floppy (triggers only if you have more than one device per driver).
>> The drivers need to be changed to use a separate queue per device, to
>> get rid of this warning.
>
> I guess this one (introduced after 2.6.28-rc7) is an incarnation of the same
> issue?

You have more than one floppy device registered at the same time,
right? Then it's very likely the same issue, that both devices share
the same request queue, like the x86 floppy.c.

Kay
