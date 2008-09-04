Return-Path: <linux-kernel-owner+w=401wt.eu-S1756822AbYIDUHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822AbYIDUHo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 16:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754198AbYIDUHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 16:07:35 -0400
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:6469 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493AbYIDUHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 16:07:34 -0400
Date: Thu, 4 Sep 2008 22:14:18 +0200
From: Krzysztof Helt <krzysztof.h1@poczta.fm>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       "Krzysztof Helt" <krzysztof.h1@wp.pl>
Subject: Re: [PATCH 5/6] x86: move mtrr cpu cap setting early in
 early_init_xxxx
Message-Id: <20080904221418.239c2b54.krzysztof.h1@poczta.fm>
In-Reply-To: <86802c440809041217p454c4471y66a8ed6907d9cc8@mail.gmail.com>
References: <1220312246-30879-1-git-send-email-yhlu.kernel@gmail.com>
	<1220312246-30879-5-git-send-email-yhlu.kernel@gmail.com>
	<20080904191333.GD24990@elte.hu>
	<86802c440809041217p454c4471y66a8ed6907d9cc8@mail.gmail.com>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-EMID: 38e2b138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Sep 2008 12:17:14 -0700
"Yinghai Lu" <yhlu.kernel@gmail.com> wrote:

> On Thu, Sep 4, 2008 at 12:13 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> >
> >> Krzysztof Helt <krzysztof.h1@wp.pl> found mtrr is not detected on k6-2
> >>
> >> root case:
> >>       we move mtrr_bp_init early for mtrr trimming.
> >> and in early_detect, only read cap from cpuid, so some cpu doesn't have
> >> that bit in cpuid and need to set workaround bit will have problem.
> >>
> >> need to add early_init_xxxx to preset those bit before mtrr_bp_init
> >> for those earlier cpus.
> >>
> >> this patch is for 2.6.27
> >
> > hm, not sure we can do it in v2.6.27 as it depends on the other CPU init
> > patches and that is a rather sensitive codepath. This problem should be
> > present in v2.6.26 too, right?
> 
> Yes. old cpus without cpuid bit for mtrr need this patch...
> Krzysztof Helt tested it and it works with 2.6.27-rc5 (?)
> 
> 

Yes, I tested the patches with 2.6.27-rc5.

I was too lazy to find the case of this breakage as the mtrr register
detection was "always" displayed during boot on this machine.
I found the source of the breakage now:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=03ae5768b6110ebaa97dc3e7abf1c3d8bec5f874

The  early_cpu_init() called directly amd_init_cpu() which set up mtrr flags on K6 cpus. 
This got removed by this patch with no replacement. This is dated as 2008-04-17.

As the K6 machine is my secondary computer (to test older stuff, ISA, etc) I do not
boot it every day. Add holidays and it could be that it went unnoticed since April.

I hope this is answer your question. If you want I can retest the 2.6.26 kernel version.

Kind regards,
Krzysztof

----------------------------------------------------------------------
Mobilne aplikacje na Twoj telefon!
Sprawdz >> http://link.interia.pl/f1eff 

