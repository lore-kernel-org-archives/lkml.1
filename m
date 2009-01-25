Return-Path: <linux-kernel-owner+w=401wt.eu-S1757818AbZAYNPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757818AbZAYNPd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 08:15:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755149AbZAYNPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 08:15:21 -0500
Received: from isrv.corpit.ru ([81.13.33.159]:49494 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755136AbZAYNPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 08:15:20 -0500
Message-ID: <497C65E4.2040302@msgid.tls.msk.ru>
Date: Sun, 25 Jan 2009 16:15:16 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: Switching from (deprecated) IDE driver -> SATA (PATA support)
 (found solution (scratch that))
References: <alpine.DEB.1.10.0901250553430.2441@p34.internal.lan> <20090125110742.4ba54c0b@lxorguk.ukuu.org.uk> <alpine.DEB.1.10.0901250705300.6888@p34.internal.lan> <alpine.DEB.1.10.0901250715030.10379@p34.internal.lan> <alpine.DEB.1.10.0901250726530.10805@p34.internal.lan> <alpine.DEB.1.10.0901250740360.11258@p34.internal.lan> <alpine.DEB.1.10.0901250752020.11258@p34.internal.lan> <alpine.DEB.1.10.0901250808020.15073@p34.internal.lan>
In-Reply-To: <alpine.DEB.1.10.0901250808020.15073@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
> 
> On Sun, 25 Jan 2009, Justin Piszcz wrote:
>> On Sun, 25 Jan 2009, Justin Piszcz wrote:
>>> On Sun, 25 Jan 2009, Justin Piszcz wrote:
>>>> On Sun, 25 Jan 2009, Justin Piszcz wrote:
>>>>> On Sun, 25 Jan 2009, Justin Piszcz wrote:

Wow, that's quite some ping-pong!.. ;)

[]
> Hm, I may have spoke too fast:
> 
> Added: (IDE ONLY), no SATA:
> image=/boot/2.6.26-6
>         label=2.6.26-6
>         read-only
>         root=current
> 
> p254:/boot# lilo
> Added 2.6.26-6 *
> Added 2.6.28-4
> p254:/boot#
> 
> Set to current.
> 
> p254:/boot# grep =current /etc/lilo.conf
> root=current
>         root=current
> p254:/boot#
> 
> The reason current may have worked before is because I manually booted with
> root=/dev/sdd2 (after I saw the error that it could not find root,302, etc)
> 
> So I am booting the old kernel without the SATA drivers with root=current
> to see if it works..
> 
> Nope, so I need to figure out how to get the UUID= option working in LILO.

There's no way without using initramfs.  Lilo only records the unix device
number (like 8:1 for /dev/sda1) and passes it to kernel (replacing `current'
with that number).  But for different kernels (IDE vs PATA drivers) the
number will be different.  Lilo itself - when booting at least - can not
know which device it will be.

The only universal solution is to use smart initramfs that will populate
/dev/disk/by-label/ etc (using udev maybe).

Another solution is to explicitly specify root=/dev/sda1 or root=/dev/hda1
when using pata- or ide-enabled kernels, in lilo.conf.

/mjt
