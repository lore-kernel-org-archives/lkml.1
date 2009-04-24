Return-Path: <linux-kernel-owner+w=401wt.eu-S1753969AbZDXAUF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969AbZDXAUF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 20:20:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbZDXATx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 20:19:53 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:53344 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbZDXATv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 20:19:51 -0400
Date: Fri, 24 Apr 2009 09:14:40 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Tim Abbott <tabbott@MIT.EDU>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Jeff Arnold <jbarnold@MIT.EDU>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, "Theodore Ts'o" <tytso@MIT.EDU>,
       Nikanth Karthikesan <knikanth@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Am?rico Wang <xiyou.wangcong@gmail.com>,
       Ralf Baechle <ralf@linux-mips.org>, Kyle McMartin <kyle@mcmartin.ca>,
       David Howells <dhowells@redhat.com>
Subject: Re: [PATCH v3 0/3] Add support for compiling with -ffunction-sections -fdata-sections
Message-ID: <20090424001439.GA27897@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Tim Abbott <tabbott@MIT.EDU>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux kernel mailing list <linux-kernel@vger.kernel.org>,
	Anders Kaseorg <andersk@mit.edu>, Waseem Daher <wdaher@mit.edu>,
	Denys Vlasenko <vda.linux@googlemail.com>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Jeff Arnold <jbarnold@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jon Masters <jonathan@jonmasters.org>,
	Masami Hiramatsu <mhiramat@redhat.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Nikanth Karthikesan <knikanth@suse.de>,
	Arjan van de Ven <arjan@infradead.org>,
	Am?rico Wang <xiyou.wangcong@gmail.com>,
	Ralf Baechle <ralf@linux-mips.org>,
	Kyle McMartin <kyle@mcmartin.ca>,
	David Howells <dhowells@redhat.com>
References: <1238973278-31735-1-git-send-email-tabbott@mit.edu> <alpine.DEB.1.10.0904072019560.17274@vinegar-pot.mit.edu> <alpine.DEB.1.10.0904201255080.30705@vinegar-pot.mit.edu> <alpine.LFD.2.00.0904201637280.2199@localhost.localdomain> <alpine.DEB.1.10.0904202010220.30705@vinegar-pot.mit.edu> <alpine.LFD.2.00.0904201730590.2199@localhost.localdomain> <alpine.DEB.1.10.0904221826180.24694@vinegar-pot.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0904221826180.24694@vinegar-pot.mit.edu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 04:48:52PM -0400, Tim Abbott wrote:
> On Mon, 20 Apr 2009, Linus Torvalds wrote:
> 
> > I'd be ok with merging it, but I haven't really gotten a strong feeling 
> > that anybody is going to enable it or use it.
> 
> Linus,
> 
> Would you be willing to merge the first 3 patches in this patch series at 
> this point?  I'm resending these patches to resolve some conflicts that 
> was recently introduced.
> 
> To summarize the discussion, there are three uses for this code that have 
> significant interest.
> 
> One is decreasing the kernel size.  Denys Vlasenko has numbers that using 
> the linker's --gc-sections option (for which these patches are a 
> prerequisite) saves 10% of the kernel size when CONFIG_MODULES=n, and 1% 
> when CONFIG_MODULES=y.  Paul Mundt thinks many embedded users would use 
> this if it were available.
> 
> A related use is cleaning up a lot of ifdefs that exist only to decrease 
> the kernel size.  Several developers commented favorably on the direction 
> of using section garbage collection for dead code removal.
> 
> Finally, Ksplice depends on the option added by this patch series.
> 
> The first 3 patches in this patch series fix problems associated with 
> using -ffunction-sections.  As there are some architectures currently 
> using -ffunction-sections, these should ideally be merged now, especially 
> the first patch which involves scattered changes.
> 
Given that this fixes issues with the existing in-tree users, it would
help to make them aware of this also.. added to the CC.
