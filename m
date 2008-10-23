Return-Path: <linux-kernel-owner+w=401wt.eu-S1758215AbYJWRG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758215AbYJWRG4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 13:06:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753749AbYJWRGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 13:06:47 -0400
Received: from gv-out-0910.google.com ([216.239.58.189]:35171 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581AbYJWRGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 13:06:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=K8eSPap/qoYWMfUf+PGDJMdpS8R8lMlgq/WyY2Eobdr+MtY8Jx7Vls3axte956z4ZX
         UoV9SKH4N1CkZH9qn3uqAgsbOUnqzyNUhc0BnujUVjiqT++ciiCVVRUTqGIwpdDGkMTT
         dDZ6iAcR6Ig5S62mYRrsp4N6luQTPdvZ28swM=
Message-ID: <c62985530810231006p726bb237qe288ec80b005d8b0@mail.gmail.com>
Date: Thu, 23 Oct 2008 19:06:44 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] tracing: fix a build error on alpha and m68k
Cc: "Alexey Dobriyan" <adobriyan@gmail.com>,
       "Geert Uytterhoeven" <geert@linux-m68k.org>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Steven Rostedt" <rostedt@goodmis.org>
In-Reply-To: <20081023165504.GB25697@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c62985530810230548t1b569f61g34d1900bb94fde83@mail.gmail.com>
	 <49008D12.5090204@gmail.com>
	 <Pine.LNX.4.64.0810231635440.18978@anakin>
	 <c62985530810230757r411b4e3dj4ecec649cf8cf0b3@mail.gmail.com>
	 <Pine.LNX.4.64.0810231727430.18978@anakin>
	 <4900B414.7090002@gmail.com> <20081023163433.GA3160@x200.localdomain>
	 <20081023163850.GB16591@elte.hu>
	 <c62985530810230951u7ae640d5ya45bed466f030074@mail.gmail.com>
	 <20081023165504.GB25697@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/23 Ingo Molnar <mingo@elte.hu>:
> to answer the "is that a lockdep or just trace feature" question:
>
> trace-irqflags was first written by me for the (crude) ftrace-precursor
> latency tracer code in -rt, years ago. Then i reused it (and changed it
> alot) for upstream lockdep, two years ago. Then ftrace came in this year
> and reused it.
>
> so it's rather symbiotic ;-)
>
> So ... the tracers that rely on irqflags-tracing should definitely be
> limited to architectures that provide TRACE_IRQFLAGS. The core trace.c
> itself should probably not be restricted ... (and it should definitely
> build)
>
>        Ingo
>

Ok, so perhaps it needs a kind of disambiguation between CONFIG_TRACE_IRQFLAGS
and CONFIG_TRACE_IRQFLAGS_SUPPORT :)

So, if those arch may not support irqflags, I should forget about
including linux/irqflags.h

But to let the core trace.c to be built for other types of tracing,
the best thing I see is to put some ifdef CONFIG_TRACE_IRQFLAGS on the
tracing_cpumask functions and structure, and actually on the creation
of this file.

No bad feelings about this solution?
