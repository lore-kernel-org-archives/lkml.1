Return-Path: <linux-kernel-owner+w=401wt.eu-S1754588AbZA0DAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588AbZA0DAK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 22:00:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752365AbZA0C75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 21:59:57 -0500
Received: from wf-out-1314.google.com ([209.85.200.169]:17152 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbZA0C74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 21:59:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=w7Q+68sfB8STLpkrY/9EiuyizqGbH7EeGRh9/Ha3qqJJw3ghk+z1MIuAScvjka1bMh
         EGzxZKeb5DQ40BIb6pfShn+2Btl4a+1jbPJ1uQzhcmQ22pFHPjxQ7dqFuW42vORxji7B
         WeedF0agF+keNVZaKtDkVtP8Zr3WV0pE1Joj0=
MIME-Version: 1.0
In-Reply-To: <497E4531.20800@nerdgrounds.com>
References: <497E4531.20800@nerdgrounds.com>
Date: Mon, 26 Jan 2009 18:59:54 -0800
Message-ID: <5bdc1c8b0901261859g58a413e1x52208a6f2c1f9ccd@mail.gmail.com>
Subject: Re: Vramfs: filesystem driver to utilize extra RAM on VGA devices
From: Mark Knecht <markknecht@gmail.com>
To: Jonathan Campbell <jon@nerdgrounds.com>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2009 at 3:20 PM, Jonathan Campbell <jon@nerdgrounds.com> wrote:
> Hey guys.
> About a month ago while covered in the Seattle snowstorm I hacked together
> this pseudofilesystem that might be of interest.
>
> I thought that this driver could solve two issues that I have:
>
> one, that today's graphics cards have relatively obscene amounts of RAM on
> them even if you're not using it. If you're running it as a server and not
> using it for 3D graphics, why not mount the VRAM on the graphics card as a
> filesystem and store things there to get some extra space?
>
> two, if 3D hardware acceleration and access to GPU or texture memory could
> be provided to user-space, one way to do it would be to provide sections of
> VRAM as a filesystem that most languages (yes---even Perl!) could use to
> work with todays graphics cards. They could treat the texture memory the way
> they treat files in /dev/shm: read/write it for general access or mmap it
> for direct manipulation. At least, it makes far more sense to me from a
> programming point of view than to abstract it using specialized ioctls
> through the DRI. It might make writing an OpenGL driver for this kind of
> arrangement cleaner, too.
>
> http://www.nerdgrounds.com/vramfs-20090126-1458.tar.gz
>
> So far I've tested it against 2.6.25.17 and 2.6.28 on both x86 and x86_64
> with reads, writes, directory creation, symlink creation, and mmap() and it
> seems to work fine.
> Just give it a range of memory on the bus, or the domain:bus:device:function
> numbers of a VGA PCI device, and it will mount the VGA video RAM and allow
> files to exist there.
> As a special hack: you can also specify the size of the active framebuffer
> console so that fbcon doesn't collide with this driver (unless you want to
> see what your files look like splattered across your screen, ha). The active
> VRAM area becomes a "sentinel" file named "framebuffer".
>
> What do you guys think?
>
> Jonathan Campbell
> Impact Studio Pro
>

Can the GPU use the data placed in your file system? Do you have
strong control as to exactly how the data is mapped into VRAM? I'm
thinking about parallel processing  - Linux puts data there and then
the GPU works on it to produce a result which Linux can eventually
fetch.

- Mark
