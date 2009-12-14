Return-Path: <linux-kernel-owner+w=401wt.eu-S1758839AbZLNX4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758839AbZLNX4M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 18:56:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758818AbZLNX4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 18:56:09 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:39636 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758766AbZLNX4D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 18:56:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=HBsY/RjVRl2C5MiTDuq85raWQldJHgt6+GK2Rq4M4AcMp2QndhEHcy36grHpNVXhL6
         zY7Ias85hBgm3MHFaBBTfUP6KFYTsXhAAHpV9eKg4vWemG8jfqJl/hx8Sk2WRDqvlNHx
         HDN6Dq+FZ7kH21zIY/ms1P1+dTe+sHpIYt90k=
MIME-Version: 1.0
In-Reply-To: <20091210135816.6325.37536.stgit@warthog.procyon.org.uk>
References: <20091210135755.6325.78149.stgit@warthog.procyon.org.uk> 
	<20091210135816.6325.37536.stgit@warthog.procyon.org.uk>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 14 Dec 2009 18:55:43 -0500
Message-ID: <8bd0f97a0912141555l103e4833k1ffae12f6924a9a4@mail.gmail.com>
Subject: Re: [PATCH 5/7] NOMMU: Avoiding duplicate icache flushes of shared 
	maps
To: David Howells <dhowells@redhat.com>
Cc: lethal@linux-sh.org, jie.zhang@analog.com, stefani@seibold.net,
       gerg@snapgear.com, uclinux-dev@uclinux.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 10, 2009 at 08:58, David Howells wrote:
> From: Mike Frysinger <vapier.adi@gmail.com>
>
> When working with FDPIC, there are many shared mappings of read-only code
> regions between applications (the C library, applet packages like busybox,
> etc.), but the current do_mmap_pgoff() function will issue an icache flush
> whenever a VMA is added to an MM instead of only doing it when the map is
> initially created.
>
> The flush can instead be done when a region is first mmapped PROT_EXEC.  Note
> that we may not rely on the first mapping of a region being executable - it's
> possible for it to be PROT_READ only, so we have to remember whether we've
> flushed the region or not, and then flush the entire region when a bit of it is
> made executable.
>
> However, this also affects the brk area.  That will no longer be executable.
> We can mprotect() it to PROT_EXEC on MPU-mode kernels, but for NOMMU mode
> kernels, when it increases the brk allocation, making sys_brk() flush the extra
> from the icache should suffice.  The brk area probably isn't used by NOMMU
> programs since the brk area can only use up the leavings from the stack
> allocation, where the stack allocation is larger than requested.

this works fine for me, thanks.
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
-mike
