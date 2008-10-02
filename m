Return-Path: <linux-kernel-owner+w=401wt.eu-S1753727AbYJBIM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727AbYJBIM5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 04:12:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752792AbYJBIMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 04:12:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36665 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752729AbYJBIMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 04:12:41 -0400
Date: Thu, 2 Oct 2008 10:12:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch x86/core] x86: allow number of additional hotplug CPUs
	to be set at compile time
Message-ID: <20081002081231.GC17695@elte.hu>
References: <20081001191945.4182d0be@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081001191945.4182d0be@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Chuck Ebbert <cebbert@redhat.com> wrote:

> From: Chuck Ebbert <cebbert@redhat.com>
> 
> x86: allow number of additional hotplug CPUs to be set at compile time
> 
> The default number of additional CPU IDs for hotplugging is determined 
> by asking ACPI or mptables how many "disabled" CPUs there are in the 
> system, but many systems get this wrong so that e.g. a uniprocessor 
> machine gets an extra CPU allocated and never switches to single CPU 
> mode.
> 
> And sometimes CPU hotplugging is enabled only for suspend/hibernate 
> anyway, so the additional CPU IDs are not wanted. Allow the number to 
> be set to zero at compile time.
> 
> Also, force the number of extra CPUs to zero if hotplugging is 
> disabled which allows removing some conditional code.
> 
> Tested on uniprocessor x86_64 that ACPI claims has a disabled 
> processor, with CPU hotplugging configured.
> 
> ("After" has the number of additional CPUs set to 0)
> Before: NR_CPUS: 512, nr_cpu_ids: 2, nr_node_ids 1
> After: NR_CPUS: 512, nr_cpu_ids: 1, nr_node_ids 1
> 
> Signed-off-by: Chuck Ebbert <cebbert@redhat.com>

hm, wouldnt this option kill 'real' hot-plug CPUs (how rare they might 
be) which are properly enumerated in the BIOS tables?

i dont mind having a facility to disable real CPU hotplug, but the 
CONFIG_HOTPLUG_DEFAULT_ADDITIONAL_CPUS does not spell that out clearly 
IMO. Something like CONFIG_HOTPLUG_RESTRICT_TO_BOOTUP_CPUS=y would be 
more appropriately named i think?

	Ingo
