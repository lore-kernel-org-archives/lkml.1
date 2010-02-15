Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133Ab0BOSw7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 13:52:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27418 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755818Ab0BOSw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 13:52:58 -0500
Date: Mon, 15 Feb 2010 19:52:06 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: x86: get rid of the insane TIF_ABI_PENDING bit
Message-ID: <20100215185206.GA25608@redhat.com>
References: <20100215161752.GA19962@redhat.com> <4B7974F7.1030105@zytor.com> <20100215165012.GA20447@redhat.com> <4B798D2F.7010701@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B798D2F.7010701@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15, H. Peter Anvin wrote:
>
> On 02/15/2010 08:50 AM, Oleg Nesterov wrote:
> >
> > Could you please point me where do we check TS_COMPAT during return
> > to user-mode?
> >
>
> Sorry, I was thinking about TIF_IA32, which is examined on line 415 of
> entry_64.S.

Yes, I understand we should set TIF_IA32, but my question was about
TS_COMPAT.

Oh. And ELF_PLAT_INIT() clears TIF_IA32... at this point it should
be already cleared by SET_PERSONALITY() ?

OK. If this is all really needed, please ignore me, I don't really
understand these details anyway.

> >> At that point (this is after the exec!) we don't get arguments anyway.
> >
> > I meant /proc/pid/syscall, but even if I am right this probably
> > doesn't matter.
>
> What does getting the arguments from a process which has never done a
> system call yet even mean?  Presumably we get some kind of "null answer"
> which depends on the default register set; in that case the compat null
> answer is the correct one.

Indeed, not sure what I was thinking about, thanks.

Oleg.

