Return-Path: <linux-kernel-owner+w=401wt.eu-S1760882AbXHIUao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760882AbXHIUao (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 16:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754288AbXHIUag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 16:30:36 -0400
Received: from wx-out-0506.google.com ([66.249.82.238]:27273 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195AbXHIUaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 16:30:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nVxamyAVq+JUqwzn3573KBSawVnvTrM+hIZhszP3PoNZyYzi/uCqfugWsxQNwFugz9oI0qxtiHdnnkdUXTqmrJIw0VRS3opgnIW0RCFAcxPuQepmVlvuQo+0B/m0tTppw//4xU/r4iZFS6LF2e348s2tGcMdoirST/K2KUJxl7A=
Message-ID: <9a8748490708091330u687f2ca8sc85b7696be420973@mail.gmail.com>
Date: Thu, 9 Aug 2007 22:30:33 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.23-rc2-mm1
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070809015106.cd0bfc53.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070809015106.cd0bfc53.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/07, Andrew Morton <akpm@linux-foundation.org> wrote:
...
> - If there's a patch in here which you think should be in 2.6.23 but I do
>   not have it designated in that way, please be sure to let me know.
...

Well, if you want to clean up your patch queue a bit then I have a few
suggestions for some patches of mine that are currently in -mm that
you could push to Linus.  They are not really important, so if you'd
rather keep them around in -mm until the next merge window then that's
fine by me, but they should be safe to push and would get cut down on
the number of patches you track a bit :-)


This fix was already merged for the ati side of things, this is an
identical fix for the amd side of things - I see no reason why we
shouldn't get this fix into 2.6.23 as well :

 fix-use-after-free--double-free-bug-in-amd_create_gatt_pages--amd_free_gatt_pages.patch


This patch only changes the output of the script when run without
arguments, so as far as building the kernel goes it can't cause any
regressions and it's a clear improvement over what we currently have,
so might as well get it out of your queue and upstream :

 improve-scripts-gcc-versionsh-output-a-bit-when-called-without-args.patch


When people use scripts/ver_linux in bugreports we want correct info -
currently we often print wrong info for the binutils version. This
patch doesn't hurt existing working scenarios but does fix a few
broken ones, might as well get that merged, it's a clear fix :

 scripts-ver_linux-correct-printing-of-binutils-version.patch


These should all be trivially correct since they just remove duplicate
#include's of the same header into a .c file outside any #ifdef and
similar magic, so they should be quite safe to push. Also, I haven't
seen anything but ACK's in response to them (when I've seen a
response), and a few of my similar patches have already been merged :

 powerpc-clean-out-a-bunch-of-duplicate-includes.patch
 clean-up-duplicate-includes-in-drivers-input.patch
 clean-up-duplicate-includes-in-drivers-net.patch
 clean-up-duplicate-includes-in-drivers-atm.patch
 clean-up-duplicate-includes-in-net-atm.patch
 clean-up-duplicate-includes-in-net-ipv4.patch
 clean-up-duplicate-includes-in-net-ipv6.patch
 clean-up-duplicate-includes-in-net-sched.patch
 clean-up-duplicate-includes-in-net-sunrpc.patch
 clean-up-duplicate-includes-in-net-tipc.patch
 clean-up-duplicate-includes-in-net-xfrm.patch
 clean-up-duplicate-includes-in-include-linux-nfs_fsh.patch
 clean-up-duplicate-includes-in-fs-ntfs.patch
 clean-up-duplicate-includes-in-drivers-scsi.patch
 clean-up-duplicate-includes-in-drivers-block.patch
 clean-up-duplicate-includes-in-arch-i386-xen.patch
 clean-up-duplicate-includes-in-include-linux-memory_hotplugh.patch
 clean-up-duplicate-includes-in-mm.patch
 clean-up-duplicate-includes-in-drivers-char.patch
 clean-up-duplicate-includes-in-drivers-w1.patch
 clean-up-duplicate-includes-in-fs.patch
 clean-up-duplicate-includes-in-fs-ecryptfs.patch
 clean-up-duplicate-includes-in-kernel.patch
 clean-up-duplicate-includes-in-drivers-spi.patch
 clean-up-duplicate-includes-in-documentation.patch


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
