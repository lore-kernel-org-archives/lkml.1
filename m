Return-Path: <linux-kernel-owner+w=401wt.eu-S1753178Ab0AHLwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178Ab0AHLwy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 06:52:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752774Ab0AHLwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 06:52:53 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:54950 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552Ab0AHLww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 06:52:52 -0500
Date: Fri, 8 Jan 2010 11:54:06 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Jamie Iles <jamie.iles@picochip.com>, linux-kernel@vger.kernel.org,
       Jamie Iles <jamie@jamieiles.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] perf symbols: don't use modules or try vmlinux unless
	needed
Message-ID: <20100108115406.GL4179@wear.picochip.com>
References: <1262600634-6628-1-git-send-email-jamie.iles@picochip.com> <20100108113657.GE12660@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100108113657.GE12660@ghostprotocols.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 08, 2010 at 09:36:57AM -0200, Arnaldo Carvalho de Melo wrote:
> Ecanfcan Mon, Jan 04, 2010 at 10:23:54AM +0000, Jamie Iles escreveu:
> > Commit 75be6cf (perf symbols: Make symbol_conf global) does what it says
> > on the tin, but also initialises the member fields use_modules and
> > try_vmlinux_path to true rather than the 'false' value they would have
> > had when symbol_conf was static.
> > 
> > When there is no vmlinux on the system and modules loaded, perf top will
> > not show any kernel symbols and perf report will only list raw IP's
> > rather than symbol names. Unloading the modules will allow perf to give
> > normal output.
> > 
> > Restore previous behaviour by initialising these fields to false.
> 
> James,
> 
> 	I just tried using perf top here in such conditions:
> 
[snip]
> 
> And it is resolving the kernel symbols.
> 
> Maybe some changes I made that aren't yet in Ingo's tree or upstream
> fixed it, can you please try after those patches are merged?
Ok, could you let me know when the relevant ones are in there? From todays
next tree, without the patch I still only get userspace symbols (system loaded
with 'dd if=/dev/zero of=/dev/null' to make sure it's busy):

               49.00 17.6% T.276                   /root/tools/perf    
               25.00  9.0% __GI_strcmp             /lib/libc-2.8.so    
               21.00  7.6% symbol_filter           /root/tools/perf    
               17.00  6.1% strncmp                 /root/tools/perf    
	       ...

But with the patch applied output looks good:

              597.00 17.0% _raw_spin_unlock_irq        [kernel.kallsyms]
              589.00 16.8% lock_acquire                [kernel.kallsyms]
              367.00 10.4% _raw_spin_unlock_irqrestore [kernel.kallsyms]
              230.00  6.5% vector_swi                  [kernel.kallsyms]
              122.00  3.5% __memzero                   [kernel.kallsyms]
               71.00  2.0% lock_release                [kernel.kallsyms]
	       ...

Jamie
