Return-Path: <linux-kernel-owner+w=401wt.eu-S966187AbYD1WC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966187AbYD1WC2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 18:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965832AbYD1WCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 18:02:13 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:14858 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965828AbYD1WCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 18:02:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=xdAYApj6o9zbfp4rDqpCgCQMnYuxsWDXNNvI6nSDp6FdLbhEr5GJf8BjJ/A3kZahjIWK/KU6+M1IH8bvt1wmGQQsncuKTloAeo0nxiwBUKfqxnbCTpEWt8allcGO5XW7CIIan4E3exfrZd8442cstuMaQnBb4M3A0nWC0aQMGf8=
Message-ID: <dd18b0c30804281502k694b30ferfd79217c1da458f0@mail.gmail.com>
Date: Mon, 28 Apr 2008 22:02:06 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Venki Pallipadi" <venkatesh.pallipadi@intel.com>
Subject: Re: spinlock lockup on CPU#0
Cc: "Bob Copeland" <me@bobcopeland.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       hugh@veritas.com
In-Reply-To: <20080428203824.GA14044@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30804231841m3bbfab44x53d635b7ea6fc58d@mail.gmail.com>
	 <20080426112907.77613dee.akpm@linux-foundation.org>
	 <20080426191432.GA2927@elte.hu>
	 <b6c5339f0804261406o447b95b2i18c937a6c738f8db@mail.gmail.com>
	 <dd18b0c30804261448n128293e6s1149931726e95b36@mail.gmail.com>
	 <20080428203824.GA14044@linux-os.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 8:38 PM, Venki Pallipadi
<venkatesh.pallipadi@intel.com> wrote:
> On Sat, Apr 26, 2008 at 09:48:55PM +0000, Justin Mattock wrote:
>  > On Sat, Apr 26, 2008 at 9:06 PM, Bob Copeland <me@bobcopeland.com> wrote:
>  > > On Sat, Apr 26, 2008 at 3:14 PM, Ingo Molnar <mingo@elte.hu> wrote:
>  > >  >  > Can you add this please, see if it triggers?
>  > >  >
>  > >  >  there's fixes pending in this area. The main fix would be the one below.
>  > >  >
>  > >  >         Ingo
>  > >  >
>  > >  >  ---------------->
>  > >  >  Subject: idle (arch, acpi and apm) and lockdep
>  > >
>  > >  FWIW, I was seeing the same lockdep trace with eventual hangs, and
>  > >  this patch (applied with some fuzz) fixed the problem.
>  > >
>  > >  --
>  > >  Bob Copeland %% www.bobcopeland.com
>  > >
>  >
>  > Just out of curiosity I put the kernel back to it's original state,
>  > were the freezing occurs, then booted with nohz=off, then added
>  > WARN_ON(!irqs_disabled()); to sched.c only to the kernel, no other
>  > patches, upon rebooting
>  > I received different results: The screen from what I could tell was
>  > spitting out the spinlock messages, but instead of printing that out,
>  > and going on to the next task it just keep't printing, from what I
>  > could tell something with ehci, uhci, agpgart, ieee1394 etc... too
>  > fast to really make anything out, the numbers on the left side keept
>  > moving upward, the fans started hauling ass, I waitied a few minuetes
>  > hopeing this would stop
>  > so I can grab dmesg, but it would'nt. is there a way to use the boot
>  > param to write date to a file? so I could capture this event.
>  > regards
>  >
>
>  OK. Hunted this bug down to
>  commit 3b22ec7b13cb31e0d87fbc0aabe14caaaad309e8
>
>  which for some reason enables interrupt in mwait_idle_with_hints(), which
>  eventually causes interrupts to be enabled in acpi idle call, resulting in
>  sched_clock_idle_wakeup_event() with interrupts enabled. This bug
>  was only in x86 32 bit version.
>
>  Peter's patch below which is already in git fixes this. So we don't need any
>  additional fixes here...
>
>  Thanks,
>  Venki
>
>

Alright, I was concerned about having additional fixes.
regards;

-- 
Justin P. Mattock
