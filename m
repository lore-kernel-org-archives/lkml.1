Return-Path: <linux-kernel-owner+w=401wt.eu-S1760970AbYBKWJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760970AbYBKWJj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 17:09:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758221AbYBKWJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 17:09:20 -0500
Received: from www.tglx.de ([62.245.132.106]:33347 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757714AbYBKWJR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 17:09:17 -0500
Date: Mon, 11 Feb 2008 23:08:57 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@suse.de>
cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/5] Only do century BCD conversion when we know the
 RTC is BCD
In-Reply-To: <200802110956.16004.ak@suse.de>
Message-ID: <alpine.LFD.1.00.0802112246590.12988@apollo.tec.linutronix.de>
References: <20080209416.271135970@suse.de> <alpine.LFD.1.00.0802110924050.12988@apollo.tec.linutronix.de> <200802110956.16004.ak@suse.de>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Feb 2008, Andi Kleen wrote:
> > Nothing ever defines RTC_PORT and RTC_ALWAYS_BCD
> >
> > So we can get rid of that stuff completely.
> 
> Please see the second version of the patch series. This means I didn't drop it 

I'm already replying to the second version of the patch series AFAICT.

> completely, but added a warning about it not agreeing with the status 
> register. If this warning never triggers it can be dropped eventually,
> if it triggers RTC_ALWAYS_BCD should be unset.

#define RTC_ALWAYS_BCD 1 is there since Linux 1.0 and got never
changed for x86.

So the warning comes a bit late :)

Later on the #ifdef RTC_PORT was introduced to share the header in
include/linux across architectures. When the header got copied to
include/i386 and elsewhere this just was never removed.

Thanks,

	tglx
