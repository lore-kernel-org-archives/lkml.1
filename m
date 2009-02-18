Return-Path: <linux-kernel-owner+w=401wt.eu-S1751944AbZBRJVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944AbZBRJVe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 04:21:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753280AbZBRJUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 04:20:53 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:59358 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604AbZBRJUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 04:20:49 -0500
Date: Wed, 18 Feb 2009 10:20:47 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Alain Knaff <alain@knaff.lu>
cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: tip: bzip2/lzma now in tip:x86/setup-lzma
In-Reply-To: <499BBD62.5090506@knaff.lu>
Message-ID: <alpine.LSU.2.00.0902181012130.5116@fbirervta.pbzchgretzou.qr>
References: <200901042146.n04LkHgP005837@hitchhiker.hitchhiker.org.lu.hitchhiker.org.lu> <4961415C.1050708@zytor.com> <49614243.70102@knaff.lu> <496142E4.8040308@zytor.com> <49614491.7020903@knaff.lu> <49614D1F.8020900@zytor.com>
 <alpine.LSU.2.00.0902172202230.5620@fbirervta.pbzchgretzou.qr> <499B267E.2090509@zytor.com> <20090217220825.GA24337@elte.hu> <20090217233708.GA10756@elte.hu> <499B5BCA.8000905@zytor.com> <499BBD62.5090506@knaff.lu>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday 2009-02-18 08:48, Alain Knaff wrote:
>
>>  The sanest thing to do is to 
>> compress with all the compressors that are configured into the kernel, 
>> and then use the smallest image of the ones that can be produced, 
>> *including the uncompressed image*.
>
>... so, if I understood correctly, that would mean compressing the
>kernel 4 times, and keeping the smallest?
>Given the relatively low speed of compression, I feel that such a
>feature would really annoy people who compile their kernel often (such
>as kernel or module developers).

I would expect of *module* developers to build their code by means of
an out-of-tree directory, thereby not causing regeneration of the
vmlinux binary or initramfs image. Even if they stayed within the
Linux srctree, they could take a shortcut by explicitly stating the
target (`make that/foo.ko`). modpost is still something that takes
much more time with allmodconfig than compressing the kernel and/or
changed modules over and over.

>Btw, what *is* the standard work flow of supplying your own built-in
>initramfs? Do such developers usually supply a directory tree, or do
>they already cpio it before supplying it to the kernel? Or do they even
>compress it themselves?

As for me: a separate staging directory that is totally unrelated to
the Linux tree, and manually running the cpio command. And not
embodying it into the kernel because all bootloaders used so far
support reading an extra initramfs image.
