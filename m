Return-Path: <linux-kernel-owner+w=401wt.eu-S1752456AbZHSOll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456AbZHSOll (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 10:41:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbZHSOll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 10:41:41 -0400
Received: from www.tglx.de ([62.245.132.106]:39854 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828AbZHSOlk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 10:41:40 -0400
Date: Wed, 19 Aug 2009 16:40:38 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v2 2/10] x86/boot: add setup_secondary_clock to x86
 quirk
In-Reply-To: <43F901BD926A4E43B106BF17856F0755643EBDF4@orsmsx508.amr.corp.intel.com>
Message-ID: <alpine.LFD.2.00.0908191027520.3361@localhost.localdomain>
References: <43F901BD926A4E43B106BF17856F0755643EBDF4@orsmsx508.amr.corp.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jacob,

On Thu, 16 Jul 2009, Pan, Jacob jun wrote:

> >From 8d2ba963b3f352ee478fda838422425aaed0a97a Mon Sep 17 00:00:00 2001
> From: Jacob Pan <jacob.jun.pan@intel.com>
> Date: Tue, 9 Jun 2009 17:02:48 -0700
> Subject: [PATCH] x86/boot: add setup_secondary_clock to x86 quirk
> 
> Some x86 platform such as Intel Moorestown use external timers for per
> cpu clockevent devices. This quirk is added such as we can override the
> default local APIC timers if such platform is detected.
> 
> Should not have impact on other platforms that uses default or platform
> specific x86_quirks.

That patch is only half of the story. What about the apic timer setup
of the primary CPU ?

Also we already have paravirt ops overriding the clock setup for boot
and secondary cpus. Your patch adds another level of indirection.
That's just a nightmare.

The correct approach is to clean up the clock setup in general and get
rid of the paravirt indirection. There is no reason why paravirt
guests should not use the same infrastructure as we need for platform
support.

I need to think more about how it should look, but we definitely want
something which is of general use and does not just add extra
conditinal stuff.

Thanks,

	tglx
