Return-Path: <linux-kernel-owner+w=401wt.eu-S1752921AbZBQKYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921AbZBQKYs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 05:24:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751805AbZBQKYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 05:24:39 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:6707 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbZBQKYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 05:24:38 -0500
X-BigFish: VPS-22(z34a4jz1432R98dR1805M936fM4cd6kzzzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KF7GWN-02-0OM-01
Date: Tue, 17 Feb 2009 11:24:07 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] x86: memtest: introduce array to store memtest
	patterns
Message-ID: <20090217102407.GB6298@alberich.amd.com>
References: <20090213144600.GA6298@alberich.amd.com> <20090213145124.GB13000@alberich.amd.com> <4995B35F.5080708@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4995B35F.5080708@zytor.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 17 Feb 2009 10:24:23.0437 (UTC) FILETIME=[E70453D0:01C990E9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 13, 2009 at 09:52:31AM -0800, H. Peter Anvin wrote:
> Andreas Herrmann wrote:
> > -#define _MAX_MEM_PATTERNS 4
> > +static unsigned long patterns[] = {
> > +	0UL,
> > +	-1UL,
> > +#ifdef CONFIG_X86_64
> > +	0x5555555555555555UL,
> > +	0xaaaaaaaaaaaaaaaaUL,
> > +#else
> > +	0x55555555UL,
> > +	0xaaaaaaaaUL,
> > +#endif
> > +};
> 
> Why not just use u64 for the pattern even on 32 bits?

I just assumed that this was a settled thing.

Yinghai, was there a specific reason why you did not use an u64 for
the memory test pattern on 32-bit?
(See commit 1f067167a83d1c7f80437fd1d32b55508aaca009 "x86: seperate
memtest from init_64.c")

If not I'll adapt this and send out a new patch set.


Regards,

Andreas


