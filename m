Return-Path: <linux-kernel-owner+w=401wt.eu-S1753843AbZEISKJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843AbZEISKJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 14:10:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753209AbZEISJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 14:09:57 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:43973 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbZEISJ4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 14:09:56 -0400
MIME-Version: 1.0
In-Reply-To: <20090509181138.15d2a490@lxorguk.ukuu.org.uk>
References: <20090509143742.GA27663@kroah.com> <b637ec0b0905090810t188e39e3w92d9f4eff04011f1@mail.gmail.com> 
	<20090509150853.GA32394@suse.de> <20090509082233.32cbb8e4@infradead.org> 
	<ac3eb2510905090946t52926a5j1be2cac31f480352@mail.gmail.com> 
	<20090509181138.15d2a490@lxorguk.ukuu.org.uk>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Sat, 9 May 2009 20:09:35 +0200
Message-ID: <ac3eb2510905091109l67429676he237be885c0ff00e@mail.gmail.com>
Subject: Re: [patch 00/13] devtmpfs patches
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Arjan van de Ven <arjan@infradead.org>, Greg KH <gregkh@suse.de>,
       Fabio Comolli <fabio.comolli@gmail.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 9, 2009 at 19:11, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Sat, 9 May 2009 18:46:10 +0200
> Kay Sievers <kay.sievers@vrfy.org> wrote:
>
>> On Sat, May 9, 2009 at 17:22, Arjan van de Ven <arjan@infradead.org> wrote:
>> > On Sat, 9 May 2009 08:08:53 -0700
>> > Greg KH <gregkh@suse.de> wrote:
>> >
>> >> > Well, guess you meant the opposite ;-)
>> >>
>> >> Heh, yes, sorry about that.  It makes booting faster :)
>> >
>> > .. and I don't buy that.
>>
>> Don't buy, just try it - and you will see. :)
>
> Got some boot timing graphs for the change ?

So far, I got numbers for different options used with devtmpfs to
compare initramfs with non-initramfs. Initramfs is what all general
purpose distros need to use today, to be able to identify the disk by
LABEL/UUID/Hardware-properties. And I wanted to see how expensive the
use of initramfs is. They are posted here:
  http://lkml.org/lkml/2009/5/6/197

The "init" for intramfs is attached to the mail, mainly to illustrate
the simplification over the things we need to do today, and that there
is never a point in time where we have to delay things, because /dev
is empty during the moment we mount a fresh and empty tmpfs /dev.

To directly compare numbers for devtmpfs and non-devtmpfs, the "init"
script would need to be modified to ignore the kernel provided
devtmpfs and mount an empty tmpfs over it, and populate it, just like
we do it today. There is no theoretical chance that this can ever be
faster.

Most of the bootstrap logic we have today: mount an empty tmpfs /dev
-> add the few mandatory nodes to be able to start the bootstrap
process -> run something that reads sysfs-device-information (in the
usual case udev) -> delaying all further processing until /dev is
minimally usable to start things that rely on a working /dev, ... all
that gets basically stripped down to: "mount --move /dev /root/dev",
right at the end before we leave initramfs behind us.

Kay
