Return-Path: <linux-kernel-owner+w=401wt.eu-S1753784AbYIETR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784AbYIETR0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 15:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbYIETRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 15:17:16 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:22954 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbYIETRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 15:17:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=m8r/nPGSP2hx5PC8L84mI77vGcKlBWztuQn1rgMl0lbz5tVW1XEPS+ddR8ztJ/cMgl
         B/9zM/glYpb/5++WJKIB9TJ5sYcVspNIuGnlbmJms345M4sMBVR5p+SY+6RTntB4uLAV
         fyO8mLwfL6JwMPv4PvlixB+ocVdiPgCjsIok8=
Message-ID: <68676e00809051217h3da02a6bld4412b4a2ee3b728@mail.gmail.com>
Date: Fri, 5 Sep 2008 21:17:13 +0200
From: "Luca Tettamanti" <kronos.it@gmail.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: [2.6.27] overlapping early reservations [was: early exception - lockdep related?]
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 4, 2008 at 10:51 PM, Luca Tettamanti <kronos.it@gmail.com> wrote:
> On Thu, Sep 4, 2008 at 4:25 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> Sadly your config just boots, albeit not to userspace due to missing
>> drivers.
>
> Yes, I managed to boot it with qemu... I tried kgdb - without luck -
> kernel dies too early.
> I also managed to get a stack trace :D
>
> http://img151.imageshack.us/my.php?image=tracedm1.jpg
>
> It seems that lockdep is an innocent bystander... the kernel died with
> panic() in __reserve_early, and then took another exception while
> printing the panic (I guess).
> Will add further debug stuff to see wtf is going on.

Hum, kernel says:

http://img177.imageshack.us/my.php?image=overlappingus2.jpg

Overlapping early reservations b98000-eff266 RAMDISK to 200000-d09cf7
TEXT DATA BSS

It would appear that the initramfs is overlapping the kernel itself,
is the boot loader (LILO) doing something stupid?

Luca
