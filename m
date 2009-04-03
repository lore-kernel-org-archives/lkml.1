Return-Path: <linux-kernel-owner+w=401wt.eu-S1762284AbZDCMYH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762284AbZDCMYH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 08:24:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752559AbZDCMXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 08:23:50 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56373 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbZDCMXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 08:23:50 -0400
Date: Fri, 3 Apr 2009 14:25:39 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Jim Keniston <jkenisto@us.ibm.com>,
       kvm@vger.kernel.org, systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip 0/6 V4] tracing: kprobe-based event tracer
Message-ID: <20090403122539.GC11935@one.firstfloor.org>
References: <49D4F4B5.9040107@redhat.com> <20090403112639.GC31399@elte.hu> <49D5F80B.7000305@redhat.com> <20090403121202.GI31399@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090403121202.GI31399@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So ... we can do the library decoder for kprobes purposes, and 
> someone versed in the KVM emulator can then combine the two.

The KVM (or rather Xen, that is where it comes from) decoder is already
a "library decoder". That is it does nearly everything
through callbacks, and if you don't want some functionality
you can nop the callbacks. Nearly because some  some
direct KVM references have crept in recently (e.g. to vcpus),
but those could be probably removed again without too much effort.
There are not many of them.

Also doing another interpreter is a lot of work and a lot of testing,
so basing it on something that is already well tested is probably
a good idea.

-/dev/null/Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
