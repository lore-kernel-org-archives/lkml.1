Return-Path: <linux-kernel-owner+w=401wt.eu-S1761387AbZFKJrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761387AbZFKJrU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 05:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755590AbZFKJrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 05:47:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40985 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755458AbZFKJrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 05:47:12 -0400
Date: Thu, 11 Jun 2009 11:47:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH for tip/mce3] x86, mce: Add options for corrected errors
Message-ID: <20090611094706.GB12703@elte.hu>
References: <4A30ACDF.5030408@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A30ACDF.5030408@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> wrote:

> [ Repost, rebased on tip/x86/mce3]
> 
> This patch introduces three boot options (no_cmci, dont_log_ce and 
> ignore_ce) to control handling for corrected errors.
> 
> The "mce=no_cmci" boot option disables cmci feature. Since cmci is 
> a new feature so having boot controls to disable it will be a help 
> if the hardware is misbehaving.
> 
> The "mce=dont_log_ce" boot option disables logging for corrected 
> errors.  All reported corrected errors will be cleared silently. 
> This option will be useful if you never care corrected errors.
> 
> The "mce=ignore_ce" boot option disables features for corrected 
> errors, i.e. polling timer and cmci.  All corrected events are not 
> cleared and kept in bank MSRs.  Usually this disablement is not 
> recommended, however it will be a help if there are some conflict 
> with the BIOS or hardware monitoring applications etc., that 
> clears corrected events in banks instead of OS.

Applied to tip:x86/mce3, thanks Hidetoshi!

A few sidenote:

Please introduce a sysctl for these too, for those were the flag can 
be safely toggled after bootup (most of them look to be such flags). 
Admins might want to tweak these options without rebooting the 
system.

Even for those flags where a toggle means having to touch MSRs to 
deactivate/(reactivate) CMCI we should do the sysctl thing, as 
no-reboot configurability is king in this space.

a few random details:

>  static int			mce_bootlog = -1;
>  static int			monarch_timeout = -1;
>  static int			mce_panic_timeout;
> +static int			mce_dont_log_ce;
> +int				mce_cmci_disabled;
> +int				mce_ignore_ce;
>  int				mce_ser;

All rarely-modified variables should be declared __read_mostly.

>  static char			trigger[128];

Undocumented magic constant and meaninglessly named global variable, 
please clean this up.

	Ingo
