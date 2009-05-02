Return-Path: <linux-kernel-owner+w=401wt.eu-S1757186AbZEBR5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186AbZEBR5s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 13:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755062AbZEBR5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 13:57:39 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:55326 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360AbZEBR5j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 13:57:39 -0400
MIME-Version: 1.0
In-Reply-To: <49FC7BF5.8080502@garzik.org>
References: <1241097822.2516.3.camel@poy> <20090502071636.GA9487@infradead.org> 
	<49FC7BF5.8080502@garzik.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Sat, 2 May 2009 19:57:23 +0200
Message-ID: <ac3eb2510905021057s520b27dr632cb8a1ac92f730@mail.gmail.com>
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev tmpfs
To: Jeff Garzik <jeff@garzik.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Jan Blunck <jblunck@suse.de>, linux-arch@vger.kernel.org,
       viro@zeniv.linux.org.uk, torvalds@osdl.org, akpm@osdl.org,
       adam@yggdrasil.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 2, 2009 at 18:59, Jeff Garzik <jeff@garzik.org> wrote:
> Christoph Hellwig wrote:

>> It basically does re-introduce devfs under a different name, and from
>> looking at the implementation it might not be quite as bad a Gooch's
>> original, but it's certainly worse than Adam Richters rewrite the we
>> never ended up merging.
>
> I was interested in this Richter devfs rewrite, since I was unfamiliar with
> it.
>
> For the benefit of the thread, here is a URL that people can examine:
>
>        http://marc.info/?l=linux-kernel&m=104138806530375&w=2

And it did:
  - the crazy devfs naming scheme with:
      /dev/ide/host0/bus0/target0/lun0/part1, /dev/tty/0,
    and it did not even create our current names by default
  - path lookup interception and called modprobe behind your back
  - call_usermodhelper() from the kernel to name devices
  - introduced a new filesystem type and a bunch of
    new datatypes
  - and so on ...

I don't think anybody else besides Christoph would call devtmpfs
"seriously worse" than this. :) None of these "features" are needed
today, or even close to even worth to think about it.

And for the "policy in kernel department" which will be the next naive
argument: The kernel carries the policy today for 98% of the devices,
if you change any driver given name, it will no longer show up in /dev
with the current name. That's the reality since years, and will not be
different anytime soon, there is no real naming policy besides the
current kernel supplied names.

Now that we managed to define a common set of /dev names we all share
across distros, it's time to let the kernel know about the remaining
2% and let it pre-create the device nodes itself for userspace to pick
up, with all the earlier mentioned opportunities it offers.

The final policy will still live in udev which sets ownership and
mode, and possibly overwrites the node name. Nothing really has
changed, it can just be made faster, and it is much more reliable if
stuff in userspace goes wrong.

Thanks,
Kay
