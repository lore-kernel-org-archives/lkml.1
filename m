Return-Path: <linux-kernel-owner+w=401wt.eu-S1758571AbYJWSWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758571AbYJWSWX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 14:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758316AbYJWSWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 14:22:05 -0400
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:55778 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758284AbYJWSWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 14:22:04 -0400
Date: Thu, 23 Oct 2008 23:51:19 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       travis@sgi.com, Ingo Molnar <mingo@elte.hu>
Subject: Re: do_boot_cpu can deadlock?
Message-ID: <20081023182119.GA1480@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20081023005751.53973DDEFE@ozlabs.org> <20081023094036.GA7593@redhat.com> <20081023143605.GN5255@in.ibm.com> <20081023163517.GB21008@redhat.com> <20081023170212.GA22599@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081023170212.GA22599@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2008 at 07:02:12PM +0200, Oleg Nesterov wrote:
> Hmm. arch/x86/kernel/smpboot.c:do_boot_cpu() can deadlock ?
> 
> It is called from _cpu_up() under cpu_hotplug_begin(), and it
> waits for c_idle.work. Again, if we have the pending work which
> needs get_online_cpus() we seem to have problems.

Good point. Though this code gets triggered mostly during boot time when
the CPUs are being brought online for the first time. If we have some
work-item pending at that time, which needs get_online_cpus(), we could
possibly see this deadlock.

> 
> Oleg.

-- 
Thanks and Regards
gautham
