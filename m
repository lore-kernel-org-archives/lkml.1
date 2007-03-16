Return-Path: <linux-kernel-owner+w=401wt.eu-S965483AbXCPQTO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965483AbXCPQTO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 12:19:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965481AbXCPQTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 12:19:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47588 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965483AbXCPQTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 12:19:12 -0400
Date: Fri, 16 Mar 2007 17:18:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paulo Marques <pmarques@grupopie.com>
Cc: Alexey Dobriyan <adobriyan@sw.ru>, akpm@osdl.org,
       linux-kernel@vger.kernel.org, devel@openvz.org, tglx@linutronix.de,
       viro@zeniv.linux.org.uk, rusty@rustcorp.com.au
Subject: Re: [PATCH RESEND 2/2] Fix some kallsyms_lookup() vs rmmod races
Message-ID: <20070316161853.GD9413@elte.hu>
References: <20070316114458.GB6817@localhost.sw.ru> <20070316115154.GC30195@elte.hu> <45FAC2CA.80009@grupopie.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45FAC2CA.80009@grupopie.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Paulo Marques <pmarques@grupopie.com> wrote:

> >looking at the problem from another angle: wouldnt this be something 
> >that would benefit from freeze_processes()/unfreeze_processes(), and 
> >hence no locking would be required?
> 
> I also considered this, but it seemed a little too "blunt" to stop 
> everything (including completely unrelated processes and kernel 
> threads) just to remove a module.

'just to remove a module' is very, very rare, on the timescale of most 
kernel ops. Almost no distro does it. Furthermore, because we want to do 
CPU-hotplug that way, we really want to make 
freeze_processes()/unfreeze_processes() 'instantaneous' to the human - 
and it is that already. (if it isnt in some case we can make it so)

	Ingo
