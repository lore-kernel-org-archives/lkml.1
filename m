Return-Path: <linux-kernel-owner+w=401wt.eu-S1757408AbYCGIZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757408AbYCGIZS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 03:25:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752281AbYCGIY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 03:24:59 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53811 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042AbYCGIY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 03:24:58 -0500
Date: Fri, 7 Mar 2008 09:24:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: Miguel Boton <mboton.lkml@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: mach_reboot_fixups()
Message-ID: <20080307082441.GA12150@elte.hu>
References: <47D031CD.76E4.0078.0@novell.com> <20080306174311.GA23029@elte.hu> <47D103D0.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47D103D0.76E4.0078.0@novell.com>
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


* Jan Beulich <jbeulich@novell.com> wrote:

> Not exactly - when rebooting through EFI or BIOS, the old code didn't 
> go through mach_reboot_fixups(), and I think that is the correct 
> behavior (albeit, when the EFI path fell back to the triple fault 
> mechanism, it should have honored the fixup logic, and I think it is 
> more correct that the new code tries the keyboard method first). 
> Perhaps the most reasonable way to go is to honor all reboot= settings 
> without using the override code first:

>  		case BOOT_KBD:
> +			mach_reboot_fixups(); /* for board specific fixups */

ok, agreed.

> (with the exception that reboot=keyboard will still have the effect of 
> honoring the fixups, but I think this is better than further 
> complicating the logic).

the fixups are really "emergency exceptions" - for (a very low number 
of) broken boards that just cannot reboot via the default BOOT_KBD 
method. In that sense it's a small detail how widely we apply the 
exceptions - those boards probably wont be rebooted via reboot=bios 
[people only use reboot options when they have trouble rebooting].

> In case you want to take this,
> Signed-off-by: Jan Beulich <jbeulich@novell.com>

i modified the patch and added your signoff - thanks,

	Ingo
