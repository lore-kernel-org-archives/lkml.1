Return-Path: <linux-kernel-owner+w=401wt.eu-S1754490Ab0AQSzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490Ab0AQSzn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 13:55:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754419Ab0AQSzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 13:55:42 -0500
Received: from tomts22.bellnexxia.net ([209.226.175.184]:36014 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754398Ab0AQSzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 13:55:42 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtgEAF7nUkuuWOiG/2dsb2JhbACBRtJ4hDIE
Date: Sun, 17 Jan 2010 13:55:39 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: rostedt@goodmis.org, Jason Baron <jbaron@redhat.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
       mhiramat@redhat.com, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC PATCH 2/8] jump label v4 - x86: Introduce generic jump
	patching without stop_machine
Message-ID: <20100117185539.GF9008@Krystal>
References: <cover.1263247113.git.jbaron@redhat.com> <a4aa5bbcf5e62eaa5dd156d318a370236f28be09.1263247114.git.jbaron@redhat.com> <1263483139.28171.3857.camel@gandalf.stny.rr.com> <4B4F3A1A.2030906@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <4B4F3A1A.2030906@zytor.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 13:53:07 up 32 days,  3:11,  4 users,  load average: 0.15, 0.28,
	0.18
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin (hpa@zytor.com) wrote:
> On 01/14/2010 07:32 AM, Steven Rostedt wrote:
> >> +
> >> +	/* Replacing 1 byte can be done atomically. */
> >> +	if (unlikely(len <= 1))
> >> +		return text_poke(addr, opcode, len);
> > 
> > This part bothers me. The text_poke just writes over the text directly
> > (using a separate mapping). But if that memory is in the pipeline of
> > another CPU, I think this could cause a GPF.
> > 
> 
> Could you clarify why you think that?

Basically, what Steven and I were concerned about in this particular
patch version is the fact that this code took a "shortcut" for
single-byte text modification, thus bypassing the int3-bypass scheme
altogether.

As mere atomicity of the modification is not the only concern here
(because we also have to deal with instruction trace cache coherency and
so forth), then the int3 breakpoint scheme is, I think, also needed for
single-byte updates.

Thanks,

Mathieu

> 
> 	-hpa
> 
> -- 
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel.  I don't speak on their behalf.
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
