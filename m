Return-Path: <linux-kernel-owner+w=401wt.eu-S934458AbXJPX2E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934458AbXJPX2E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 19:28:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757188AbXJPX1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 19:27:47 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:46294 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754223AbXJPX1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 19:27:46 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kexec: Cannot determine the file type of arch/x86/boot/bzImage
References: <47151631.9000307@m3y3r.de>
Date: Tue, 16 Oct 2007 17:27:19 -0600
In-Reply-To: <47151631.9000307@m3y3r.de> (Thomas Meyer's message of "Tue, 16
	Oct 2007 21:51:13 +0200")
Message-ID: <m1zlyifxns.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Meyer <thomas@m3y3r.de> writes:

> Hi.
>
> Look at this:
>
> $ file arch/x86/boot/bzImage (tree 821f3eff7cdb9d6c7076effabd46c96c322daed1)
> arch/x86/boot/bzImage: Linux kernel x86 boot executable zImage, version
> 2.6.23 (thomas@hotzenplotz) #39, RO-rootFS, root_dev 0x803, swap_dev
> 0x1, Prompt for Videomode
>
> $ file /boot/bzImage-2.6.23
> /boot/bzImage-2.6.23: Linux kernel x86 boot executable RO-rootFS,
> root_dev 0x803, swap_dev 0x1, Normal VGA
>
> and this:
>
> # kexec -l arch/x86/boot/bzImage
> Cannot determine the file type of arch/x86/boot/bzImage
>
> How to solve this error?

Looks like a kbuild error was causing us to build zImage kernels
instead of bzImage kernels on x86 and thus kexec didn't recognize
the format and so refused to boot it.

Eric
