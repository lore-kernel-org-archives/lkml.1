Return-Path: <linux-kernel-owner+w=401wt.eu-S932101AbYBZSI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101AbYBZSI7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 13:08:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761549AbYBZSIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 13:08:50 -0500
Received: from sinclair.provo.novell.com ([137.65.248.137]:34288 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbYBZSIt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 13:08:49 -0500
Message-Id: <47C40DBD.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Tue, 26 Feb 2008 11:01:49 -0700
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Pavel Machek" <pavel@ucw.cz>
Cc: <a.p.zijlstra@chello.nl>, <mingo@elte.hu>, <bill.huey@gmail.com>,
       <rostedt@goodmis.org>, <kevin@hilman.org>, <tglx@linutronix.de>,
       <cminyard@mvista.com>, <dsingleton@mvista.com>, <dwalker@mvista.com>,
       "Moiz Kohari" <MKohari@novell.com>,
       "Peter Morreale" <PMorreale@novell.com>,
       "Sven Dietrich" <SDietrich@novell.com>, <dsaxena@plexity.net>,
       <acme@redhat.com>, <ak@suse.de>, <gregkh@suse.de>, <npiggin@suse.de>,
       <linux-kernel@vger.kernel.org>, <linux-rt-users@vger.kernel.org>
Subject: Re: [(RT RFC) PATCH v2 5/9] adaptive real-time lock support
References: <20080225155959.11268.35541.stgit@novell1.haskins.net>
 <20080225160103.11268.25579.stgit@novell1.haskins.net>
 <20080225220313.GG2659@elf.ucw.cz> <47C3E3FF.BA47.005A.0@novell.com>
 <20080226180643.GA6030@elf.ucw.cz>
In-Reply-To: <20080226180643.GA6030@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Tue, Feb 26, 2008 at  1:06 PM, in message
<20080226180643.GA6030@elf.ucw.cz>, Pavel Machek <pavel@ucw.cz> wrote: 
> On Tue 2008-02-26 08:03:43, Gregory Haskins wrote:
>> >>> On Mon, Feb 25, 2008 at  5:03 PM, in message
>> <20080225220313.GG2659@elf.ucw.cz>, Pavel Machek <pavel@ucw.cz> wrote: 
>> 
>> >> +static inline void
>> >> +prepare_adaptive_wait(struct rt_mutex *lock, struct adaptive_waiter 
>> > *adaptive)
>> > ...
>> >> +#define prepare_adaptive_wait(lock, busy) {}
>> > 
>> > This is evil. Use empty inline function instead (same for the other
>> > function, there you can maybe get away with it).
>> > 
>> 
>> I went to implement your suggested change and I remembered why I did it this 
> way:  I wanted a macro so that the "struct adaptive_waiter" local variable 
> will fall away without an #ifdef in the main body of code.  So I have left 
> this logic alone for now.
> 
> Hmm, but inline function will allow dead code elimination,  too, no?

I was getting compile errors.  Might be operator-error ;)

> 
> Anyway non-evil way to do it with macro is 
> 
> #define prepare_adaptive_wait(lock, busy) do {} while (0)
> 
> ...that behaves properly in complex statements.

Ah, I was wondering why people use that.  Will do.  Thanks!

-Greg

