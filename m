Return-Path: <linux-kernel-owner+w=401wt.eu-S1753301AbYANNxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301AbYANNxS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 08:53:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751022AbYANNxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 08:53:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50209 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982AbYANNxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 08:53:07 -0500
Date: Mon, 14 Jan 2008 14:52:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, rjw@sisk.pl, pavel@suse.cz,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86] [15/16] Force __cpuinit on for CONFIG_PM without
	HOTPLUG_CPU
Message-ID: <20080114135240.GA15357@elte.hu>
References: <20080103442.621670000@suse.de> <20080110111514.GS25945@bingen.suse.de> <20080110112607.GE28740@does.not.exist> <200801101242.53504.ak@suse.de> <20080110124702.GF28740@does.not.exist> <p73fxx5omck.fsf@bingen.suse.de> <20080110150911.GG28740@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080110150911.GG28740@does.not.exist>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Adrian Bunk <bunk@kernel.org> wrote:

> On Thu, Jan 10, 2008 at 02:12:59PM +0100, Andi Kleen wrote:
> > Adrian Bunk <bunk@kernel.org> writes:
> > >
> > > Technically you are the one who has to deal with problems in your 
> > > patches, not the people pointing at the problems.
> > 
> > If you believe that my patch adds a new problem then please describe
> > it clearly so that I can understand it.
> 
> Description:
> - there are already __cpuinit* annotations in the kernel
> - on UP kernels supporting suspend/resume, such annotated code
>   currently gets freed after booting (and this works)
> - with your patch applied, this code no longer gets freed

ok, i've dropped this patch from x86.git for now:

 Subject: x86: force __cpuinit on for CONFIG_PM without HOTPLUG_CPU
 From: Andi Kleen <ak@suse.de>

but longer-term, shouldnt these annotations be automated? We'll see a 
constant stream of them, all around the clock as people regularly get it 
wrong (because it's not intuitive).

	Ingo
