Return-Path: <linux-kernel-owner+w=401wt.eu-S1757577AbYB1Jqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577AbYB1Jqr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 04:46:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754841AbYB1Jqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 04:46:36 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40223 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754160AbYB1Jqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 04:46:35 -0500
Date: Thu, 28 Feb 2008 10:46:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Mark McLoughlin <markmc@redhat.com>,
       Alexander van Heukelum <heukelum@fastmail.fm>
Subject: Re: [PATCH 2/2] x86/xen: Disable DMI parsing in Xen kernel.
Message-ID: <20080228094613.GC2987@elte.hu>
References: <1204187174-27143-1-git-send-email-ijc@hellion.org.uk> <1204187174-27143-2-git-send-email-ijc@hellion.org.uk> <1204191082.5446.13.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204191082.5446.13.camel@zakaz.uk.xensource.com>
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

> Actually scratch this patchset -- its not sufficient. For example 
> ddcprobe in userspace causes the exact same issue vs 0xa0000.
> 
> Looks like the only sane solution will be to mark regions between 
> 640K-1M reserved early on in boot.

and as luck has it, such a patch from Alexander van Heukelum has been 
put into x86.git#testing just yesterday.

So ... could you try x86.git#testing - does it work out of box? Is the 
reservation early enough to prevent pagetables be allocated in weird 
places? [or am i missing something - this is about the guest kernel 
reserving th 640k..1M area, not the host kernel - right?]

	Ingo
