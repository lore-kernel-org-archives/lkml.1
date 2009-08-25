Return-Path: <linux-kernel-owner+w=401wt.eu-S1754612AbZHYHWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612AbZHYHWY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 03:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754234AbZHYHWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 03:22:20 -0400
Received: from viefep14-int.chello.at ([62.179.121.34]:38839 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104AbZHYHWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 03:22:20 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH] perf_counter: Start counting time enabled when group
 leader gets enabled
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>
Cc: eranian@gmail.com, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Andi Kleen <andi@firstfloor.org>, Maynard Johnson <mpjohn@us.ibm.com>,
       Carl Love <cel@us.ibm.com>, Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
In-Reply-To: <19091.29664.342227.445006@drongo.ozlabs.ibm.com>
References: <7c86c4470908200649u290f2378n126442ea3a823540@mail.gmail.com>
	 <1251121618.7538.262.camel@twins>
	 <7c86c4470908240844u7450b13eicf4c4a466e29d701@mail.gmail.com>
	 <19091.29664.342227.445006@drongo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Tue, 25 Aug 2009 09:21:28 +0200
Message-Id: <1251184888.7538.1087.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-25 at 15:17 +1000, Paul Mackerras wrote:
> Currently, if a group is created where the group leader is initially
> disabled but a non-leader member is initially enabled, and then the
> leader is subsequently enabled some time later, the time_enabled for
> the non-leader member will reflect the whole time since it was created,
> not just the time since the leader was enabled.  This is incorrect,
> because all of the members are effectively disabled while the leader
> is disabled, since none of the members can go on the PMU if the leader
> can't.
> 
> Thus we have to update the ->tstamp_enabled for all the enabled group
> members when a group leader is enabled, so that the time_enabled
> computation only counts the time since the leader was enabled.
> Similarly, when disabling a group leader we have to update the
> time_enabled and time_running for all of the group members.
> Also, in update_counter_times, we have to treat a counter whose group
> leader is disabled as being disabled.
> 
> Reported-by: Stephane Eranian <eranian@googlemail.com>
> Signed-off-by: Paul Mackerras <paulus@samba.org>

Looks good, thanks Paul!

