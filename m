Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130Ab0BOVIT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 16:08:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33550 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756300Ab0BOVIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 16:08:18 -0500
Message-ID: <4B79A996.2090606@zytor.com>
Date: Mon, 15 Feb 2010 12:07:50 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Oleg Nesterov <oleg@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: x86: get rid of the insane TIF_ABI_PENDING bit
References: <20100215161752.GA19962@redhat.com>	<4B799C3F.7010308@zytor.com> <20100215194123.96D49FC3@magilla.sf.frob.com>
In-Reply-To: <20100215194123.96D49FC3@magilla.sf.frob.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2010 11:41 AM, Roland McGrath wrote:
>> I suspect the purpose of TS_COMPAT is actually so you can ptrace() the
>> newly exec'd process (and see it as a 32-bit process!) before it returns
>> to userspace.  The comment, obviously, is wrong -- that again refers to
>> TIF_IA32.
> 
> I don't follow you.  TS_COMPAT does not affect ptrace.
> It affects syscall-audit, but only at syscall entry time.
> It affects asm/syscall.h accessors, but ptrace does not use those.
> It affects whatever uses is_compat_task(), but I can't see anything
> where that matters except inside some particular syscall or for
> syscall restart after signals.
> 
> TS_COMPAT does not affect the syscall return machinery itself.
> The return path just follows from the particular entry path.

It's entirely possible it is completely superfluous.  The patch in
question only moves the setting.  I don't know what gdb or strace use to
distinguish a 32-bit and a 64-bit process, which is why I thought it
might have something to do with ptrace.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

