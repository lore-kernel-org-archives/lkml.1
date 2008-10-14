Return-Path: <linux-kernel-owner+w=401wt.eu-S1752849AbYJNOIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbYJNOIc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 10:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750880AbYJNOIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 10:08:25 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60230 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbYJNOIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 10:08:24 -0400
Date: Tue, 14 Oct 2008 16:15:07 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       oprofile-list@lists.sourceforge.net, Ingo Molnar <mingo@elte.hu>
Subject: Re: Please pull arch perfmon update
Message-ID: <20081014141507.GQ12131@one.firstfloor.org>
References: <20080929235253.GA31074@one.firstfloor.org> <20081013183556.GD23557@erda.amd.com> <48F3AFBF.3040201@firstfloor.org> <20081014140549.GG23557@erda.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081014140549.GG23557@erda.amd.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2008 at 04:05:50PM +0200, Robert Richter wrote:
> On 13.10.08 22:29:51, Andi Kleen wrote:
> > > I added a follow on patch (446223f) on branch arch-perfmon that
> > 
> > I didn't do that intentionally because it's called too late.
> > The function really has to be called early, so that the fallback
> > works.
> 
> The hook is in op_nmi_init() and directly called after
> arch_perfmon_init() and before init_sysfs(). Only
> register_cpu_notifier() and the setup of oprofile_operations are in
> between. This should work.

The problem is that arch perfmon init should only be called after
the other initialization function failed.

So you would need a chain of op_x86_model_spec for fallback.

It's simpler and cleaner to just write that out in explicit C.

-Andi
