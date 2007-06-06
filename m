Return-Path: <linux-kernel-owner+w=401wt.eu-S933331AbXFFPve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933331AbXFFPve (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 11:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754208AbXFFPv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 11:51:26 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:36424 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149AbXFFPvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 11:51:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZUmWw3HIBuv4RYzOrJbNOPAga94GiR6M8Yd06ejMgTtase3SOgg2i63NipWOUFYUiYdQDAAi1t8LBtvcoRwqq8uB10HBmPm1IjAhJMhprF5JO+Uz9eE66Ew0GYVuvVtwIWeU6EL2fJ0Si/5yk1bzI8mgAgxy3DdgzX1ubQSa23s=
Message-ID: <9a8748490706060851g59f3043ah82a0390ffc2b290b@mail.gmail.com>
Date: Wed, 6 Jun 2007 17:51:24 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Christoph Pleger" <Christoph.Pleger@cs.uni-dortmund.de>
Subject: Re: Size of kernel modules
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070606170534.67b5dea9.Christoph.Pleger@cs.uni-dortmund.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070606170534.67b5dea9.Christoph.Pleger@cs.uni-dortmund.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/07, Christoph Pleger <Christoph.Pleger@cs.uni-dortmund.de> wrote:
> Hello,
>
> I have a machine here which I installed with Ubuntu 7.04. Immediately
> after the installation had been finished, I installed the Ubuntu package
> which contains the Ubuntu-modified sources of the linux kernel. I
> extracted the resulting tar.bz2-file, copied the configuration of the
> currently running kernel to .config and created a file localversion-irb
> which contains the line "-irb" and then called "make menuconfig".

You forgot "make oldconfig". When you copy in a .config file from a
different kernel, always do oldconfig (just get in the habbit, if the
.config from the same kernel it's harmless).

> In the
> menu, I changed the CPU type from 586 to Pentium Pro and entered "-686"
> as the localversion. Finally, I used the Ubuntu tool make-kpkg with
> option "--initrd" to create a new kernel. The option "--initrd" causes
> the installation scripts of the kernel package to automatically create
> an initial ramdisk for the kernel.
>
> After the new kernel package had been created, I installed it. After
> that, I looked into the directory /boot and was very surprised: The
> initial ramdisk of the new kernel was much larger than the initrd of the
> old kernel. To find out the cause for this, I investigated how
> directories /lib/modules/$old and /lib/modules/$new differ. I found out
> that the filenames are the same, but the size of the files differs very
> much. I found a module file in the new directory that was almost five
> times as large as the file with the same name in the old directory.
>
> So, my question is the follwing: Is it an expected feature that the file
> sizes of modules grow so much only because of a different cpu type and a
> different localversion, or is there probably a bug in my build tools?
>
Compiling for a different CPU type will often change object file size,
but what you describe sounds extreme. I would have suspected something
along the lines of some debug options having been enabled - that would
more easily explain the large size difference.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
