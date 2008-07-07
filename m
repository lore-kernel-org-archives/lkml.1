Return-Path: <linux-kernel-owner+w=401wt.eu-S1755741AbYGGQdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741AbYGGQdf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 12:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753475AbYGGQd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 12:33:27 -0400
Received: from [194.117.236.238] ([194.117.236.238]:39780 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753358AbYGGQd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 12:33:26 -0400
Date: Mon, 7 Jul 2008 19:33:09 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Josh Boyer <jwboyer@gmail.com>
Cc: Jinkai Gao <mickeygjk@gmail.com>, Jan Engelhardt <jengelh@medozas.de>,
       linux-kernel@vger.kernel.org
Subject: Re: Suggestion: LKM should be able to add system call for itself
Message-ID: <20080707193309.18180945@linux360.ro>
In-Reply-To: <1215440211.20774.48.camel@weaponx>
References: <fb82a8210807062209t6cfe3e46m50a11b577f0540e7@mail.gmail.com>
	<alpine.LNX.1.10.0807071131010.8248@fbirervta.pbzchgretzou.qr>
	<fb82a8210807070700u4f191bfaq57df57c293567e4c@mail.gmail.com>
	<1215440211.20774.48.camel@weaponx>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 Jul 2008 10:16:51 -0400
Josh Boyer <jwboyer@gmail.com> wrote:

> > You are right. So we can use ascii name instead of number to
> > identify the system call. Kernel will match the function with the
> > name.To have backward compatibility, number should still be
> > supported. Yes, it is not as easy as I thought, but as long as it
> > is valuable and doable, we should have a try, right?
> 
> So you have to search a list of strings using strcmp to determine what
> syscall is being called?  That would be horrible for performance.
> 
> josh
> 

Actually it isn't that bad if you do it like dlsym()/dlopen() do it in
userspace. That is, have the system linker fill in dynamic syscalls,
possibly in a separate ELF section. This way you could version syscalls.

Furthermore, it may make sense to implement all syscalls through glibc,
so that the burden of maintaining obsolete/modified syscalls does not
fall onto the kernel. This already happens for most syscalls, but the
rest (mostly those Linux-specific) still rely on syscall numbers
defined as macros.

But that still will _not_ solve the problem, because:
- there are users which will only use older libc versions
- there are statically linked executables
- the modified/new syscall might not provide the same behavior, even
when used through a compatibility (glibc) wrapper

IOW, this problem can be reduced to any other instance where protocols
or APIs get changed. This usually isn't a problem, but the kernel can't
afford bloat to maintain compatibility.

I hope this makes the issue more clear.


	Cheers,
	Eduard
