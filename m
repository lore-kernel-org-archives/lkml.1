Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424Ab0BJCDk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 21:03:40 -0500
Received: from mail-ww0-f46.google.com ([74.125.82.46]:52567 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755112Ab0BJCDj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 21:03:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=f6CN3R5JkLCtL5HvSbcIo9Mxl90M0leOrTT89cAIiSIW7fhnBFhgHSEVWdox1H8Si4
         VG7Kst/bRtImnbeflCdUjKiefDYL0Goza0ABh/18PEinFSk/UyXlnr3FG9UwS3UTH2QQ
         AMu8KnVAUg+GOtQY9d2hLIE2syxkC+6VhSjdQ=
MIME-Version: 1.0
In-Reply-To: <20100210015257.942463E8@magilla.sf.frob.com>
References: <20100209201309.902050211@sbs-t61.sc.intel.com>
	 <20100209202502.406177090@sbs-t61.sc.intel.com>
	 <20100210015257.942463E8@magilla.sf.frob.com>
Date: Tue, 9 Feb 2010 18:03:33 -0800
Message-ID: <6dc9ffc81002091803o5f5cc632sfd7fad0b41545a97@mail.gmail.com>
Subject: Re: [patch v2 4/4] ptrace: Add support for generic 
	PTRACE_GETREGSET/PTRACE_SETREGSET
From: "H.J. Lu" <hjl.tools@gmail.com>
To: Roland McGrath <roland@redhat.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Oleg Nesterov <oleg@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 9, 2010 at 5:52 PM, Roland McGrath <roland@redhat.com> wrote:
>> 'addr' parameter for the ptrace system call encode the REGSET type and
>> the buffer length. 'data' parameter points to the user buffer.
>>
>>       ptrace(PTRACE_GETREGSET/PTRACE_SETREGSET, pid,
>>              (NT_TYPE << 20) | buf_length, buf);
>
> IMHO this bit swizzling is a non-starter.  The NT_* codes can use a full 32
> bits.  NT_PRXFPREG uses 31 bits.  The comments about ignoring the high bits
> for this as a special case just seem insane to me.  Pass a full 32 bit word
> for NT_* and a full word for the buffer size.  What's so terrible about
> just having an obvious and comprehensible API?
>
> IMHO if you insist on an insane bit swizzling approach, you should mix the
> buffer size bits into the request code, leaving the "addr" argument free
> for the unmolested NT_* code.  There is just no earthly reason that we
> should suddenly impose a new and arcane constraint on what NT_* values can
> be, even if there is no particular reason for future values not to be small.
>
>> +int generic_ptrace_regset(struct task_struct *child, long request, long addr,
>> +                       long data);
>
> There is no need for a global function for this.  It should all be static
> in kernel/ptrace.c, called only by ptrace_request()/compat_ptrace_request().
>

Won't it be called by ptrace emulation in utrace?


-- 
H.J.
