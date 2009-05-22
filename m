Return-Path: <linux-kernel-owner+w=401wt.eu-S1757247AbZEVQfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247AbZEVQfn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 12:35:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752133AbZEVQfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 12:35:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55575 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbZEVQfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 12:35:36 -0400
Message-ID: <4A16D3DF.5000600@zytor.com>
Date: Fri, 22 May 2009 09:33:35 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Xin, Xiaohui" <xiaohui.xin@intel.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Chuck Ebbert <cebbert@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, "Li, Xin" <xin.li@intel.com>,
       "Nakajima, Jun" <jun.nakajima@intel.com>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: Performance overhead of paravirt_ops on native identified
References: <4A0B62F7.5030802@goop.org> <20090521184233.3c3e97ad@dhcp-100-2-144.bos.redhat.com> <4A15DA4E.2090505@goop.org> <C85CEDA13AB1CF4D9D597824A86D2B9005760A96DA@PDSMSX501.ccr.corp.intel.com> <4A1629BA.9070309@goop.org> <C85CEDA13AB1CF4D9D597824A86D2B9005760A9940@PDSMSX501.ccr.corp.intel.com>
In-Reply-To: <C85CEDA13AB1CF4D9D597824A86D2B9005760A9940@PDSMSX501.ccr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xin, Xiaohui wrote:
> What I mean is that if the binary of _spin_lock is like this:
> (gdb) disassemble _spin_lock
> Dump of assembler code for function _spin_lock:
> 0xffffffff80497c0f <_spin_lock+0>:      mov    1252634(%rip),%r11        # #0xffffffff805c9930 <test_lock_ops+16>
> 0xffffffff80497c16 <_spin_lock+7>:      jmpq   *%r11
> End of assembler dump.
> (gdb) disassemble
> 
> In this situation the binary contains a jump, the overhead is more than the call.
> 

That's an indirect jump, though.  I don't think anyone was suggesting
using an indirect jump; the final patched version should be a direct
jump (instead of a direct call.)

I can see how indirect jumps might be slower, since they are probably
not optimized as aggressively in hardware as indirect calls -- indirect
jumps are generally used for switch tables, which often have low
predictability, whereas indirect calls are generally used for method
calls, which are (a) incredibly important for OOP languages, and (b)
generally highly predictable on the dynamic scale.

However, direct jumps and calls don't need prediction at all (although
of course rets do.)

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

