Return-Path: <linux-kernel-owner+w=401wt.eu-S1755507AbZECJJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507AbZECJJh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 05:09:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754436AbZECJJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 05:09:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34418 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752910AbZECJJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 05:09:26 -0400
Date: Sun, 3 May 2009 11:09:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [git-pull -tip] x86: cpu_debug patches
Message-ID: <20090503090908.GA23183@elte.hu>
References: <1240190145.3106.90.camel@ht.satnam> <1240191359.3106.93.camel@ht.satnam> <1240217428.3083.2.camel@ht.satnam> <20090420111619.GE6670@elte.hu> <1240933437.3074.4.camel@ht.satnam> <20090428172828.GA15392@elte.hu> <1240977176.3028.0.camel@ht.satnam> <20090429105021.GG2373@elte.hu> <1241007294.3061.12.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241007294.3061.12.camel@ht.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> We can use cpu_has tests for unknown processors but 'cpu model' is 
> accurate and cover all range.
> 
> cpu_has does not cover following registers:
> 1. platform
> 2. poweron
> 3. control
> 4. bios
> 5. freq
> 6. cache
> 7. misc
> 8. base
> 9. ver
> 10. conf

Firstly these should be added to cpufeatures.h.

Then add cpu_has_xxx() accessors need to be added for them and 
during CPU init they have to be properly set, via two methods:

 - via CPUID (where this is possible+specified in docs)
 - or via "later than CPU version X" checks

Your cpu-model table is equivalent to an explicitly enumerated CPU 
version check, but this breaks every time a new CPU comes out. 

"Later than" or CPUID based feature bits are a lot more future-proof 
- we only have to add support for new _features_ (and quirks, 
occasionally), and dont have to maintain that full table of specific 
models to specific features mapping tables.

	Ingo
