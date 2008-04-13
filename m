Return-Path: <linux-kernel-owner+w=401wt.eu-S1755195AbYDMSUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195AbYDMSUx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 14:20:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbYDMSUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 14:20:45 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:25440 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbYDMSUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 14:20:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZrYLR8dsecR0zn+kPKTp9fM1+YPySlSs3bAtUxfhkttk+Cf3CBCeaY8u6nPxJ8vRFs5JxU3DFyBymNiD5yUJULlxBfBcWOUJ+3tiVcr81wUng1ApOx4pbdhpfY/X8yU/Jh0ePauKLYkNB5/c1PAdS6ZgtFUtyPwr2QtC4LdgxFE=
Message-ID: <9a8748490804131120p4dfa2af1j4ead4f28ada45d4f@mail.gmail.com>
Date: Sun, 13 Apr 2008 20:20:41 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: monte <monte@eslashlonghorns.com>
Subject: Re: kernel bug
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <48022F82.80704@eslashlonghorns.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48022F82.80704@eslashlonghorns.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/04/2008, monte <monte@eslashlonghorns.com> wrote:
> Since I am new at this, this is the info you may need.
>
There's a very good document describing information kernel developers
may need when reporting kernel bugs. It's called 'REPORTING-BUGS' and
can be found in the root of the kernel source tree - here's a link to
an online copy: http://lxr.linux.no/linux+v2.6.24.4/REPORTING-BUGS

>  I am trying to using Ubuntu hardy (development branch), Kernel 2.6.24-16,

That's a distribution kernel, not a stock kernel.org kernel. As a
general rule, kernel developers at kernel.org have a hard time
providing help with distribution kernels since almost all
distributions take the kernel.org kernel and then add patches of their
own to it. This makes it hard for kernel.org people to know if the bug
you have hit is due to a distribution specific patch or not.
For this reason it's generally a good idea to verify the problem with
a kernel.org kernel - usually testing the latest released kernel as
well as the latest pre-release kernel and providing information on
whether or not the problem occurs with them is very valuable info (in
this case, the kernels to test would then be 2.6.24.4 and 2.6.25-rc9,
sources for both are available at http://kernel.org/ ).

> and get the following error
>
>  error 18: selected cylinder exceeds maximum supported by BIOS.
>

That's not a kernel problem. It's a problem with your bootloader.
For details on this specific error and what to do about it, take a
look at http://wiki.linuxquestions.org/wiki/GRUB#Error_18

>  This started with kernel 2.6.24-15.  Currently I have to boot into kernel
> 2.6.24-14.
>
I'd guess that you do not have a sepperate /boot partitions where you
keep your kernels (or if you do it's not at the start of your disk).
The fact that your 2.6.24-14 kernel boots and your 2.6.24-15 does not
probably has to do with the -14 one being placed within the first 1024
cyl of the disk (probably purely by luck) and the -15 was placed
elsewhere. The way to ensure that they always end up within the first
1024cyl that your BIOS can handle is by having a /boot partition at
the start of the disk that is <=512MB and then always place your
kernels there.

>  My BIOS are Award Modular Bios v4.51PC, with Award Plug and Play Bios ext
> v1.0A
>
If a BIOS update is available it's possible it could resolve the issue
by allowing the BIOS to see more than the first 1024 cylinders of the
disk, but with a system as old as this I doubt it very much.

Hope that helps you.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
