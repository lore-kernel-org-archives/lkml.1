Return-Path: <linux-kernel-owner+w=401wt.eu-S1754697AbYIHPux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697AbYIHPux (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 11:50:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752754AbYIHPun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 11:50:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38435 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbYIHPun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 11:50:43 -0400
Message-ID: <48C549AC.1030406@kernel.org>
Date: Mon, 08 Sep 2008 08:50:04 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>, linux@sandersweb.net,
       linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>,
       Andi Kleen <andi-suse@firstfloor.org>
Subject: Re: [BUG] x86 kenel won't boot under Virtual PC
References: <200808311422.12525.linux@sandersweb.net> <200809071922.32974.linux@sandersweb.net> <48C48467.40703@zytor.com> <200809072249.17280.linux@sandersweb.net> <48C4A46B.90705@zytor.com> <alpine.LFD.1.10.0809080805240.3117@nehalem.linux-foundation.org> <20080908154535.GL26079@one.firstfloor.org> <48C54839.8050304@zytor.com>
In-Reply-To: <48C54839.8050304@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> 
> The help text is indeed out of date.  I did a patch yesterday to, among 
> other things, update it; I also want to verify that we are disabling all 
> options that can cause gcc or binutils to generate nopl's; I plan to 
> push it today.
> 

OK, turns out that is already happending, by virtue of:

# add at the end to overwrite eventual tuning options from earlier
# cpu entries
cflags-$(CONFIG_X86_GENERIC)    += $(call tune,generic,$(call tune,i686))

-mtune=generic on 32-bit CPUs disable NOPL generation, and any 
gcc/binutils combo too old to have -mtune=generic won't generate them at 
all.

I think I verified this some time in the past, but I just had to refresh 
my memory.  This was a major reason to put this functionality on 
CONFIG_X86_GENERIC.

	-hpa
