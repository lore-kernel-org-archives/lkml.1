Return-Path: <linux-kernel-owner+w=401wt.eu-S1756609AbYIDVXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609AbYIDVXi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 17:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754039AbYIDVXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 17:23:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42387 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753557AbYIDVXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 17:23:30 -0400
Date: Thu, 4 Sep 2008 17:22:45 -0400
From: Don Zickus <dzickus@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Mingarelli, Thomas" <Thomas.Mingarelli@hp.com>,
       Vivek Goyal <vgoyal@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Prarit Bhargava <prarit@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "arozansk@redhat.com" <arozansk@redhat.com>,
       "ak@linux.intel.com" <ak@linux.intel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH RFC] NMI Re-introduce un[set]_nmi_callback
Message-ID: <20080904212245.GQ3400@redhat.com>
References: <87y727vrgu.fsf@basil.nowhere.org> <20080904172052.GN3400@redhat.com> <20080904175231.GH18288@one.firstfloor.org> <20080904182637.GP3400@redhat.com> <20080904190816.GB4349@redhat.com> <20080904200032.GM18288@one.firstfloor.org> <183C1D5A376DE343AA8F94FC2A1EC14938D3E74841@GVW1091EXB.americas.hpqcorp.net> <20080904201926.GN18288@one.firstfloor.org> <183C1D5A376DE343AA8F94FC2A1EC14938D3E7486E@GVW1091EXB.americas.hpqcorp.net> <20080904205345.GO18288@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080904205345.GO18288@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2008 at 10:53:45PM +0200, Andi Kleen wrote:
> So if your handler can decide "This is an NMI that came from
> a source i know about" it can be a proper[1] NMI cititzen.

The way it was explained to me months ago, is that it can't.  Currently it
works by making sure the nmi watchdog is disabled on the box (either
compiled off, or nmi_watchdog=0).  Then it registers itself on the DIE
chain.  Because it is on the top of the chain, it just so happens to
be the first handler to process the NMIs, so HP is happy.  Kdump works
because it registers later on top of the HP handler thus it is called
before HP can panic the box.  However, I suspect if one were to run
oprofile in nmi mode, HP would panic the box on the first profile point.

> 
> Otherwise it will be hard to make it coexist nicely.

Hence our attempt at a solution by creating a registration for a new
nmi_handler, which in hindsight seemed to miss a couple of cases.

Cheers,
Don

