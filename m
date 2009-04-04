Return-Path: <linux-kernel-owner+w=401wt.eu-S937218AbZDDBT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937218AbZDDBT2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 21:19:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759797AbZDDBTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 21:19:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55679 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759660AbZDDBTP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 21:19:15 -0400
Date: Sat, 4 Apr 2009 03:18:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: make mtrr code could use debugpat
Message-ID: <20090404011805.GA19492@elte.hu>
References: <alpine.LFD.2.00.0903291553210.3948@localhost.localdomain> <1238434120.4529.783.camel@localhost.localdomain> <20090403175555.GH6295@elte.hu> <alpine.LFD.2.00.0904031203400.4015@localhost.localdomain> <20090403212152.GA3493@linux-os.sc.intel.com> <alpine.LFD.2.00.0904031443340.7007@localhost.localdomain> <alpine.LFD.2.00.0904031521460.3915@localhost.localdomain> <20090403222928.GA6446@elte.hu> <49D68F4B.9010808@kernel.org> <alpine.LFD.2.00.0904031737030.3915@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904031737030.3915@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.1 required=5.9 tests=BAYES_00,URG_BIZ autolearn=no SpamAssassin version=3.2.5
	1.6 URG_BIZ                BODY: Contains urgent matter
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, 3 Apr 2009, Yinghai Lu wrote:
> > 
> > only print out get_mtrr when debugpat
> 
> Is that get_mtrr message really so interesting that it needs to be 
> printed out at all? Even with debugpat?

With debugpat it's probably interesting - i think only a very small 
fraction of users will enable it, and if they do we really want to 
track all MTRR state.

Since old MTRR state gets destroyed by new settings we better have a 
clear idea how the BIOS set it, that might give us clues about 
quirks, etc.

Based on MTRR bugreport patterns i was the one who asked Yinghai 
during the development cycle to add more debugging there - so i'm to 
blame for those printouts. We had several cases where it would have 
been useful had we known the precise history of MTRR settings.

I was under the impression that KERN_DEBUG would only show up on the 
console if 'debug' is passed in on the boot command line - but your 
bootlog didnt have 'debug' in it and i guess having it so frequently 
in the dmesg is confusing as well. It might even be there for every 
Xorg startup.

Anyway ... the x86/urgent pull request i sent removes the printk 
altogether.

	Ingo
