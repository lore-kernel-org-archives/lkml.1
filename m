Return-Path: <linux-kernel-owner+w=401wt.eu-S1758044AbZFRGfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758044AbZFRGfr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 02:35:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754305AbZFRGfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 02:35:37 -0400
Received: from mail-fx0-f212.google.com ([209.85.220.212]:41212 "EHLO
	mail-fx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385AbZFRGff convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 02:35:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KyX3+w09pLP0PI7UEqZe/sGgtHLii5XapEoCactOldJonslHhYbvEvNar7weVxtAlu
         i+2B9bcEo0+VrRYVOZkTAAv0GzWaHqGwhrONl0vFNUHZbsuyvcuZuILbi4/s9+Zb0yW1
         9jn1TJryCwClUFzoRWGiWDqbUS0qRBEsUqzww=
MIME-Version: 1.0
In-Reply-To: <4A3936A0.9050709@nortel.com>
References: <4A33A7A2.1050608@gmail.com> <4A3936A0.9050709@nortel.com>
Date: Thu, 18 Jun 2009 08:35:35 +0200
Message-ID: <2ea1731b0906172335p1b6f2085j294df002ab2b71e0@mail.gmail.com>
Subject: Re: [PATCH 00/14] Pramfs: Persistent and protected ram filesystem
From: Marco Stornelli <marco.stornelli@gmail.com>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Daniel Walker <dwalker@soe.ucsc.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/17 Chris Friesen <cfriesen@nortel.com>:
> Marco wrote:
>> This is a second attempt at mainlining Pramfs. The first attempt was
>> back in early 2004 by MontaVista. Since then the kernel code has almost
>> been completely rewritten. So my first item on the list was porting the
>> code on a recent kernel version. After that I added the XIP support.
>>
>> Now some FAQs:
>>
>> What is the goal of this filesystem?
>>
>> Many embedded systems have a block of non-volatile RAM separate from
>> normal system memory, i.e. of which the kernel maintains no memory page
>> descriptors. For such systems it would be beneficial to mount a
>> fast read/write filesystem over this "I/O memory", for storing
>> frequently accessed data that must survive system reboots and power
>> cycles. An example usage might be system logs under /var/log, or a user
>> address book in a cell phone or PDA.
>
> Nice to see something like this submitted to mainline.  We use something
> similar to provide persistent storage for crash recovery debug data for
> boards which don't have local storage.
>
> In many cases kdump can provide good information, but it's not
> sufficient for "flight recorder" type data if the kernel gets rebooted
> by a hardware mechanism (watchdog, for instance) that doesn't give a
> pre-interrupt.

I'm very happy that this fs has the approval of the kernel community. :)

>
> I'm a bit concerned about your PTE modifications on every write
> though...we do things like log every exception and scheduler operation
> to persistent memory, and I think the overhead of changing the
> protection on every write would be a killer.  Instead, we make extensive
> use of checksums at various different levels so that the recovery app
> can determine which data is valid.
>

It's a trade-off between security and performance. Checksum it's a
good way to understand if a data is valid or not (indeed it's used in
this fs), but with this schema you can prevent the system to do
something wrong. This option, however, can be enabled/disabled via
kconfig.

> Also, I'd like to ensure that direct memory access to the memory area
> would be available.

What do you exactly mean with this? Can you explain to me a bit deeper?

> There are some things (like the sched/exception logging mentioned above) where we want to make accesses as fast as possible.
>
> Chris
>
>

Marco
