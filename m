Return-Path: <linux-kernel-owner+w=401wt.eu-S1753872AbYIDRV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872AbYIDRV6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 13:21:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751124AbYIDRVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 13:21:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47652 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002AbYIDRVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 13:21:50 -0400
Date: Thu, 4 Sep 2008 13:20:52 -0400
From: Don Zickus <dzickus@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, Prarit Bhargava <prarit@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       arozansk@redhat.com, Thomas.Mingarelli@hp.com, ak@linux.intel.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH RFC] NMI Re-introduce un[set]_nmi_callback
Message-ID: <20080904172052.GN3400@redhat.com>
References: <20080904130048.31841.3329.sendpatchset@prarit.bos.redhat.com> <1220535463.8609.223.camel@twins> <48BFF0C0.7060208@redhat.com> <20080904145617.GB28095@elte.hu> <87y727vrgu.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y727vrgu.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2008 at 05:52:17PM +0200, Andi Kleen wrote:
> Then if there's a chipset specific NMI driver it could
> also check if the chipset raised it. That would be a possible
> solution for HP -- they would need to implement such a driver
> for their systems with the special watchdog.

The thing with HP's special watchdog timer is that it does _not_ have a
chipset specific NMI it is trying to catch.  HP is going on the assumption
that _all_ NMIs are /bad/ and they want to catch _every_ NMI, log it, and
reboot the system.

Now obviously NMIs from kgdb and oprofile are not the ones a system should
panic on but this breaks HP's assumptions.

So that is part of the problem.  How do you become a catch-all for NMIs in
a system, to process as you wish, but ignore all the 'safe' NMIs?

Cheers,
Don
