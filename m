Return-Path: <linux-kernel-owner+w=401wt.eu-S1755682AbZA3EoI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682AbZA3EoI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 23:44:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755727AbZA3Enp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 23:43:45 -0500
Received: from ozlabs.org ([203.10.76.45]:36695 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755331AbZA3Eno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 23:43:44 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: circular locking dependency on shutdown
Date: Fri, 30 Jan 2009 15:13:35 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Manfred Spraul <manfred@colorfullife.com>,
       Peter Zijlstra <peterz@infradead.org>, cpufreq@vger.kernel.org
References: <1233255049.4067.12.camel@johannes.local>
In-Reply-To: <1233255049.4067.12.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901301513.36002.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 30 January 2009 05:20:49 Johannes Berg wrote:
> Hi,
> 
> Every time I shut down my machine with a 2.6.29-rc2 kernel, I get a
> lockdep report that scrolls off.
...
> halt is trying to acquire lock
> 	(&per_cpu(cpu_policy_rwsem, cpu)){---}
> 
> but task is already holding lock
> 	(&cpu_hotplug.lock){--..}

Hi Johannes,

   This looks much like the work_on_cpu()-getting-hotplug-lock problem which caused us to stop work_on_cpu doing that.  -rc3 has that fix; any chance of a re-test?

Thanks,
Rusty.
