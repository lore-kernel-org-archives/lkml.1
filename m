Return-Path: <linux-kernel-owner+w=401wt.eu-S1758110AbYJWRBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110AbYJWRBk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 13:01:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756522AbYJWRB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 13:01:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48717 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756498AbYJWRB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 13:01:28 -0400
Date: Thu, 23 Oct 2008 19:02:12 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       travis@sgi.com, Ingo Molnar <mingo@elte.hu>
Subject: do_boot_cpu can deadlock?
Message-ID: <20081023170212.GA22599@redhat.com>
References: <20081023005751.53973DDEFE@ozlabs.org> <20081023094036.GA7593@redhat.com> <20081023143605.GN5255@in.ibm.com> <20081023163517.GB21008@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081023163517.GB21008@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm. arch/x86/kernel/smpboot.c:do_boot_cpu() can deadlock ?

It is called from _cpu_up() under cpu_hotplug_begin(), and it
waits for c_idle.work. Again, if we have the pending work which
needs get_online_cpus() we seem to have problems.

Oleg.

