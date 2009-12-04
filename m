Return-Path: <linux-kernel-owner+w=401wt.eu-S1755417AbZLDPF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbZLDPF6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 10:05:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751147AbZLDPF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 10:05:57 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38099 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbZLDPF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 10:05:57 -0500
Date: Fri, 4 Dec 2009 09:29:27 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Shane Wang <shane.wang@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       "Cihula, Joseph" <joseph.cihula@intel.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "jmorris@namei.org" <jmorris@namei.org>,
       "jbeulich@novell.com" <jbeulich@novell.com>,
       "peterm@redhat.com" <peterm@redhat.com>, len.brown@intel.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH] intel_txt: add s3 userspace memory integrity
	verification
Message-ID: <20091204082927.GF1540@ucw.cz>
References: <4B18D26B.4040500@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B18D26B.4040500@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> This patch added verification for userspace memory integrity after
>  S3 resume.

It does not work.

> Integrity verification for other memory (say kernel itself) has been done by tboot.
>

Not true. Kernel  uses memory above 4G on x86-64. Including... say
console writing functions.

You can patch holes, but without description 'what does this protect
against' it is almost impossible to evaluate.


> +void tboot_do_suspend_lowlevel(void)
> +{
> +	int ret = -1;
> +
> +	if (!tboot_enabled()) {
> +		do_suspend_lowlevel();
> +		return;
> +	}
> +
> +	ret = tboot_pre_stack_switch();
> +	if (!ret) {
> +		tboot_switch_stack_call(tboot_do_suspend_lowlevel_call,
> +					(u64)new_stack_ptr);

...and here you add requirements to suspend_lowlevel that were not
there before. ("May not act on unchecksummed memory"), without
documenting them.

NAK.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
