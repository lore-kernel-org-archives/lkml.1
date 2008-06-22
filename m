Return-Path: <linux-kernel-owner+w=401wt.eu-S1756898AbYFVUiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898AbYFVUiS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 16:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754706AbYFVUiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 16:38:08 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:35546 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755138AbYFVUiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 16:38:07 -0400
Date: Sun, 22 Jun 2008 23:36:15 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Greg KH <gregkh@suse.de>
Cc: Johannes Weiner <hannes@saeurebad.de>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Bernhard Walle <bwalle@suse.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 4/5] x86: use BOOTMEM_EXCLUSIVE on 32-bit
Message-ID: <20080622203615.GD20122@cs181140183.pp.htv.fi>
References: <20080622185327.348377223@mini.kroah.org> <20080622190131.GB20141@suse.de> <87prq9dxst.fsf@skyscraper.fehenstaub.lan> <20080622203047.GC20800@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080622203047.GC20800@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 22, 2008 at 01:30:47PM -0700, Greg KH wrote:
> On Sun, Jun 22, 2008 at 10:22:58PM +0200, Johannes Weiner wrote:
> > Hi,
> > 
> > Greg KH <gregkh@suse.de> writes:
> > 
> > > 2.6.25-stable review patch.  If anyone has any objections, please let us
> > > know.
> > >
> > > ------------------
> > > From: Bernhard Walle <bwalle@suse.de>
> > >
> > > commit d3942cff620bea073fc4e3c8ed878eb1e84615ce upstream
> > >
> > > This patch uses the BOOTMEM_EXCLUSIVE for crashkernel reservation also for
> > > i386 and prints a error message on failure.
> > >
> > > The patch is still for 2.6.26 since it is only bug fixing. The unification
> > > of reserve_crashkernel() between i386 and x86_64 should be done for 2.6.27.
> > >
> > > Signed-off-by: Bernhard Walle <bwalle@suse.de>
> > > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > >
> > > ---
> > >  arch/x86/kernel/setup_32.c |   10 ++++++++--
> > >  1 file changed, 8 insertions(+), 2 deletions(-)
> > >
> > > --- a/arch/x86/kernel/setup_32.c
> > > +++ b/arch/x86/kernel/setup_32.c
> > > @@ -483,10 +483,16 @@ static void __init reserve_crashkernel(v
> > >  					(unsigned long)(crash_size >> 20),
> > >  					(unsigned long)(crash_base >> 20),
> > >  					(unsigned long)(total_mem >> 20));
> > > +
> > > +			if (reserve_bootmem(crash_base, crash_size,
> > > +					BOOTMEM_EXCLUSIVE) < 0) {
> > > +				printk(KERN_INFO "crashkernel reservation "
> > > +					"failed - memory is in use\n");
> > > +				return;
> > > +			}
> > 
> > You will also need the patch from http://lkml.org/lkml/2008/6/21/103 to
> > make sure reserve_bootmem() is not void (*)().
> 
> Ok, let me know when that goes into Linus's tree please.

It's commit 71c2742f5e6348d76ee62085cf0a13e5eff0f00e

> thanks,
> 
> greg k-h

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

