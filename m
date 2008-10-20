Return-Path: <linux-kernel-owner+w=401wt.eu-S1756606AbYJTVjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606AbYJTVjz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 17:39:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756489AbYJTVip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 17:38:45 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:57611 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756468AbYJTVij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 17:38:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=YGnVIJ/vJ3cGzhCwHGRu8gtyF6ghSZvOlYqVaOWjgy7snfE0VE6aTY8siniDNkT+8/
         54rLoGAXEpUfVyJh0sO43I743nH5vLz4FdNKxf0RaGQ/KcoijcoEq1uYln7YO/RaG5u/
         JVIC4B0izEO2G6SuhSX9TAye8uKpXhpemFUi4=
Message-ID: <1f1b08da0810201438g6a109af5i75b34841462b655d@mail.gmail.com>
Date: Mon, 20 Oct 2008 14:38:37 -0700
From: "john stultz" <johnstul@us.ibm.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [RFC patch 15/15] LTTng timestamp x86
Cc: "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>,
       "Luck, Tony" <tony.luck@intel.com>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "David Miller" <davem@davemloft.net>, "Ingo Molnar" <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <alpine.LFD.2.00.0810201256350.3518@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081016232729.699004293@polymtl.ca>
	 <20081016234657.837704867@polymtl.ca>
	 <alpine.LFD.2.00.0810161701470.3288@nehalem.linux-foundation.org>
	 <20081017012835.GA30195@Krystal>
	 <57C9024A16AD2D4C97DC78E552063EA3532D455F@orsmsx505.amr.corp.intel.com>
	 <20081017172515.GA9639@goodmis.org>
	 <57C9024A16AD2D4C97DC78E552063EA3533458AC@orsmsx505.amr.corp.intel.com>
	 <20081017184215.GB9874@Krystal>
	 <alpine.LFD.2.00.0810201256350.3518@nehalem.linux-foundation.org>
X-Google-Sender-Auth: cd0221c393eb41ca
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2008 at 1:10 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> I think it's a mistake for us to maintain a single clock for
> gettimeofday() (well, "getnstimeofday" and the whole "clocksource_read()"
> crud to be technically correct). And sure, I bet clocksource_read() can do
> various per-CPU things and try to do that, but it's complex and pretty
> generic code, and as far as I know none of the clocksources have even
> tried. The TSC clocksource read certainly does not (it just does a very
> similar horrible "at least don't go backwards" crud that the LTTng patch
> suggested).
>
> So I think we should make "xtime" be a per-CPU thing, and add support for
> per-CPU clocksources. And screw that insane "mark_tsc_unstable()" thing.
>
> And if we did it well, we migth be able to get good timestamps that way
> too.

Personally I'd been hoping that the experiments in the trace
timestamping code would provide a safe area of experimentation before
we adapt it to the TSC clocksource implementation for
getnstimeofday(). Earlier I know Andi and Jiri were working on such a
per-cpu TSC clocksource, but I don't know where it ended up.

I'm not quite sure I followed your per-cpu xtime thoughts.  Could you
explain further your thinking as to why the entire timekeeping
subsystem should be per-cpu instead of just keeping that back in the
arch-specific clocksource implementation?  In other words, why keep
things synced at the nanosecond level instead of keeping the per-cpu
TSC synched at the cycle level?

thanks
-john
