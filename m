Return-Path: <linux-kernel-owner+w=401wt.eu-S933630AbXCZGpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933630AbXCZGpX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 02:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933632AbXCZGpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 02:45:23 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:12423 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933630AbXCZGpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 02:45:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=dwrRO+0zp6+lpT40J2TdXE0YXwdxF2Ujxo2JF3t7csvSUNlpcaU05lgwRdB61371D7vf2ZuOs/T2sOtDqzc5jO5P9FroNOB3SZT+p6CAg48bSfgwpFHEw+8yqJszzcdDzY/50CiAdQkjF1KRV05yR/4toQqhUy729JsI4VsuFGg=
Subject: Re: [3/5] 2.6.21-rc4: known regressions (v2)
From: =?ISO-8859-1?Q?Fr=E9d=E9ric?= RISS <frederic.riss@gmail.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, pavel@suse.cz,
       Tino Keitel <tino.keitel@gmx.de>, Bob Moore <robert.moore@intel.com>,
       lenb@kernel.org, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1174858456.5550.32.camel@funkylaptop>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	 <20070323185022.GQ752@stusta.de>  <1174858456.5550.32.camel@funkylaptop>
Content-Type: text/plain; charset=utf-8
Date: Mon, 26 Mar 2007 08:45:19 +0200
Message-Id: <1174891519.5550.36.camel@funkylaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 25 mars 2007 à 23:34 +0200, Frédéric Riss a écrit :
> However, as I pointed out in the initial report, the MacMini doesn't
> come out of suspend to ram because a commit in another merged patchset
> broke it. I tracked it down to:
> 
> commit e9e2cdb412412326c4827fc78ba27f410d837e6e
> parent 79bf2bb335b85db25d27421c798595a2fa2a0e82 
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Fri Feb 16 01:28:04 2007 -0800
> 
>     [PATCH] clockevents: i386 drivers
>     
> This patch has already been mentioned in regression reports, but AFAICS
> not related to suspend issues.
> 
> To be totally clear about what works and what doesn't:
> 
> 79bf2bb335b85db25d27421c798595a2fa2a0e82 
>    + cherry-pick f3ccb06f3b8e0cf42b579db21f3ca7f17fcc3f38  ==> works
> 
> e9e2cdb412412326c4827fc78ba27f410d837e6e
>    + cherry-pick f3ccb06f3b8e0cf42b579db21f3ca7f17fcc3f38  ==> broken
> 
> To try to get more information, I commented the call to
> do_suspend_lowlevel in drivers/acpi/sleep/main.c and used
> CONFIG_DISABLE_CONSOLE_SUSPEND. Interestingly, the suspend/resume cycle
> completes correctly in this mode.

Additional data point: I just tried with -rc5 and the issue is still
present. The config I used for this test defines neither NO_HZ nor
HIGH_RES_TIMERS.

Fred.

