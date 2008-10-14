Return-Path: <linux-kernel-owner+w=401wt.eu-S1752309AbYJNOg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309AbYJNOg3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 10:36:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750922AbYJNOgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 10:36:21 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:35879 "EHLO
	IE1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbYJNOgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 10:36:20 -0400
X-BigFish: VPS-44(z5edJz62a3L1432R98dR936eQ1805M936fOzzzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K8QGK4-02-QWT-01
Date: Tue, 14 Oct 2008 16:35:22 +0200
From: Robert Richter <robert.richter@amd.com>
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, oprofile-list@lists.sourceforge.net,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Please pull arch perfmon update
Message-ID: <20081014143521.GH23557@erda.amd.com>
References: <20080929235253.GA31074@one.firstfloor.org> <20081013183556.GD23557@erda.amd.com> <48F3AFBF.3040201@firstfloor.org> <20081014140549.GG23557@erda.amd.com> <20081014141507.GQ12131@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20081014141507.GQ12131@one.firstfloor.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 14 Oct 2008 14:35:35.0826 (UTC) FILETIME=[1ECFDF20:01C92E0A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.10.08 16:15:07, Andi Kleen wrote:
> On Tue, Oct 14, 2008 at 04:05:50PM +0200, Robert Richter wrote:
> > On 13.10.08 22:29:51, Andi Kleen wrote:
> > > > I added a follow on patch (446223f) on branch arch-perfmon that
> > > 
> > > I didn't do that intentionally because it's called too late.
> > > The function really has to be called early, so that the fallback
> > > works.
> > 
> > The hook is in op_nmi_init() and directly called after
> > arch_perfmon_init() and before init_sysfs(). Only
> > register_cpu_notifier() and the setup of oprofile_operations are in
> > between. This should work.
> 
> The problem is that arch perfmon init should only be called after
> the other initialization function failed.
> 
> So you would need a chain of op_x86_model_spec for fallback.
> 
> It's simpler and cleaner to just write that out in explicit C.

The patch makes arch_perfmon_setup_counters() static, so the init code
is bound directly to the model (it is model specific code). The
interface is much cleaner now since the delaration as an external is
not needed then.

The init function is only called, if this cpu type (i386/arch_perfmon)
is selected. And this type is only selected after all other init
funtions were failing.

Please test the patch, I don't see a reason why it should not work.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

