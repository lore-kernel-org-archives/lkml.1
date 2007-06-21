Return-Path: <linux-kernel-owner+w=401wt.eu-S1754167AbXFUIhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167AbXFUIhK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 04:37:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752830AbXFUIg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 04:36:58 -0400
Received: from tayrelbas01.tay.hp.com ([161.114.80.244]:42889 "EHLO
	tayrelbas01.tay.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443AbXFUIg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 04:36:57 -0400
Date: Thu, 21 Jun 2007 01:36:45 -0700
From: Stephane Eranian <eranian@hpl.hp.com>
To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
       Andi Kleen <ak@suse.de>, mingo@elte.hu, linux-kernel@vger.kernel.org,
       levon@movementarian.org, perfmon@napali.hpl.hp.com,
       oprofile-list@lists.sourceforge.net, wcohen@redhat.com,
       akpm@linux-foundation.org
Subject: Re: [perfmon] Re: [PATCH 1/2] Separate the performance counter allocation from the LAPIC NMI watchdog
Message-ID: <20070621083645.GA26740@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <20070618103214.GA12045@atjola.homenet> <200706201431.44014.ak@suse.de> <20070620124959.GB24906@frankl.hpl.hp.com> <200706201501.02582.ak@suse.de> <20070620183315.GA3251@atjola.homenet> <20070620215933.GE26200@frankl.hpl.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070620215933.GE26200@frankl.hpl.hp.com>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn,


On Wed, Jun 20, 2007 at 02:59:33PM -0700, Stephane Eranian wrote:
> Bjorn,
> 
> I ran into one issue related with the new allocator.
> 
> In the case of a Core 2 Duo processor, the PMU implements more
> than just basic counters. In particular it supports fixed counters
> and PEBS where both use another set of MSRs. Those are not within
> a 66 bit distance from MSR_ARCH_PERFMON_EVNTSEL0. Thus the allocator
> fails with an assertion.
> 
> I do know that perfmon is the only consumer of those extended 
> features TODAY. Yet I think we need to define the allocator such
> that it can work with other "distant" MSRs as well.
> 

I think that a workaround for this issue could be for the allocator
to grant the requests for registers outside of the range, i.e., register
that it does not see/manage.

> On Wed, Jun 20, 2007 at 08:33:15PM +0200, Bj?rn Steinbrink wrote:
> > On 2007.06.20 15:01:02 +0200, Andi Kleen wrote:
> > > 
> > > > Once this is fixed (which is what Bjorn did), then I will agree with you.
> > > > For this, the allocator needs to be able to probe the CPU and initialize
> > > > its own data structures.
> > > 
> > > Ok that sounds reasonable. Please someone send a patch that does only 
> > > that.
> > 
> > OK, here come the bugfixes without any restructuring. The first patch
> > enables unconditional probing of the watchdog. The second makes the
> > perfmon nmi watchdog reserve the correct perfctr/evntsel.
> > 
> > Björn
> > 
> > -------------------------------------------------------------------------
> > This SF.net email is sponsored by DB2 Express
> > Download DB2 Express C - the FREE version of DB2 express and take
> > control of your XML. No limits. Just data. Click to get it now.
> > http://sourceforge.net/powerbar/db2/
> > _______________________________________________
> > oprofile-list mailing list
> > oprofile-list@lists.sourceforge.net
> > https://lists.sourceforge.net/lists/listinfo/oprofile-list
> 
> -- 
> 
> -Stephane
> _______________________________________________
> perfmon mailing list
> perfmon@linux.hpl.hp.com
> http://www.hpl.hp.com/hosted/linux/mail-archives/perfmon/

-- 

-Stephane
