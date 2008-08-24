Return-Path: <linux-kernel-owner+w=401wt.eu-S1753106AbYHXCFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106AbYHXCFb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 22:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751380AbYHXCFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 22:05:14 -0400
Received: from qb-out-0506.google.com ([72.14.204.238]:45362 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbYHXCFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 22:05:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=uucrk0UyOrmVQ7pgNOzTzZbOxq6YVTVM8vYmIb/ZHcX96Z9wu4Skbfwo9QzECOATJG
         AVh+/8vgGhrZAn+WmtOg0vAkDum8Rvna3YFqfd4yVcoiYF4N0FG+igOgN6r/Cb7BwOR5
         FPnFZ8/LhtbJdfSDSqvrf4haHrGkhEDs7LADo=
Message-ID: <86802c440808231905k71c40724p5fa3b20432cc8a3e@mail.gmail.com>
Date: Sat, 23 Aug 2008 19:05:05 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "David Witbrodt" <dawitbro@sbcglobal.net>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- found another user with the same regression
Cc: "Rufus & Azrael" <rufus-azrael@numericable.fr>,
       "Linux-kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <937183.58339.qm@web82104.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <937183.58339.qm@web82104.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 23, 2008 at 4:42 PM, David Witbrodt <dawitbro@sbcglobal.net> wrote:
>
>
>> please check v3
>>
>> deviceid should be 0x4385 instead.
>
> Yinghai!
>
> You did it!  The kernel boots without "hpet=disable" or any other
> workaround...

good

>
> (BTW, just what kernel version were you using for those patches?  The
> v2.6.27-rcX series place the patch's changes over 100 lines earlier
> than the line numbers indicated in your patches....)

we are working on tip/master

>
> In case you want it, here is the output you have usually asked for:
> =============================
>
> $ dmesg
> Linux version 2.6.27-rc4.080823.hpet+bar1+v3 (dawitbro@fileserver) (gcc version 4.3.1 (Debian 4.3.1-2) ) #1 SMP Sat Aug 23 19:23:53 EDT 2008
> Command line: root=/dev/hda1 ro video=uvesafb:1280x1024-16@60,mtrr:3 fbcon=scrollback:256k,font:10x18 debug initcall_debug
> KERNEL supported cpus:
>  Intel GenuineIntel
>  AMD AuthenticAMD
>  Centaur CentaurHauls

> 00:14.0 SMBus: ATI Technologies Inc SBx00 SMBus Controller (rev 13)
>    Subsystem: Elitegroup Computer Systems Device 2621
>    Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
>    Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>    Region 0: I/O ports at fa00 [size=16]
>    Region 1: Memory at fed00000 (32-bit, non-prefetchable) [size=1K]
>    Capabilities: <access denied>
>    Kernel driver in use: piix4_smbus
> 00: 02 10 85 43 03 04 30 02 13 00 05 0c 00 00 80 00
> 10: 01 fa 00 00 00 00 d0 fe 00 00 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 19 10 21 26
> 30: 00 00 00 00 b0 00 00 00 00 00 00 00 00 00 00 00

kernel leave the BAR1 untouched ...

>
> $ cat /proc/timer_list | grep -B1 -A5 hpet
> Tick Device: mode:     1
> Clock Event Device: hpet
>  max_delta_ns:   149983003520
>  min_delta_ns:   3352
>  mult:           61496115
>  shift:          32
>  mode:           1
>  next_event:     9223372036854775807 nsecs
>  set_next_event: hpet_legacy_next_event
>  set_mode:       hpet_legacy_set_mode
>  event_handler:  tick_handle_oneshot_broadcast
> tick_broadcast_mask: 00000000
> tick_broadcast_oneshot_mask: 00000000
>

hpet works.

YH
