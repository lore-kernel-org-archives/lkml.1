Return-Path: <linux-kernel-owner+w=401wt.eu-S1753425AbZFBUzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbZFBUzp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 16:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbZFBUzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 16:55:37 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:48893 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbZFBUzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 16:55:37 -0400
Subject: Re: [tip:timers/ntp] ntp: adjust SHIFT_PLL to improve NTP
 convergence
From: john stultz <johnstul@us.ibm.com>
To: Miroslav Lichvar <mlichvar@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Rik van Riel <riel@redhat.com>,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
In-Reply-To: <20090602162208.GA15696@localhost>
References: <200905051956.n45JuVo9025575@imap1.linux-foundation.org>
	 <tip-22cfbbfd9f67b67fe073010f51cb71d3632387d5@git.kernel.org>
	 <1243542817.29511.523.camel@jstultz-laptop> <20090601232223.GH749@elte.hu>
	 <1243900716.11263.42.camel@jstultz-laptop> <4A246D0B.40204@redhat.com>
	 <20090602002039.GA16410@elte.hu>  <20090602162208.GA15696@localhost>
Content-Type: text/plain
Date: Tue, 02 Jun 2009 13:55:35 -0700
Message-Id: <1243976135.3501.10.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-02 at 18:22 +0200, Miroslav Lichvar wrote:
> On Tue, Jun 02, 2009 at 02:20:39AM +0200, Ingo Molnar wrote:
> > 
> > Not just that - but there's calibration noise during bootup that can 
> > cause randomly distributed recalibrations as well. So other hosts in 
> > a mixed environment will see inconsistencies anyway, after every 
> > bootup.
[snip]
> As for the calibration issue, would it be possible to export the
> information that an instable clocksource is used and when was the last
> time it was calibrated? Then we'd know when the drift file should not
> be trusted and let NTP calculate the frequency directly (it takes
> about 15 minutes).

Just to de-thread the issues here, the calibration noise issue really is
separate from the SHIFT_PLL convergence issue.

I'd really prefer the calibration noise issue to be resolved by the
kernel, as its really only an issue on a subset of x86 machines. The
tsc_khz= boot option I proposed earlier for folks who really care seems
to me like a good route.

The only NTPd side change to help the calibration issue that might be
useful, would be a explicit ntp option to force NTP to always calculate
the freq on startup if the drift file was present or not. Anything else
would be way too much of a hack to get around bad kernel behavior.

thanks
-john


