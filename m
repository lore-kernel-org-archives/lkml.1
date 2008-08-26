Return-Path: <linux-kernel-owner+w=401wt.eu-S1760048AbYHZTiF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760048AbYHZTiF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 15:38:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756515AbYHZThw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 15:37:52 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53153 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755541AbYHZThv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 15:37:51 -0400
Date: Tue, 26 Aug 2008 15:28:48 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Travis <travis@sgi.com>, "Alan D. Brunelle" <Alan.Brunelle@hp.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Luck, Tony" <tony.luck@intel.com>, Jack Steiner <steiner@sgi.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c -
	bisected
Message-ID: <20080826192848.GA20653@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Mike Travis <travis@sgi.com>,
	"Alan D. Brunelle" <Alan.Brunelle@hp.com>,
	Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Arjan van de Ven <arjan@linux.intel.com>,
	Rusty Russell <rusty@rustcorp.com.au>,
	"Siddha, Suresh B" <suresh.b.siddha@intel.com>,
	"Luck, Tony" <tony.luck@intel.com>, Jack Steiner <steiner@sgi.com>,
	Christoph Lameter <cl@linux-foundation.org>
References: <48B29F7B.6080405@hp.com> <48B2A421.7080705@hp.com> <alpine.LFD.1.10.0808251019380.3363@nehalem.linux-foundation.org> <alpine.LFD.1.10.0808251106270.3363@nehalem.linux-foundation.org> <48B313E0.1000501@hp.com> <alpine.LFD.1.10.0808251326500.3363@nehalem.linux-foundation.org> <alpine.LFD.1.10.0808251344250.3363@nehalem.linux-foundation.org> <alpine.LFD.1.10.0808251401590.3363@nehalem.linux-foundation.org> <48B452F3.9040304@sgi.com> <alpine.LFD.1.10.0808261205530.3363@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0808261205530.3363@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 12:09:46PM -0700, Linus Torvalds wrote:

 > If you want the default kernel to support 4k cores, we'll need to fix the 
 > stack usage.  I don't think that is impossible, but IT IS NOT GOING TO 
 > HAPPEN for 2.6.27.
 > 
 > And quite frankly, if some vendor like RedHat enables NR_CPUS=4096 by 
 > default, they are totally and utterly crazy.

heh.  *picks through Fedora changelog*

* Thu Aug 14 2008 Dave Jones <davej@redhat.com>
- Bump max cpus supported on x86-64 to 4096. Just to see what happens.

I never did get to find out unfortunatly, because of the security fiasco
in Fedora infrastructure the last week or two.
 
 > But some SGI-specific binary that is meant for SGI machines only, and has 
 > been extensively tested with the setup used on SGI machines is a different 
 > thing.

Every extra kernel image a distro vendor ends up shipping has an associated cost.

* build time: It currently takes about 2 hours for a set of Fedora RPMs.
  For RHEL it'll be even worse due to the extra archs).
  Killing off -smp specific builds was a big win for us in this regard.
  Adding extra flavours is always painful.

* diskspace (distro kernels aren't small. With the associated debugging symbols,
   they take up a shitload of disk space really fast).

* Having everyone running the same kernel makes it much easier to test/debug.
  Our QA guys hate adding extra columns to their test matrix.

But yes, for this to be even remotely feasible, there has to be a negligable
performance cost associated with it, which right now, we clearly don't have.
Given that the number of people running 4096 CPU boxes even in a few years time
will still be tiny, punishing the common case is obviously absurd.

	Dave

-- 
http://www.codemonkey.org.uk
