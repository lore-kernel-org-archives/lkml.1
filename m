Return-Path: <linux-kernel-owner+w=401wt.eu-S1756468AbZKRASR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756468AbZKRASR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 19:18:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756431AbZKRASR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 19:18:17 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:34745 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756426AbZKRASQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 19:18:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=A+6590aEEl23E02cSWqLhFCnGuo6TL/Ld/w3xEZ1Dp8uLGmZCmFBTAlzw9ud3q1Dya
         tRD++677hi6pgjq/SlDc8BxayBHTZeHYtcEbcLZ0i4y9nO7IsGFd0itDobPHip0JOouu
         1uktZRgQvswIL6OIyrjbI2yjqb8w6823sustE=
Date: Wed, 18 Nov 2009 01:18:19 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Prasad <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jan Kiszka <jan.kiszka@web.de>,
       Jiri Slaby <jirislaby@gmail.com>, Avi Kivity <avi@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 3/7 v6] perf/core: Add a callback to perf events
Message-ID: <20091118001815.GA8187@nowhere>
References: <1257694141-5670-1-git-send-email-fweisbec@gmail.com> <1257694141-5670-4-git-send-email-fweisbec@gmail.com> <1258457333.7816.186.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258457333.7816.186.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 12:28:53PM +0100, Peter Zijlstra wrote:
> On Sun, 2009-11-08 at 16:28 +0100, Frederic Weisbecker wrote:
> > A simple callback in a perf event can be used for multiple purposes.
> > For example it is useful for triggered based events like hardware
> > breakpoints that need a callback to dispatch a triggered breakpoint
> > event.
> > 
> > v2: Simplify a bit the callback attribution as suggested by Paul
> >     Mackerras
> 
> Yuck! So we add an opaque callback without semantics nor usage.


Yeah, this is intended for events that need to be able to trigger
events to different channels. In the case of hw-breakpoints, it's
either perf buffer, ptrace, etc...

Should I add some comments about it?

