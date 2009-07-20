Return-Path: <linux-kernel-owner+w=401wt.eu-S1754129AbZGTUi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129AbZGTUi6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 16:38:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754003AbZGTUi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 16:38:57 -0400
Received: from mail-yx0-f197.google.com ([209.85.210.197]:50779 "EHLO
	mail-yx0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949AbZGTUi4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 16:38:56 -0400
X-Greylist: delayed 395 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Jul 2009 16:38:56 EDT
MIME-Version: 1.0
In-Reply-To: <20090720131959.3b157627.akpm@linux-foundation.org>
References: <1246766879-5784-1-git-send-email-cascardo@holoscopio.com> 
	<20090720131959.3b157627.akpm@linux-foundation.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Mon, 20 Jul 2009 22:32:06 +0200
Message-ID: <ac3eb2510907201332i25ea109t981425451eafd4e1@mail.gmail.com>
Subject: Re: [PATCH] RTC: mark if rtc-cmos drivers were successfully 
	registered.
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
       dbrownell@users.sourceforge.net, bjorn.helgaas@hp.com,
       Alessandro Zummo <a.zummo@towertech.it>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 20, 2009 at 22:19, Andrew Morton<akpm@linux-foundation.org> wrote:
> On Sun,  5 Jul 2009 01:07:59 -0300
> Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com> wrote:
>
>> rtc-cmos has two drivers, one PNP and one platform. When PNP has not
>> succeeded probing, platform is registered. However, it tries to
>> unregister both drivers unconditionally, instead of only unregistering
>> those that were successfully registered. Fix that with a boolean
>> variable for each driver indicating whether registering was successful.

> This came up a few weeks ago - the kernel was actually crashing deep
> down in the driver core, when a not-registered device was unregistered.
>
> I believe Kay was planning on making the driver core more robust, so
> that crash shouldn't be happening any more.  Kay, can you please confirm
> that thsi got fixed?

This is supposed to fix it:
  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=5c8563d773c0e9f0ac2a552e84806decd98ce732

Thanks,
Kay
