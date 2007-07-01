Return-Path: <linux-kernel-owner+w=401wt.eu-S1759438AbXGAUgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759438AbXGAUgy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 16:36:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757968AbXGAUgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 16:36:47 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:59495 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757604AbXGAUgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 16:36:46 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>, Andi Kleen <ak@suse.de>,
       chrisw@sous-sol.org, xen-devel@lists.xensource.com,
       linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@in.ibm.com>
Subject: Re: 2.6.22-rc6-mm1: Xen: WARNING: Absolute relocations present
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
	<20070628204001.GA6087@stusta.de> <46841EC4.7080805@goop.org>
	<m1hcoorv79.fsf@ebiederm.dsl.xmission.com> <4687D744.6000103@goop.org>
Date: Sun, 01 Jul 2007 14:31:44 -0600
In-Reply-To: <4687D744.6000103@goop.org> (Jeremy Fitzhardinge's message of
	"Sun, 01 Jul 2007 09:33:08 -0700")
Message-ID: <m1bqevsw5r.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> Eric W. Biederman wrote:
>> Jeremy Fitzhardinge <jeremy@goop.org> writes:
>>
>>
>>> Adrian Bunk wrote:
>>>
>>>> <--  snip  -->
>>>>
>>>> ...
>>>>   RELOCS  arch/i386/boot/compressed/vmlinux.relocs
>>>> WARNING: Absolute relocations present
>>>> Offset     Info     Type     Sym.Value Sym.Name
>>>> c0101f80 020c6501   R_386_32 00000000  xen_irq_disable_direct_reloc
>>>> c0101f9a 0221ea01   R_386_32 00000000  xen_save_fl_direct_reloc
>>>> ...
>>>>
>>>> <--  snip  -->
>>>>
>>>>
>>> Hm.  Those are false alarms.  I guess I could do something to hide them, but
>>> there's nothing inherently wrong with correctly used abs symbols.  Is there
>>> someway to whitelist them?
>>>
>>
>> Yes.  Just add them to arch/i386/boot/compressed/relocs.c safe_abs_syms.
>>
>
> OK, how's this?
>
> Subject: xen: suppress abs symbol warnings for unused reloc pointers
>
> The Xen code generates some abs symbols which are OK from a relocation
> perspective.

Actually I have to ask.  How in the world are these absolute symbols
ok from a relocation perspective.

If the kernel is not running at 0xc0100000 the offset value looks like
it will be completely bogus.

Maybe those are ok, but if you could please explain why those are
false positives I would appreciate it. (Especially in your patch
description).

If these are indeed false positives the patch looks ok.

Eric
