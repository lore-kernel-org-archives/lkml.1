Return-Path: <linux-kernel-owner+w=401wt.eu-S1754252AbZBQK2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252AbZBQK2b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 05:28:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbZBQK2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 05:28:04 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:28671 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753744AbZBQK2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 05:28:03 -0500
X-BigFish: VPS-36(zz1432R98dR936eQ1805M936fMzzzzz32i6bh43j)
X-FB-SS: 13,
X-WSS-ID: 0KF7H2G-01-UBE-01
Date: Tue, 17 Feb 2009 11:27:37 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Jaswinder Singh Rajput <jaswinder@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yinghai@kernel.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 4/7] x86: memtest: adapt log messages
Message-ID: <20090217102737.GC6298@alberich.amd.com>
References: <20090213144600.GA6298@alberich.amd.com> <20090213145517.GD13000@alberich.amd.com> <20090213165302.GA24299@elte.hu> <1234544696.26783.2.camel@localhost.localdomain> <4995B1E7.4070908@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4995B1E7.4070908@zytor.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 17 Feb 2009 10:27:53.0723 (UTC) FILETIME=[645B6CB0:01C990EA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 13, 2009 at 09:46:15AM -0800, H. Peter Anvin wrote:
> Jaswinder Singh Rajput wrote:
> > On Fri, 2009-02-13 at 17:53 +0100, Ingo Molnar wrote:
> >> * Andreas Herrmann <andreas.herrmann3@amd.com> wrote:
> >>
> >>> +#ifdef CONFIG_X86_64
> >>> +			printk(KERN_CONT "\n  %010llx - %010llx pattern %016llx",
> >>> +			       t_start, t_start + t_size, cpu_to_be64(pattern));
> >>> +#else
> >>> +			printk(KERN_CONT "\n  %010llx - %010llx pattern %08x",
> >>> +			       t_start, t_start + t_size, cpu_to_be32(pattern));
> >>> +#endif
> >> hm, is there really no cleaner way to do this?
> > 
> > Can we use this:
> > 
> > +			printk(KERN_CONT "\n  %010llx - %010llx pattern %016llx",
> > +			       t_start, t_start + t_size, cpu_to_be64(pattern));
> > 
> 
> Only if you don't mind 8 extra zeros on 32 bits.
> 
> There are other problems with this, too.  There is a KERN_CONT at the
> end of it, but it starts a new line, and then doesn't have another
> priority flag.

Ok, I see. I'll replace KERN_CONT with an appropriate priority flag
and move the newline to the end of the format string.


Regards,

Andreas


