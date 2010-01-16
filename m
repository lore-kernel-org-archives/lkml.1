Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804Ab0APPvn (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 10:51:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753403Ab0APPvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 10:51:42 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:48226 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab0APPvl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 10:51:41 -0500
MIME-Version: 1.0
In-Reply-To: <20100115205722.3580b6bf@lxorguk.ukuu.org.uk>
References: <1263505677.2074.2.camel@yio.site> <20100115065638.005ac690@infradead.org> 
	<20100115180341.GA12146@kroah.com> <20100115205722.3580b6bf@lxorguk.ukuu.org.uk>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Sat, 16 Jan 2010 16:51:23 +0100
Message-ID: <ac3eb2511001160751g2357bf2en2bfacaabe5c2f7e@mail.gmail.com>
Subject: Re: Driver-Core: devtmpfs - remove EXPERIMENTAL and enable it by 
	default
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>, Arjan van de Ven <arjan@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 15, 2010 at 21:57, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> Why?  All major distros need this at boot time, and as we have been
>
> No they don't.
>
> Centos doesn't (in fact I suspect it'll break)
> Fedora 11 doesn't
> Fedora 12 doesn't seem to (but seems to be willing to use it)
> Ditto all the older SuSE, Ubuntu etc releases that are *still*
> active/supported/maintained

Fedora, SUSE, Ubuntu, ... All releases currently in development enable
and use it.

>> through a release cycle with the config option, anyone who is
>> incrementally updating will continue with their existing value.  But new
>> people coming in, will get the option as it is most likely required to
>> boot properly.
>>
>> Makes sense to me.
>
> That may well be true - in which case it needs to be very clearly
> documented when to enable it.

For now, the systems will bootup fine without it, but I expect over
time, it will get a requirement. Udev does not care about it, but the
boot scripts/initramfs tools will probably get trimmed down, because
there is much less to do with the kernel provided nodes, than what is
needed today to bootstrap /dev.

And it should not harm any old system if it is enabled. If initramfs
is used it's completely invisible, if a custom kernel with
kernel-mounted rootfs is used, the udev boot script usually
over-mounts the devtmpfs at /dev with an empty tmpfs, like it has
always done it before.

The only thing it should change is that we now should be able to
bootup a box without an initramfs, without manually filling /dev with
static nodes beforehand. Current distro installations do not put a
single file in /dev on the rootfs, and trying to boot a kernel without
an initramfs usually just fails without putting some nodes there in
preparation.

Thanks,
Kay
