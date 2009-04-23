Return-Path: <linux-kernel-owner+w=401wt.eu-S1758501AbZDWUws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758501AbZDWUws (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 16:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755509AbZDWUwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 16:52:39 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:37924 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755473AbZDWUwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 16:52:38 -0400
Date: Thu, 23 Apr 2009 16:48:52 -0400 (EDT)
From: Tim Abbott <tabbott@MIT.EDU>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
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
       Paul Mundt <lethal@linux-sh.org>,
       =?ISO-8859-15?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Subject: [PATCH v3 0/3] Add support for compiling with -ffunction-sections
 -fdata-sections
In-Reply-To: <alpine.LFD.2.00.0904201730590.2199@localhost.localdomain>
Message-ID: <alpine.DEB.1.10.0904221826180.24694@vinegar-pot.mit.edu>
References: <1238973278-31735-1-git-send-email-tabbott@mit.edu> <alpine.DEB.1.10.0904072019560.17274@vinegar-pot.mit.edu> <alpine.DEB.1.10.0904201255080.30705@vinegar-pot.mit.edu> <alpine.LFD.2.00.0904201637280.2199@localhost.localdomain>
 <alpine.DEB.1.10.0904202010220.30705@vinegar-pot.mit.edu> <alpine.LFD.2.00.0904201730590.2199@localhost.localdomain>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Apr 2009, Linus Torvalds wrote:

> I'd be ok with merging it, but I haven't really gotten a strong feeling 
> that anybody is going to enable it or use it.

Linus,

Would you be willing to merge the first 3 patches in this patch series at 
this point?  I'm resending these patches to resolve some conflicts that 
was recently introduced.

To summarize the discussion, there are three uses for this code that have 
significant interest.

One is decreasing the kernel size.  Denys Vlasenko has numbers that using 
the linker's --gc-sections option (for which these patches are a 
prerequisite) saves 10% of the kernel size when CONFIG_MODULES=n, and 1% 
when CONFIG_MODULES=y.  Paul Mundt thinks many embedded users would use 
this if it were available.

A related use is cleaning up a lot of ifdefs that exist only to decrease 
the kernel size.  Several developers commented favorably on the direction 
of using section garbage collection for dead code removal.

Finally, Ksplice depends on the option added by this patch series.

The first 3 patches in this patch series fix problems associated with 
using -ffunction-sections.  As there are some architectures currently 
using -ffunction-sections, these should ideally be merged now, especially 
the first patch which involves scattered changes.

	-Tim Abbott
