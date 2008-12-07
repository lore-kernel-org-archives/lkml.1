Return-Path: <linux-kernel-owner+w=401wt.eu-S1754920AbYLGOC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920AbYLGOC6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 09:02:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754098AbYLGOCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 09:02:50 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:24196 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087AbYLGOCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 09:02:49 -0500
Message-ID: <ac3eb2510812070602rdc62343q8d11471f71748595@mail.gmail.com>
Date: Sun, 7 Dec 2008 15:02:47 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: Runaway loop with the current git.
Cc: "Evgeniy Polyakov" <zbr@ioremap.net>, linux-kernel@vger.kernel.org
In-Reply-To: <20081207112335.0afd5192@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081205193432.290a6f1a@lxorguk.ukuu.org.uk>
	 <ac3eb2510812051810x8cf4256lf9fd31b15b9e0552@mail.gmail.com>
	 <20081206160927.GA498@ioremap.net>
	 <ac3eb2510812060816h4401c78bj6d656d0d5721024@mail.gmail.com>
	 <20081206165634.GA2516@ioremap.net>
	 <ac3eb2510812061011u7a7f0fbdtc46b95a9c642f9c7@mail.gmail.com>
	 <1228591926.3808.6.camel@nga> <20081206202620.GA9470@ioremap.net>
	 <ac3eb2510812061956g6bb422d9r7c8032fb68552b4c@mail.gmail.com>
	 <20081207112335.0afd5192@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 7, 2008 at 12:23, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> This modprobe process does try to log an error, accesses /dev/console,
>> which is not initialized in the kernel at that time, and the kernel
>> module loader tries the load a module to support dev_t 5:1, which
>> again runs modprobe, and ...
>
> So we have a buggy modprobe...

No, we have not. It is fine for modprobe doing that, as it is for any
other binary too. It's also the usual glibc behavior for syslog(). Any
userspace binary can access /dev/console any time. The kernel is not
supposed to call modprobe to make /dev/console availabe.

>> Setting CONFIG_CRYPTO_MANAGER=y makes it disapper. The patch I sent
>> seems to fix it.
>>
>> The bug is handled here: http://bugzilla.kernel.org/show_bug.cgi?id=12153
>
> We cannot go re-ordering random chunks of kernel init with unpredictable
> effects including possibly making other stuff less reliable (because you
> set up the console device before the console driver is loaded on a PCI
> bus device).

We are not reordering, we provide a registered /dev/console driver
core device, not touching any driver, just to prevent the kernel
module loader from going crazy.

> And we certainly can't do it this close to a release.

We can do the real fix any time it is the proper time. It is still an
obvious kernel bug which needs to be fixed, and not some obscure
userspace rule, we suddenly need to establish to work around some dumb
module loader/console logic.

Thanks,
Kay
