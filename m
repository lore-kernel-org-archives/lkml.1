Return-Path: <linux-kernel-owner+w=401wt.eu-S1754919AbXG1Q0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919AbXG1Q0S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 12:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752802AbXG1Q0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 12:26:09 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34297 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752801AbXG1Q0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 12:26:08 -0400
Date: Sat, 28 Jul 2007 09:25:30 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Len Brown <lenb@kernel.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, david@lang.hm,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
Subject: Re: CONFIG_SUSPEND? (was: Re: [GIT PATCH] ACPI patches for
 2.6.23-rc1)
In-Reply-To: <200707280330.26991.lenb@kernel.org>
Message-ID: <alpine.LFD.0.999.0707280921150.3442@woody.linux-foundation.org>
References: <200707251238.50218.lenb@kernel.org> <200707262248.09187.rjw@sisk.pl>
 <alpine.LFD.0.999.0707261351430.3442@woody.linux-foundation.org>
 <200707280330.26991.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 28 Jul 2007, Len Brown wrote:
> 
> That three-liner will crash ACPI+SMP-HOTPLUG_CPU kernels on resume.

Explain that to me.

There should *be* no resume.

ACPI doesn't suspend/resume on its own, I hope.

It is all done by the top-level suspend/resume code, not by ACPI. ACPI is 
a pure helper, and if you've changed that, then I think we need to revert 
more than a few lines.

And it's the *top*level* code that selects HOTPLUG_CPU. Through 
SUSPEND_SMP (which will select HOTPLUG_CPU) and SOFTWARE_SUSPEND.

This is why it's so *totally* and *utterly* bogus for ACPI to select 
features that it has nothign what-so-ever to do with. 

In other words: ACPI isn't in the driving seat. 

			Linus
