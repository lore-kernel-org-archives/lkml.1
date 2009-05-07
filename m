Return-Path: <linux-kernel-owner+w=401wt.eu-S1760889AbZEGVHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760889AbZEGVHb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 17:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751837AbZEGVHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 17:07:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43638 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbZEGVHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 17:07:21 -0400
Message-ID: <4A034C13.8070402@zytor.com>
Date: Thu, 07 May 2009 14:01:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Christoph Lameter <cl@linux.com>, Alok Kataria <akataria@vmware.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] x86: Reduce the default HZ value
References: <1241462661.412.8.camel@alok-dev1>  <4A00ADDE.9000908@zytor.com>	 <1241560625.8665.17.camel@alok-dev1>	 <alpine.DEB.1.10.0905071010170.24528@qirst.com>	 <1241716053.6311.1514.camel@laptop>	 <alpine.DEB.1.10.0905071318570.22107@qirst.com> <1241718302.6311.1573.camel@laptop>
In-Reply-To: <1241718302.6311.1573.camel@laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> 
> The problem with scheduling a hrtimer along with tasks is that at high
> context switch rates the timer will never fire but you do pay the
> overhead of programming the hardware each time, something that can be
> about as expensive as the whole context switch itself.
> 
> Although, I guess we could amortize that by not re-programming the timer
> when the existing timer is within a reasonable period (say 1ms) of the
> requested on.
> 

That seems like a reasonable optimization since we're talking about 
multi-kHz context switch rates, here.

	-hpa

