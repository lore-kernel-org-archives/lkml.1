Return-Path: <linux-kernel-owner+w=401wt.eu-S1759942AbYDKLKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759942AbYDKLKA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 07:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759233AbYDKLJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 07:09:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55938 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757382AbYDKLJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 07:09:52 -0400
Date: Fri, 11 Apr 2008 13:09:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: Jiri Kosina <jkosina@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andi Kleen <andi@firstfloor.org>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: BUG: using smp_processor_id() during suspend with 2.6.25-rc8
Message-ID: <20080411110939.GB9205@elte.hu>
References: <c4e36d110804070625n17eb44e1nbb5558f500f13438@mail.gmail.com> <Pine.LNX.4.64.0804080008420.3896@jikos.suse.cz> <20080407222352.GG16647@one.firstfloor.org> <200804080029.31102.rjw@sisk.pl> <Pine.LNX.4.64.0804080030500.3896@jikos.suse.cz> <20080410094554.GA10321@ucw.cz> <Pine.LNX.4.64.0804110122470.3896@jikos.suse.cz> <20080411104902.GA8734@elf.ucw.cz> <20080411105108.GA1844@elte.hu> <20080411105445.GB18770@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080411105445.GB18770@elf.ucw.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Pavel Machek <pavel@ucw.cz> wrote:

> (I just want to fix the underlying problem in suspend, too. I guess
> I'll just do something like

>  				if (drv->suspend) {
> +					BUG_ON(!in_interrupt());
>  					ret = drv->suspend(sysdev, state);

>  			pr_debug(" %s\n", kobject_name(&sysdev->kobj));
>  
> +			BUG_ON(!in_interrupt());
>  			__sysdev_resume(sysdev);

small note: please always use WARN_ON_ONCE() in such cases. That way 
people's boxes dont blow up and the problem will be debuggable if the 
box survives despite the error condition. (and thus it can be relayed to 
kerneloops.org - all major distros have the package included already and 
Fedora enables the client by default)

	Ingo
