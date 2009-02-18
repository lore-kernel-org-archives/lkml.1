Return-Path: <linux-kernel-owner+w=401wt.eu-S1752576AbZBRKaM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576AbZBRKaM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 05:30:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbZBRK3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 05:29:54 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:44397 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304AbZBRK3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 05:29:53 -0500
Date: Wed, 18 Feb 2009 11:29:51 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Alain Knaff <alain@knaff.lu>
cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: tip: bzip2/lzma now in tip:x86/setup-lzma
In-Reply-To: <499BD795.6050602@knaff.lu>
Message-ID: <alpine.LSU.2.00.0902181127310.30241@fbirervta.pbzchgretzou.qr>
References: <200901042146.n04LkHgP005837@hitchhiker.hitchhiker.org.lu.hitchhiker.org.lu> <4961415C.1050708@zytor.com> <49614243.70102@knaff.lu> <496142E4.8040308@zytor.com> <49614491.7020903@knaff.lu> <49614D1F.8020900@zytor.com>
 <alpine.LSU.2.00.0902172202230.5620@fbirervta.pbzchgretzou.qr> <499B267E.2090509@zytor.com> <20090217220825.GA24337@elte.hu> <20090217233708.GA10756@elte.hu> <499B5BCA.8000905@zytor.com> <499BBD62.5090506@knaff.lu> <alpine.LSU.2.00.0902181012130.5116@fbirervta.pbzchgretzou.qr>
 <499BD795.6050602@knaff.lu>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday 2009-02-18 10:40, Alain Knaff wrote:
>> 
>> I would expect of *module* developers to build their code by means of
>> an out-of-tree directory, thereby not causing regeneration of the
>> vmlinux binary or initramfs image. Even if they stayed within the
>> Linux srctree, they could take a shortcut by explicitly stating the
>> target (`make that/foo.ko`). modpost is still something that takes
>> much more time with allmodconfig than compressing the kernel and/or
>> changed modules over and over.
>
>You are right of course for modules inserted by insmod modprobe. But what
>about people who tune parts that must be compiled-in (VFS layer, etc.), or
>that investigate a bug in a module that only occurs when it is compiled
>into the kernel?

The developer would then most likely just disable compression for
the time being.

>>[second topic]
>> As for me: a separate staging directory that is totally unrelated to
>> the Linux tree, and manually running the cpio command. And not
>> embodying it into the kernel because all bootloaders used so far
>> support reading an extra initramfs image.
>
>Interesting. If that is the case in general, for all developers of embedded
>systems, then we might be able to do away with compression of the built-in
>initramfs altogether, as proposed in the very early versions of my patch.

Even if it is true in general, I would not remove CONFIG_INITRAMFS_SOURCE
and attached logic, unless it were a major burden on the maintainers.
(I am not to quantify whether it is such a burden, or is not.)
