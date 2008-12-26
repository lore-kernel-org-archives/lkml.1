Return-Path: <linux-kernel-owner+w=401wt.eu-S1753428AbYLZVBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbYLZVBA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 16:01:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbYLZVAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 16:00:51 -0500
Received: from mail.lang.hm ([64.81.33.126]:56081 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752634AbYLZVAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 16:00:51 -0500
Date: Fri, 26 Dec 2008 14:02:37 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Roland <devzero@web.de>
cc: linux-kernel@vger.kernel.org, Jan Engelhardt <jengelh@medozas.de>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] Compress kernel modules on installation
In-Reply-To: <005401c96797$df055100$6602a8c0@bui.materna.com>
Message-ID: <alpine.DEB.1.10.0812261354250.10983@asgard.lang.hm>
References: <005401c96797$df055100$6602a8c0@bui.materna.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Dec 2008, Roland wrote:

> what about some "make modules_install_compressed" instead ?
>
> as i have run out of diskspace quite often when installing test kernels, i 
> think we really need a feature like this.
>
> i`d also favour the makefile approach.
> why another kconfig option?
>
> jan`s patch looks clean and simple, but i think it`s a little bit 
> intrusive...

by default the main kernel is compressed, why should the modules not be 
compressed by default as well?

> regards
> roland
>
> ps:
> i`d use gzip without "-9" as this gives very little space savings. it mostly 
> burns cpu and slows things down too much.
> ( see 
> http://www.linuxjournal.com/files/linuxjournal.com/linuxjournal/articles/080/8051/8051f1.png 
> )

this varies a lot on the particulars of the data being compressed. I don't 
know what difference it makes on the kernel modules, but I have seen it be 
worth it in some other cases.

however, I do need to ask what the sizes of the resulting files end up 
being (on my system the last kernel that used modules was 2.4.31, so I 
can't just look this up myself). in most cases disks are formatted with 4K 
blocks, so unless it shrinks across such a boundry it's not actually going 
to help much.

one other thing to consider would be some ability to load the module out 
of a tar or cpio bundle, that way you end up saving all the partial blocks 
from each module as well.

David Lang

>
> On Friday 2008-12-26 20:48, Sam Ravnborg wrote:
>> > > >
>> > > > This patch allows kernel modules to be compressed when 'make
>> > > > modules_install' is run after being copied to
>> > > > the /lib/module/<version>/<...> directory which is useful if you > > 
>> > have
>> > > > module-init-tools installed with --enable-zlib. This patch adds an
>> > > > option (MODULE_COMPRESS) to the kernel configuration file > > > 
>> (specifically
>> > > > init/Kconfig) so that the kernel modules will compressed if
>> > > > MODULE_COMPRESS is set.
>> >
>> > I recently started compressing my kernel modules and that saved me
>> > at least 70 MB of disk space on mostlyallmodconfig.
>> > (And no, the argument of disks being cheap is not so true with
>> > CF or SSD.)
>> > Distro is lazy and wants to wait for upstream to have it,
>> > so is there any chance of getting this proposal in?
>> 
>> Steve said he wanted to try to make the solution more
>> scalable so I am awaiting a new patch.
>
> Hm, all I needed was this patch. It might fire up some people,
> but it's got all the scalability I could think of..
>
>
> commit b4a3e1c610c99d4e8b543b97fd722076c6f7c5dd
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Wed Dec 10 20:39:21 2008 +0100
>
> build: install modules compressed
> ---
> scripts/Makefile.modinst |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/scripts/Makefile.modinst b/scripts/Makefile.modinst
> index efa5d94..c3421a1 100644
> --- a/scripts/Makefile.modinst
> +++ b/scripts/Makefile.modinst
> @@ -17,7 +17,7 @@ __modinst: $(modules)
> @:
>
> quiet_cmd_modules_install = INSTALL $@
> -      cmd_modules_install = mkdir -p $(2); cp $@ $(2) ; $(mod_strip_cmd) \
> $(2)/$(notdir $@) +      cmd_modules_install = mkdir -p $(2); cp $@ $(2) ; \
> $(mod_strip_cmd) $(2)/$(notdir $@); gzip -9f $(2)/$(notdir $@)
> # Modules built outside the kernel source tree go into extra by default
> INSTALL_MOD_DIR ?= extra
> --
>
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
