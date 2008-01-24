Return-Path: <linux-kernel-owner+w=401wt.eu-S1756958AbYAXUMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756958AbYAXUMb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 15:12:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbYAXUMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 15:12:23 -0500
Received: from fk-out-0910.google.com ([209.85.128.186]:26456 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbYAXUMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 15:12:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=EHC5wFlX5Hg69kFCzMd5A6NiysqCUCnYyOsKfoynEXxLbQJOh99rLI90YyQrhUweb7raOqIqLztG+QxquPZExTQfRuPP0MK8aH76Nd+XuD4QSsNjSwl5FgYu6wy2s5iN1thh2j9r32+9Z+Tb9h5ZQwfBQ+esjRypXd4/80smKmE=
Message-ID: <4798F11C.2020105@gmail.com>
Date: Thu, 24 Jan 2008 23:12:12 +0300
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Organization: DmVo Home
User-Agent: Thunderbird 1.5.0.14pre (X11/20071022)
MIME-Version: 1.0
To: Michael Opdenacker <michael-lists@free-electrons.com>
CC: Matt Mackall <mpm@selenic.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Linux-tiny@selenic.com,
       Thomas Gleixner <tglx@linutronix.de>, ralf@linux-mips.org
Subject: Re: [PATCH] x86: fix unconditional arch/x86/kernel/pcspeaker.c?compiling
References: <200801171643.49301.michael-lists@free-electrons.com> <4790D3E3.4060409@free-electrons.com> <1200676219.3835.8.camel@cinder.waste.org> <200801232330.12331.michael-lists@free-electrons.com>
In-Reply-To: <200801232330.12331.michael-lists@free-electrons.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Opdenacker пишет:
> On Friday 18 January 2008, Matt Mackall wrote:
>> Probably makes sense to define it right next to INPUT_PCSPKR in
>> drivers/input/Kconfig.
>>
>> Then do the appropriate fix for all arches mentioned in INPUT_PCSPKR.
>>
>> For extra points, you can move the duplicate pcspeaker.c code out of all
>> those arches and stash it somewhere in drivers/input. Presumably it's
>> possible to get it to link into the kernel even when INPUT is modular.
> 
> Here's the patch, after spending some time to get familiar with git.
> 
> The patch is against git x86/mm, and it seems to work fine on x86. However,
> on x86, you no longer have /sys/devices/platform/pcspkr after
> running "make allnoconfig". To get it, you have to explicitely add support
> to CONFIG_INPUT_PCSPKR (m or y). I hope this is fine.
> 
> I'm copying the MIPS maintainer as this patch touches his tree too.

This patch does not apply cleanly to linux-mips Git tree:

----> snip
patching file arch/x86/kernel/Makefile
Hunk #1 FAILED at 69.
1 out of 1 hunk FAILED -- saving rejects to file arch/x86/kernel/Makefile.rej
----> snip

I believe this is because the linux-mips tree and the -mm tree are not in sync.

> 
> On MIPS, there should be no impact though, as CONFIG_PCSPEAKER is set in
> defconfig files.
> 
> In other architectures where CONFIG_INPUT_PCSPKR can exist,
> there is a change: when CONFIG_INPUT_PCSPKR is set, the platform device
> will be added, while it didn't exist before. I hope this is fine.
> 

It seems tempting to include at least Alpha in this patch, because they
have a device initcall identical to the one, which you're removing from
the MIPS and x86 arch code.

Thanks,

Dmitri
