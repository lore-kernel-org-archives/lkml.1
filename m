Return-Path: <linux-kernel-owner+w=401wt.eu-S1752525AbZGYVru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525AbZGYVru (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 17:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251AbZGYVru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 17:47:50 -0400
Received: from perceval.irobotique.be ([92.243.18.41]:60864 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbZGYVrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 17:47:49 -0400
X-Greylist: delayed 440 seconds by postgrey-1.27 at vger.kernel.org; Sat, 25 Jul 2009 17:47:49 EDT
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: linux-kernel@vger.kernel.org
Subject: Should I use kmap or kmap_atomic to map user pages that will be written in a loop ?
Date: Sat, 25 Jul 2009 23:41:47 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.30; KDE/4.2.4; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907252341.48526.laurent.pinchart@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everybody,

I'm trying to implement the USERPTR V4L2 streaming I/O method in the uvcvideo 
driver. In a nutshell, that methods uses userspace-allocated buffers to 
transfer video data from kernelspace to userspace. The buffers are reused 
during the whole video stream in a circular fashion.

The kernel driver receives userspace pointers to those buffers, which can have 
been allocated using different methods (malloc, Xv alloc, mmap() on a reserved 
memory region, ...). I get the list of underlying pages using 
get_user_pages(), and I then need to map those pages to the kernel virtual 
address space.

Pages will be written to from the kernel in USB interrupt context. I can then 
either kmap_atomic() pages before copying data and kunmap_atomic() them right 
after, or kmap() them once at the beginning of the video stream and keep them 
mapped until the end.

As I don't have much experience with the memory management subsystem, I'd 
appreciate if someone could give me a few advices regarding the best way to 
proceed. kmap() is expensive, but it would only be called once, while 
kmap_atomic() would be called many times (4500 times per second for a 640x480 
30fps video stream). On the other hand, I'm not sure how much pressure keeping 
all those kmap() pages mapped into kernel virtual memory for a long time would 
put on the memory subsystem.

Please CC me on answers.

Regards,

Laurent Pinchart

