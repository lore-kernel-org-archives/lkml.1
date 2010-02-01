Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab0BAPEs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 10:04:48 -0500
Received: from mail-bw0-f223.google.com ([209.85.218.223]:50966 "EHLO
	mail-bw0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755140Ab0BAPEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 10:04:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=vKSyktwI1nkS9r8MPgCrF0bUvi4wKL0lhJKGyPVrOU/+1fOOhHGpzscbTlQZ5U29w3
         Mnm2i62ddqVTrA+NPvf1AvUIgJv8OJ+62ntIxiX+P1Z1l2I+fCYivwUTor6gJIBmSpBK
         5F8PTrnuxgJ1hmtBuUIj6JmunuWg2vgyODHaU=
MIME-Version: 1.0
In-Reply-To: <9ea470501002010557o45bad81cp5d9ac3d19318bffe@mail.gmail.com>
References: <A1D71FDC-3176-4792-83ED-3ACAA3D61CFF@cs.otago.ac.nz>
	 <20100130171804.GA2348@liondog.tnic>
	 <AD1C7BB3-C3E6-47EC-809F-4CE3C049D92C@cs.otago.ac.nz>
	 <9ea470501002010557o45bad81cp5d9ac3d19318bffe@mail.gmail.com>
Date: Mon, 1 Feb 2010 16:04:42 +0100
Message-ID: <9ea470501002010704m15dfaedau813b7accfd1d22ff@mail.gmail.com>
Subject: Re: nr_cpu_ids incorrect on AMD Quad-Core Opteron 8380
From: Borislav Petkov <petkovbb@googlemail.com>
To: zhiyi <zhuang@cs.otago.ac.nz>
Cc: linux-kernel@vger.kernel.org, Zhiyi Huang <hzy@cs.otago.ac.nz>,
       jkmair@cs.otago.ac.nz
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 1, 2010 at 2:57 PM, Borislav Petkov <petkovbb@googlemail.com> wrote:
> On Sun, Jan 31, 2010 at 11:59 PM, zhiyi <zhuang@cs.otago.ac.nz> wrote:
>> My module worked for a kernel 2.6.29 with CONFIG_NR_CPUS=64 on my dual
>> quad-core AMD Opteron. The value of nr_cpu_ids I got from the same module
>> was correct (8).
>
> This could mean that your include/generated/autoconf.h, which is used by
> external modules, is not updated and contains CONFIG_NR_CPUS=8. Do
>
> make mrproper
>
> in your kernel directory by moving your .config out of the way first and
> then rebuild your kernel and external module(s). nr_cpu_ids should pick
> up the updated CONFIG_NR_CPUS value from your .config.

That's actually not necessary - the nr_cpu_ids thing is set at compile
time to CONFIG_NR_CPUS but then capped to a possibly lower value upon
boot depending on the info in the ACPI mptables. Can you please send the
.config and the full dmesg of the quadsocket machine?

Thanks.

-- 
Regards/Gruss,
Boris
