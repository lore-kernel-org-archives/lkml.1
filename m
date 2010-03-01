Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751316Ab0CANgQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 08:36:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35782 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750705Ab0CANgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 08:36:15 -0500
Date: Mon, 1 Mar 2010 15:26:09 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, avi@redhat.com,
       mtosatti@redhat.com, zamsden@redhat.com
Subject: Re: use of setjmp/longjmp in x86 emulator.
Message-ID: <20100301132609.GJ16909@redhat.com>
References: <20100301091819.GD16909@redhat.com>
 <4B8BB6FA.1000505@oss.ntt.co.jp>
 <20100301125223.GI16909@redhat.com>
 <4B8BBE61.3020503@oss.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B8BBE61.3020503@oss.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 01, 2010 at 10:17:21PM +0900, Takuya Yoshikawa wrote:
> Gleb Natapov wrote:
> >On Mon, Mar 01, 2010 at 09:45:46PM +0900, Takuya Yoshikawa wrote:
> >>Gleb Natapov wrote:
> >>>I am looking at improving KVM x86 emulator. Current code does not
> >>Does your plan also include making the emulator independent of KVM?
> >Yes, I am planning to make it more independent from KVM that it is now
> >(by adding more callbacks to x86_emulate_ops).
> >
> >>Could you tell me about the future plan if possible?
> >>
> >We saw a lot of problems and shortcomings in the emulator recently, so
> >the plan is to improve its correctness. There is also a requirement to be
> >able single step emulated code. Having setjmp/longjmp will greatly simplify
> >the code. What are you interested in?
> 
> I am mainly interested in clearly understanding the KVM x86 emulator.
> 
> In that sense, what I felt first was it's impossible to understand why
> it is working without the deep(whole) knowledge of the KVM's architecture.
> If emulator itself is self contained, it will be much help for me.
You will need some knowledge of KVM in any case since KVM design shapes
emulator design. Think about what happens if in the middle of
instruction emulation some data from device emulated in userspace is
needed. Emulator should be able to tell KVM that exit to userspace is
needed and restart instruction emulation when data is available.

> 
> Though I do not think every instruction should be implemented, it would be
> nice if each instruction emulated is independent of KVM: if we can check the
> validity of them using only SDM, it would be really nice!
> 
Agree. That is my goal too.

> Thanks,
>   Takuya
> 
> >
> >>>handle some special cases correctly (code execution from ROM, ins/outs
> >>>to/from MMIO) and many exception conditions during instruction emulation
> >>>are not handled correctly. There is a lot of code in emulator that is
> >>>there only for exception propagation. Using setjmp/longjmp will be very
> >>>beneficial here as exception condition during instruction execution
> >>>maps very naturally to setjmp/longjmp, so my question is what about
> >>>adding setjmp/longjmp implementation to the kernel, or alternatively,
> >>>if there is a fear that it can be abused, add it locally to emulator.c?
> >>>Note that instruction emulation is always done in process context.
> >>>
> >>>--
> >>>			Gleb.
> >>>--
> >>>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >>>the body of a message to majordomo@vger.kernel.org
> >>>More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>>Please read the FAQ at  http://www.tux.org/lkml/
> >
> >--
> >			Gleb.

--
			Gleb.
