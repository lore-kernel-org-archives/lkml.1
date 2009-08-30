Return-Path: <linux-kernel-owner+w=401wt.eu-S1753133AbZH3BZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133AbZH3BZX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 21:25:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753116AbZH3BZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 21:25:22 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:49139 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096AbZH3BZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 21:25:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Tu921buecC1Qgsr+Ms5geueGB2QfL4cF/Mh0yfZ8f2a0/y+zG/HYZZBCGhIGvhsPcg
         HO8rfnh0PShKkRgXdfRtBs89yzjzYUTfzXGgu3CeYoiiGS71SbOvdhcCe27I5dbqOv8a
         GoWfSardtKoVJDVcjurPhqAXL7shH+6qglarw=
Date: Sun, 30 Aug 2009 03:25:21 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [PATCH -tip tracing/kprobes 1/6] kprobes/x86: Call BUG() when
	reentering probe into KPROBES_HIT_SS
Message-ID: <20090830012519.GC387@nowhere>
References: <20090827152539.GE6058@nowhere> <20090827172258.8246.61889.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090827172258.8246.61889.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 27, 2009 at 01:22:58PM -0400, Masami Hiramatsu wrote:
> Call BUG() when a probe have been hit on the way of kprobe processing path,
> because that kind of probes are currently unrecoverable (recovering it will
> cause an infinit loop and stack overflow).
> 
> The original code seems to assume that it will be caused by an int3 which
> another subsystem inserted on out-of-line singlestep buffer if the hitting
> probe is same as current probe. However, in that case, int3-hitting-address
> is on the out-of-line buffer and should be different from first (current)
> int3 address.
> Thus, I decided to remove the code.
> 
> I also removes arch_disarm_kprobe() because it will involve other stuffs
> in text_poke().
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> Cc: Ingo Molnar <mingo@elte.hu>



Applied the six patches to

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	tracing/kprobes

Thanks!

