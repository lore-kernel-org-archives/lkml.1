Return-Path: <linux-kernel-owner+w=401wt.eu-S1758630AbZFIRzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758630AbZFIRzm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 13:55:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754907AbZFIRzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 13:55:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60047 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754535AbZFIRzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 13:55:35 -0400
Message-ID: <4A2E82BA.7040905@zytor.com>
Date: Tue, 09 Jun 2009 08:41:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Petr Tesarik <ptesarik@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] x86: clean up vdso-layout.lds.S
References: <1243865115.24278.8.camel@nathan.suse.cz>	<1244215559.1604.12.camel@nathan.suse.cz>	<20090605200701.GB23195@uranus.ravnborg.org>	<1244532418.5199.24.camel@nathan.suse.cz> <20090609075247.DA95CFC3B2@magilla.sf.frob.com>
In-Reply-To: <20090609075247.DA95CFC3B2@magilla.sf.frob.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath wrote:
> 
> You mean this one:
> 
> 	/*
> 	 * Align the actual code well away from the non-instruction data.
> 	 * This is the best thing for the I-cache.
> 	 */
> 	. = ALIGN(0x100);
> 
> Reading the comment might make it obvious that it's intended for optimal
> code alignment.  I suspect someone at the time told me 256 is as big as an
> I-cache line was ever likely to get.  You could use L1_CACHE_BYTES instead
> I suppose.
> 

Most likely 256 was chosen as a compromise between the the
then-documented value for coherency avoidance (128), future-proofing,
and waste.

I don't think we want to use different values on different platforms,
and end up with dramatically different vdsos when they still need to fit
in the same size envelope.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

