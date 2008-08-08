Return-Path: <linux-kernel-owner+w=401wt.eu-S1754247AbYHHB1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247AbYHHB1X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 21:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbYHHB1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 21:27:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49065 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284AbYHHB1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 21:27:14 -0400
Date: Thu, 7 Aug 2008 21:26:23 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: jmerkey@wolfmountaingroup.com
Cc: Jay Lan <jlan@sgi.com>, Christoph Lameter <cl@linux-foundation.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <andi@firstfloor.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org,
       Takenori Nagano <t-nagano@ah.jp.nec.com>,
       Bernhard Walle <bwalle@suse.de>, Keith Owens <kaos@ocs.com.au>
Subject: Re: [ANNOUNCE] Merkey's Kernel Debugger
Message-ID: <20080808012623.GA3911@redhat.com>
References: <17494.166.70.238.46.1217784156.squirrel@webmail.wolfmountaingroup.com> <200808060133.10457.nickpiggin@yahoo.com.au> <87r6926dsr.fsf@basil.nowhere.org> <200808061550.22996.nickpiggin@yahoo.com.au> <489B34BA.4060300@linux-foundation.org> <489B3A0D.7060706@s5r6.in-berlin.de> <489B48BF.3060609@linux-foundation.org> <489B5149.4030600@sgi.com> <2232.69.2.248.210.1218137662.squirrel@webmail.wolfmountaingroup.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2232.69.2.248.210.1218137662.squirrel@webmail.wolfmountaingroup.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2008 at 01:34:22PM -0600, jmerkey@wolfmountaingroup.com wrote:
> > Christoph Lameter wrote:
> >> Stefan Richter wrote:
> >>> Christoph Lameter wrote:
> >>>> The competing implementation is kdb not kgdb. kgdb is just a stub for
> >>>> remote
> >>>> debugging using gdb. kdb is an in-kernel debugger like the one
> >>>> proposed here.
> >>> Is there work underway to get kdb merged?  (I'm just asking because I
> >>> don't know; I personally don't need kdb nor mdb.)
> >>
> >> KDB still exists in patches but the merge effort was given up when Linus
> >> stated that he did not want a kernel debugger. No problem to start merge
> >> attempts again AFAICT. Jay?
> >
> > To merge KDB or any other RAS tools, you need to deal with kdump. Kdump
> > hijack panic() before the die calling chain. For KDB or a RAS tool to
> > work, an infrastructure such as the "add new notifier function" by
> > Takenori Nagano should be in place.
> >
> > His last attempt fell short, in my opinion, was partly due to his
> > "[PATCH 3/3] Move crash_kexec() into  panic_notifier" did not do what it
> > meant to do: to fit kexec/kdump into the new infrastructure. That is
> > not fatal; it can be fixed to make it right. If community is interested
> > in getting a kernel debugger to the kernel, we can continue Takenori's
> > work. Once the infrastructure is accepted, then merging KDB or any other
> > kernel debugger will make sense.
> >
> > Regards,
> >  - jay
> >
> >
> >>
> 
> As I look through entry_32.S and traps_32.c I do not see where kdump is
> hooking the notify_die handler which would intercept calls to a debugger.
> 
> Where does kdump hook this path?
> 

kdump uses crash_kexec() call for hooking. It hooks in panic(), die_nmi()
and die().

Thanks
Vivek
