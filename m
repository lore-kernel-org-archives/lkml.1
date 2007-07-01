Return-Path: <linux-kernel-owner+w=401wt.eu-S1758185AbXGAQdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185AbXGAQdU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 12:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753649AbXGAQdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 12:33:12 -0400
Received: from gw.goop.org ([64.81.55.164]:56753 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752226AbXGAQdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 12:33:10 -0400
Message-ID: <4687D744.6000103@goop.org>
Date: Sun, 01 Jul 2007 09:33:08 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>, Andi Kleen <ak@suse.de>,
       chrisw@sous-sol.org, xen-devel@lists.xensource.com,
       linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@in.ibm.com>
Subject: Re: 2.6.22-rc6-mm1: Xen: WARNING: Absolute relocations present
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>	<20070628204001.GA6087@stusta.de> <46841EC4.7080805@goop.org> <m1hcoorv79.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1hcoorv79.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Jeremy Fitzhardinge <jeremy@goop.org> writes:
>
>   
>> Adrian Bunk wrote:
>>     
>>> <--  snip  -->
>>>
>>> ...
>>>   RELOCS  arch/i386/boot/compressed/vmlinux.relocs
>>> WARNING: Absolute relocations present
>>> Offset     Info     Type     Sym.Value Sym.Name
>>> c0101f80 020c6501   R_386_32 00000000  xen_irq_disable_direct_reloc
>>> c0101f9a 0221ea01   R_386_32 00000000  xen_save_fl_direct_reloc
>>> ...
>>>
>>> <--  snip  -->
>>>
>>>       
>> Hm.  Those are false alarms.  I guess I could do something to hide them, but
>> there's nothing inherently wrong with correctly used abs symbols.  Is there
>> someway to whitelist them?
>>     
>
> Yes.  Just add them to arch/i386/boot/compressed/relocs.c safe_abs_syms.
>   

OK, how's this?

Subject: xen: suppress abs symbol warnings for unused reloc pointers

The Xen code generates some abs symbols which are OK from a relocation
perspective.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Adrian Bunk <bunk@stusta.de>

---
 arch/i386/boot/compressed/relocs.c |    2 ++
 1 file changed, 2 insertions(+)

===================================================================
--- a/arch/i386/boot/compressed/relocs.c
+++ b/arch/i386/boot/compressed/relocs.c
@@ -31,6 +31,8 @@ static const char* safe_abs_relocs[] = {
 		"__kernel_rt_sigreturn",
 		"__kernel_sigreturn",
 		"SYSENTER_RETURN",
+		"xen_irq_disable_direct_reloc",
+		"xen_save_fl_direct_reloc",
 };
 
 static int is_safe_abs_reloc(const char* sym_name)


