Return-Path: <linux-kernel-owner+w=401wt.eu-S1755546AbZKDLe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546AbZKDLe2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 06:34:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755508AbZKDLe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 06:34:27 -0500
Received: from mx1.moondrake.net ([212.85.150.166]:33843 "EHLO
	mx1.mandriva.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755387AbZKDLe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 06:34:27 -0500
X-Spam-Virus: No
From: Arnaud Patard <apatard@mandriva.com>
To: wuzhangjin@gmail.com
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       LKML <linux-kernel@vger.kernel.org>, huhb@lemote.com, yanh@lemote.com,
       Zhang Le <r0bertz@gentoo.org>, Thomas Gleixner <tglx@linutronix.de>,
       Nicholas Mc Guire <der.herr@hofr.at>, zhangfx@lemote.com,
       liujl@lemote.com
Subject: Re: [PATCH -queue v0 5/6] [loongson] rtc: enable legacy RTC driver on fuloong2f
References: <cover.1257325319.git.wuzhangjin@gmail.com>
	<e13ed33a99dbf14f223360d414aa2b2c5caa9b1f.1257325319.git.wuzhangjin@gmail.com>
	<m3eioetvx5.fsf@anduin.mandriva.com>
	<1257333527.8716.20.camel@falcon.domain.org>
Organization: Mandriva
Date: Wed, 04 Nov 2009 12:34:44 +0100
In-Reply-To: <1257333527.8716.20.camel@falcon.domain.org> (Wu Zhangjin's message of "Wed, 04 Nov 2009 19:18:47 +0800")
Message-ID: <m3aaz2ttez.fsf@anduin.mandriva.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Zhangjin <wuzhangjin@gmail.com> writes:

> Hi,
>
> On Wed, 2009-11-04 at 11:40 +0100, Arnaud Patard wrote:
>> Wu Zhangjin <wuzhangjin@gmail.com> writes:
>> 
>> Hi,
>> 
>> > RTC_LIB is selected by MIPS by default, and therefore, the legacy RTC driver is
>> > disabled. but unfortunately, RTC_LIB not works on fulong, so, enabling the legcy
>> > RTC driver is needed, otherwise, the tools like hwclock will not work.
>> >
>> > because loongson family machines, including fuloong2e, fuloong2f and
>> > yeeloong2f need to enable legacy RTC driver, so we use MACH_LOONGSON
>> > here.
>> 
>> There are loongson machines which are working fine with RTC_LIB (for
>> instance the gdium which is using a m41t83 on i2c) so would be better to
>> be more restrictive imho.
>
> In reality, fuloong2e, fuloong2f and yeeloong2f work fine with RTC_LIB,
> but relative patches need to append to drivers/rtc/rtc-cmos.c and also
> need a RTC platform device. If what I remembered is right, Gdium also
> need corresponding patches to make it work with RTC_LIB.

As I said, Gdium is using an i2c chip and the bus is made with the sm501
gpio. So except the patch for gpiolib support for ls2f, there's nothing
special for RTC_LIB. It's just working out of the box (as long as you
declare the platform devices but that's not what I call a problem).

>
> Herein, I just let the basic support for those machines work, and then,
> the RTC_LIB support will be sent out later.
>
> and a small question: if legacy RTC driver works well on these machines,
> why should we forbid people to use it? I think it's better to remove the
> "select RTC_LIB" line for MIPS, and then, the people will be free to
> choose what they want, and even for the users whose platform not support
> RTC_LIB.

Well, I though about this. If you go that way and remove the "select
RTC_LIB", please check and enable it for all platforms which needs it or
warn people about. Would be nice to avoid regression due to that.


Arnaud
