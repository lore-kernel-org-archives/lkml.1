Return-Path: <linux-kernel-owner+w=401wt.eu-S1755515Ab0ARSdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab0ARSdN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 13:33:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754234Ab0ARSdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 13:33:12 -0500
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:58777 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752157Ab0ARSdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 13:33:11 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhkFAAIzVEuuWOiG/2dsb2JhbACBRtQmhDME
Date: Mon, 18 Jan 2010 13:33:09 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Arjan van de Ven <arjan@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
       rostedt@goodmis.org, Jason Baron <jbaron@redhat.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       andi@firstfloor.org, roland@redhat.com, rth@redhat.com
Subject: Re: [RFC PATCH 2/8] jump label v4 - x86: Introduce generic jump
	patching without stop_machine
Message-ID: <20100118183309.GA12099@Krystal>
References: <cover.1263247113.git.jbaron@redhat.com> <a4aa5bbcf5e62eaa5dd156d318a370236f28be09.1263247114.git.jbaron@redhat.com> <1263483139.28171.3857.camel@gandalf.stny.rr.com> <4B4F3A1A.2030906@zytor.com> <20100117185539.GF9008@Krystal> <20100117111608.35a98ee2@infradead.org> <4B548562.6030008@redhat.com> <20100118083129.675edb83@infradead.org> <20100118165443.GB29764@Krystal> <4B54A68E.4050409@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <4B54A68E.4050409@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 13:30:22 up 33 days,  2:48,  5 users,  load average: 0.26, 0.28,
	0.19
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Masami Hiramatsu (mhiramat@redhat.com) wrote:
> Mathieu Desnoyers wrote:
> > * Arjan van de Ven (arjan@infradead.org) wrote:
> >> On Mon, 18 Jan 2010 10:59:30 -0500
> >> Masami Hiramatsu <mhiramat@redhat.com> wrote:
> >>
> >>> Yeah, so in the latest patch, I updated it to use int3 even if
> >>> len == 1. :-)
> >>>
> >>
> >>
> >> int3 is not making a difference for your case; there is no guarantee
> >> that the other processor even sees the "int3 inbetween state" at all;
> >> if it's not safe without int3 then it won't be safe with int3 either.
> > 
> > What Masami means is that he updated his patch to use the int3+IPI
> > broadcast scheme.
> 
> Right.
> 
> > 
> > Therefore, the CPUs not seeing the int3 inbetween state will be forced
> > to issue a serializing instruction while the int3 is in place anyway.
> 
> By the way, in kprobes, we just use a text_poke() to put int3.
> I assume that we'd better send IPI afterward, wouldn't it?

Only if you need to ensure that you reached a state where all CPUs are
seeing the int3.

Note that kprobes already issues synchronize_sched() after breakpoint
removal, which should have a similar effect. However, AFAIK, it does not
synchronize after inserting the int3.

Thanks,

Mathieu

> 
> Thank you,
> 
> -- 
> Masami Hiramatsu
> 
> Software Engineer
> Hitachi Computer Products (America), Inc.
> Software Solutions Division
> 
> e-mail: mhiramat@redhat.com
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
