Return-Path: <linux-kernel-owner+w=401wt.eu-S1754167AbZESL6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167AbZESL6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 07:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752305AbZESL6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 07:58:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:57136 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752020AbZESL6C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 07:58:02 -0400
Subject: Re: [git-pull -tip] x86: cpu_debug patches
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20090503090908.GA23183@elte.hu>
References: <1240190145.3106.90.camel@ht.satnam>
	 <1240191359.3106.93.camel@ht.satnam> <1240217428.3083.2.camel@ht.satnam>
	 <20090420111619.GE6670@elte.hu> <1240933437.3074.4.camel@ht.satnam>
	 <20090428172828.GA15392@elte.hu> <1240977176.3028.0.camel@ht.satnam>
	 <20090429105021.GG2373@elte.hu> <1241007294.3061.12.camel@ht.satnam>
	 <20090503090908.GA23183@elte.hu>
Content-Type: text/plain
Date: Tue, 19 May 2009 17:27:35 +0530
Message-Id: <1242734255.3377.20.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ingo,

On Sun, 2009-05-03 at 11:09 +0200, Ingo Molnar wrote:
> * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> 
> > We can use cpu_has tests for unknown processors but 'cpu model' is 
> > accurate and cover all range.
> > 
> > cpu_has does not cover following registers:
> > 1. platform
> > 2. poweron
> > 3. control
> > 4. bios
> > 5. freq
> > 6. cache
> > 7. misc
> > 8. base
> > 9. ver
> > 10. conf
> 
> Firstly these should be added to cpufeatures.h.
> 
> Then add cpu_has_xxx() accessors need to be added for them and 
> during CPU init they have to be properly set, via two methods:
> 
>  - via CPUID (where this is possible+specified in docs)
>  - or via "later than CPU version X" checks
> 
> Your cpu-model table is equivalent to an explicitly enumerated CPU 
> version check, but this breaks every time a new CPU comes out. 
> 
> "Later than" or CPUID based feature bits are a lot more future-proof 
> - we only have to add support for new _features_ (and quirks, 
> occasionally), and dont have to maintain that full table of specific 
> models to specific features mapping tables.
> 

It seems that other developers have some objections for adding new cpuid
features.

May be we can try accessing MSRs without any checking, it will work on
new processors but we need to check it on old processors, so I will need
your help to run this modules on old processors.

Now what should be the next step.

Thanks,
--
JSR

