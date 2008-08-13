Return-Path: <linux-kernel-owner+w=401wt.eu-S1755755AbYHMJIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755AbYHMJIT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 05:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754121AbYHMJII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 05:08:08 -0400
Received: from saeurebad.de ([85.214.36.134]:33608 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753169AbYHMJIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 05:08:06 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jan Beulich <jbeulich@novell.com>,
       Linus Torvalds <torvalds@linux-foundation.org>, dhowells@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Propagate new nonpanic bootmem macros to CONFIG_HAVE_ARCH_BOOTMEM_NODE
References: <87skt99vmz.fsf@skyscraper.fehenstaub.lan>
	<48A2B7BA.76E4.0078.0@novell.com> <20080813085509.GC23417@elte.hu>
Date: Wed, 13 Aug 2008 11:07:41 +0200
In-Reply-To: <20080813085509.GC23417@elte.hu> (Ingo Molnar's message of "Wed,
	13 Aug 2008 10:55:09 +0200")
Message-ID: <87k5el9tb6.fsf@skyscraper.fehenstaub.lan>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Ingo Molnar <mingo@elte.hu> writes:

> * Jan Beulich <jbeulich@novell.com> wrote:
>
>> Sorry for not noticing this:
>> Acked-by: Jan Beulich <jbeulich@novell.com>
>> 
>> >>> Johannes Weiner <hannes@saeurebad.de> 13.08.08 10:17 >>>
>> Commit 74768ed833344b "page allocator: use no-panic variant of
>> alloc_bootmem() in alloc_large_system_hash()" introduced two new
>> _nopanic macros which are undefined for CONFIG_HAVE_ARCH_BOOTMEM_NODE.
>> 
>> Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
>
> btw., i dont think the fix is complete, a quick grep shows:
>
>   arch/avr32/Kconfig:config HAVE_ARCH_BOOTMEM_NODE

Uhm, I think a fix for that would be removing the knob from the avr32
Kconfig.  It defaults to n and I couldn't find a place where this gets
enabled.

Furthermore, there doesn't seem to be any arch-specific code associated
with it (grep -R ARCH_BOOTMEM_NODE arch/avr32).

	Hannes
