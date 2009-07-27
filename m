Return-Path: <linux-kernel-owner+w=401wt.eu-S1751546AbZG0OZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546AbZG0OZk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 10:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751363AbZG0OZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 10:25:39 -0400
Received: from tomts16.bellnexxia.net ([209.226.175.4]:63228 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750851AbZG0OZi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 10:25:38 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AugEAJRPbUpMQWXi/2dsb2JhbACBUc5vhA0F
Date: Mon, 27 Jul 2009 10:25:32 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Dave Jones <davej@redhat.com>, Thomas Renninger <trenn@suse.de>,
       linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
       kernel-testers@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Dave Young <hidave.darkstar@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: cpufreq cleanups - .30 vs .31
Message-ID: <20090727142532.GA22503@Krystal>
References: <200907061318.20839.trenn@suse.de> <20090707015115.GB5310@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20090707015115.GB5310@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:22:41 up 149 days, 10:48,  4 users,  load average: 0.22, 0.52,
	0.53
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dave Jones (davej@redhat.com) wrote:
> On Mon, Jul 06, 2009 at 01:18:18PM +0200, Thomas Renninger wrote:
> 
>  > So if not find too intrusive, I'd say:
>  > Venkatesh's whole series of:
>  > [patch 0/4] Take care of cpufreq lockdep issues (take 2)
>  > should be seen in .31.
>  >  ...
>  > The one patch from Mathieu:
>  > [patch 2.6.30 2/4] CPUFREQ: fix (utter) cpufreq_add_dev mess
>  > is a separate, general cleanup which should show up in .31.
> 
> I came to the same conclusion after reading the thread, and looking
> over the patches.  I merged the above, and sent Linus a pull request
> a few minutes ago.
> 
> Thanks Mathieu and Venki for chasing this down.
> 
> 	Dave

Given I never got an answer to this question, I'm re-asking a question I
asked in a previous thread about Venki's patchset:

[CPUFREQ] Cleanup locking in ondemand governor
commit	5a75c82828e7c088ca6e7b4827911dc29cc8e774

>From the earlier thread:
Subject: Re: [patch 2.6.30 3/4] cpufreq add gov mutex

I am worried about potential races between add_dev/remove_dev, which
currently lock the rwsem as mean of protection, and execution of timer
handler that would not take the rwsem to protect itself anymore, due to
your changes.

I'm especially worried about the call to

              __cpufreq_driver_target(dbs_info->cur_policy,
                        dbs_info->freq_lo, CPUFREQ_RELATION_H);

which seems to depend on policy-level information, protected at the
rwsem-level.

By removing the rwsem from the timer handler, I don't see how you plan
to protect this information from add_dev/remove_dev execution.


Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
