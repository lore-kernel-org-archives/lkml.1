Return-Path: <linux-kernel-owner+w=401wt.eu-S1759561AbYB1KpF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759561AbYB1KpF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 05:45:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753492AbYB1Koz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 05:44:55 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59019 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754957AbYB1Koz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 05:44:55 -0500
Date: Thu, 28 Feb 2008 11:44:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Mark McLoughlin <markmc@redhat.com>,
       Alexander van Heukelum <heukelum@fastmail.fm>
Subject: Re: [PATCH 2/2] x86/xen: Disable DMI parsing in Xen kernel.
Message-ID: <20080228104434.GA8964@elte.hu>
References: <1204187174-27143-1-git-send-email-ijc@hellion.org.uk> <1204187174-27143-2-git-send-email-ijc@hellion.org.uk> <1204191082.5446.13.camel@zakaz.uk.xensource.com> <20080228094613.GC2987@elte.hu> <1204194923.5446.30.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204194923.5446.30.camel@zakaz.uk.xensource.com>
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


* Ian Campbell <ijc@hellion.org.uk> wrote:

> > > Looks like the only sane solution will be to mark regions between 
> > > 640K-1M reserved early on in boot.
> > 
> > and as luck has it, such a patch from Alexander van Heukelum has 
> > been put into x86.git#testing just yesterday.
> > 
> > So ... could you try x86.git#testing - does it work out of box? Is 
> > the reservation early enough to prevent pagetables be allocated in 
> > weird places?
> 
> That patch is 64 bit only and also I'm not sure what EBDA looks like 
> to a Xen domU (I expect it doesn't exist). I'll give it a go but I'm 
> not hopeful.

it was requested to be unified to 32 bit as well already - no patch yet. 
I'd gladly take a patch that does it - it fixing 32-bit Xen guests would 
be an added bonus. Perhaps this all should be done by injecting a very 
eary e820 filter instead of reserving it later on? 640k..1M being 
special is a deep PC legacy, i doubt we'll ever recover from it ;-)

	Ingo
