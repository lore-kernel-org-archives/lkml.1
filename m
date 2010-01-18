Return-Path: <linux-kernel-owner+w=401wt.eu-S1752938Ab0ARQyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938Ab0ARQyr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 11:54:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711Ab0ARQyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 11:54:46 -0500
Received: from tomts43.bellnexxia.net ([209.226.175.110]:34856 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932067Ab0ARQyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 11:54:45 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Al4FAM8bVEuuWOiG/2dsb2JhbACBRtRwhDME
Date: Mon, 18 Jan 2010 11:54:43 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       rostedt@goodmis.org, Jason Baron <jbaron@redhat.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       andi@firstfloor.org, roland@redhat.com, rth@redhat.com
Subject: Re: [RFC PATCH 2/8] jump label v4 - x86: Introduce generic jump
	patching without stop_machine
Message-ID: <20100118165443.GB29764@Krystal>
References: <cover.1263247113.git.jbaron@redhat.com> <a4aa5bbcf5e62eaa5dd156d318a370236f28be09.1263247114.git.jbaron@redhat.com> <1263483139.28171.3857.camel@gandalf.stny.rr.com> <4B4F3A1A.2030906@zytor.com> <20100117185539.GF9008@Krystal> <20100117111608.35a98ee2@infradead.org> <4B548562.6030008@redhat.com> <20100118083129.675edb83@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20100118083129.675edb83@infradead.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 11:53:08 up 33 days,  1:11,  5 users,  load average: 0.42, 0.19,
	0.12
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arjan van de Ven (arjan@infradead.org) wrote:
> On Mon, 18 Jan 2010 10:59:30 -0500
> Masami Hiramatsu <mhiramat@redhat.com> wrote:
> 
> > Yeah, so in the latest patch, I updated it to use int3 even if
> > len == 1. :-)
> > 
> 
> 
> int3 is not making a difference for your case; there is no guarantee
> that the other processor even sees the "int3 inbetween state" at all;
> if it's not safe without int3 then it won't be safe with int3 either.

What Masami means is that he updated his patch to use the int3+IPI
broadcast scheme.

Therefore, the CPUs not seeing the int3 inbetween state will be forced
to issue a serializing instruction while the int3 is in place anyway.

Thanks,

Mathieu

> 
> 
> -- 
> Arjan van de Ven 	Intel Open Source Technology Centre
> For development, discussion and tips for power savings, 
> visit http://www.lesswatts.org

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
