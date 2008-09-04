Return-Path: <linux-kernel-owner+w=401wt.eu-S1755472AbYIDVrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472AbYIDVrU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 17:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753977AbYIDVrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 17:47:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753913AbYIDVrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 17:47:08 -0400
Date: Thu, 4 Sep 2008 17:46:28 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Don Zickus <dzickus@redhat.com>
Cc: "Mingarelli, Thomas" <Thomas.Mingarelli@hp.com>,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Prarit Bhargava <prarit@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "arozansk@redhat.com" <arozansk@redhat.com>,
       "ak@linux.intel.com" <ak@linux.intel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH RFC] NMI Re-introduce un[set]_nmi_callback
Message-ID: <20080904214628.GE4349@redhat.com>
References: <20080904172052.GN3400@redhat.com> <20080904175231.GH18288@one.firstfloor.org> <20080904182637.GP3400@redhat.com> <20080904190816.GB4349@redhat.com> <20080904200032.GM18288@one.firstfloor.org> <183C1D5A376DE343AA8F94FC2A1EC14938D3E74841@GVW1091EXB.americas.hpqcorp.net> <20080904205725.GC4349@redhat.com> <183C1D5A376DE343AA8F94FC2A1EC14938D3E748D1@GVW1091EXB.americas.hpqcorp.net> <20080904212134.GD4349@redhat.com> <20080904212453.GR3400@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080904212453.GR3400@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2008 at 05:24:53PM -0400, Don Zickus wrote:
> On Thu, Sep 04, 2008 at 05:21:34PM -0400, Vivek Goyal wrote:
> > On Thu, Sep 04, 2008 at 09:05:37PM +0000, Mingarelli, Thomas wrote:
> > > Ok regarding question #1. The die_notifier works as you mentioned; however, the fact that the watchdog timer ticks also come through as NMIs is a hinderance. Now, when the watchdog timer is configured through the LOCAL_APIC the issue isn't so bad. I think the hpwdt driver handles the NMI coming in because there isn't a flood of timer ticks coming through as in the IOAPIC case.
> > 
> > Ok, so how does replacing the nmi callback help here? You driver handler
> > be still called upon timer ticks. So you will be called on watchdog tick
> > whether you are on die chain or you replace nmi handler with nmi callback.
> > So watchdog ticks can't be a reason for not being on die chain.
> 
> Prarit's patch disabled the timer upon registering a callback to prevent
> this case.  The thought was if you have your own handler you could provide
> your own watchdog.
> 

In theory, you could do the same while registering the handler on die
chain?

I don't get the whole point. So we are looking for a system where no body
else uses an NMI for any purpose and the moment NMI happens, this driver
will go and panic() the system. I don't get, what do we achive by that?

Looks like you got some device in platform which raises an NMI and which
indicates that something is wrong and log the message and do a panic(). 
But you don't have a way to find out if that device has raised the
interrupt or something else has raised the NMI, hence you want to stop the
watchdog timer and assume any NMI henceforth is from device?

So any functionality which is dependent on NMI, will not work as long as
this driver is loaded. 

Thanks
Vivek
