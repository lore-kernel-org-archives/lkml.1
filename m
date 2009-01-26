Return-Path: <linux-kernel-owner+w=401wt.eu-S1755030AbZAZXej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030AbZAZXej (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 18:34:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752937AbZAZXe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 18:34:28 -0500
Received: from omr8.networksolutionsemail.com ([205.178.146.58]:39813 "EHLO
	omr8.networksolutionsemail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752834AbZAZXe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 18:34:27 -0500
X-Greylist: delayed 807 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Jan 2009 18:34:27 EST
Message-ID: <497E4531.20800@nerdgrounds.com>
Date: Mon, 26 Jan 2009 15:20:17 -0800
From: Jonathan Campbell <jon@nerdgrounds.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Linux Kernel List <linux-kernel@vger.kernel.org>
CC: devel@driverdev.osuosl.org
Subject: Vramfs: filesystem driver to utilize extra RAM on VGA devices
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey guys.
About a month ago while covered in the Seattle snowstorm I hacked 
together this pseudofilesystem that might be of interest.

I thought that this driver could solve two issues that I have:

one, that today's graphics cards have relatively obscene amounts of RAM 
on them even if you're not using it. If you're running it as a server 
and not using it for 3D graphics, why not mount the VRAM on the graphics 
card as a filesystem and store things there to get some extra space?

two, if 3D hardware acceleration and access to GPU or texture memory 
could be provided to user-space, one way to do it would be to provide 
sections of VRAM as a filesystem that most languages (yes---even Perl!) 
could use to work with todays graphics cards. They could treat the 
texture memory the way they treat files in /dev/shm: read/write it for 
general access or mmap it for direct manipulation. At least, it makes 
far more sense to me from a programming point of view than to abstract 
it using specialized ioctls through the DRI. It might make writing an 
OpenGL driver for this kind of arrangement cleaner, too.

http://www.nerdgrounds.com/vramfs-20090126-1458.tar.gz

So far I've tested it against 2.6.25.17 and 2.6.28 on both x86 and 
x86_64 with reads, writes, directory creation, symlink creation, and 
mmap() and it seems to work fine.
Just give it a range of memory on the bus, or the 
domain:bus:device:function numbers of a VGA PCI device, and it will 
mount the VGA video RAM and allow files to exist there.
As a special hack: you can also specify the size of the active 
framebuffer console so that fbcon doesn't collide with this driver 
(unless you want to see what your files look like splattered across your 
screen, ha). The active VRAM area becomes a "sentinel" file named 
"framebuffer".

What do you guys think?

Jonathan Campbell
Impact Studio Pro

