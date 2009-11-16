Return-Path: <linux-kernel-owner+w=401wt.eu-S1754942AbZKPXp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942AbZKPXp4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 18:45:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754813AbZKPXpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 18:45:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5408 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754690AbZKPXpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 18:45:54 -0500
Message-ID: <4B01E428.9070203@redhat.com>
Date: Mon, 16 Nov 2009 18:45:44 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH -tip 3/3] Add get_signal tracepoint
References: <20091113225226.15079.90813.stgit@harusame>	<20091113225240.15079.4863.stgit@harusame>	<20091113235333.0E3CC15E8@magilla.sf.frob.com>	<20091114001020.GB24738@elte.hu>	<4B01C95B.1070302@redhat.com>	<20091116220957.8E2142F@magilla.sf.frob.com>	<4B01D4B5.1050909@redhat.com> <20091116230037.23EEB1A2@magilla.sf.frob.com>
In-Reply-To: <20091116230037.23EEB1A2@magilla.sf.frob.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath wrote:
>> Hmm, actually, trace_signal_send() doesn't record the return value.
>
> Is that because it's called before the action really happens?
> Is it important that it be called beforehand?  If it's called
> afterwards, it's easy to pass the return value.

I'm not so sure why signal sending events was put beforehand.
However, I assume that original intent might be recording
the *timing* of all signal generation (including SIGSTOP/CONT).

>> So, what about trace_signal_overflow() for RT-signals and
>> trace_signal_loss_info() for non-RT?
>
> Really you can distinguish those just by looking at sig and info, so
> perhaps a single tracepoint is enough.

Ah, right :-)

>  I guess it really depends on what
> filtering you would want and how inconvenient it is to have to apply that
> filtering.  Having these two distinct tracepoints lets you trivially trace
> only "silent information loss" without seeing the events where userland
> gets full information (if applications are paying attention).
>
> If you want to have a full suite of tracepoints where each one covers one
> unambiguous corner of the semantics, then there are more than these just
> for sending.  e.g. see below.

As Ingo said, I think this kind of finegrained events are optional.
I don't think we really need these events soon. IMHO, just adding
signal-loss event is enough at the first step.

But anyway, thank you so much for suggesting those tracepoints!

Thank you,


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

