Return-Path: <linux-kernel-owner+w=401wt.eu-S1761160AbZAMXm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761160AbZAMXm7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 18:42:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760910AbZAMXm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 18:42:26 -0500
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:45696 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760899AbZAMXmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 18:42:24 -0500
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: The policy on initramfs decompression failure
To: "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Al Viro <viro@ftp.linux.org.uk>, Alain Knaff <alain@knaff.lu>
Reply-To: 7eggert@gmx.de
Date: Wed, 14 Jan 2009 00:42:17 +0100
References: <bU0fj-7Ap-43@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1LMstm-0001QW-7i@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin <hpa@zytor.com> wrote:

[initramfs decryption failed]

> I had personally assumed the proper policy would be to panic, since it
> is unlikely to mean the system can be booted.  However, Ingo brought up
> the case where the initramfs is auxilliary to being able to boot the
> full system, for example the initramfs supplied is primarily a data
> carrier, and either the builtin initramfs or the kernel itself is
> sufficient to boot.
> 
> By this argument, we should change initramfs decoding failure to a
> KERN_CRIT message, and in the (presumably most common) case that it does
> not suffice to boot the system, we will get a panic in short order as
> the system is unable to find init.
> 
> This argument seems to mostly hold water, but it does implement a policy
> change over the current code.  Furthermore, it does make me concerned
> that a *partial* decoding failure (such as can be caused by a corrupt
> image, or, say, a gzipped image concatenated to a bzip2 image, with the
> kernel only supporting bzip2) could cause a booted-but-dysfunctional
> system, which is in many configurations a worse failure mode than a panic.

If the initrd is not decompressed successfully, and if it's not there for fun,
the system boot will be most likely fubar, and at worst a wrong system or a
less secured configuration may be started. Therefore I'd create a kernel
option. Possible values would be e.g. [*panic,continue] or 
[*auto|required|optional|ignore], with:

panic, continue: As expected
auto: If there is an initrd, it's required, otherwise it's ignored
required: Panic if the initrd did not exist or was not unpacked correctly
optional: Like continue
ignore: Don't load the initrd
*: Default value

I currently don't know how to name the option.

