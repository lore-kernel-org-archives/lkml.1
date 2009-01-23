Return-Path: <linux-kernel-owner+w=401wt.eu-S1760020AbZAWAIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760020AbZAWAIb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 19:08:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755985AbZAWAIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 19:08:23 -0500
Received: from gw.goop.org ([64.81.55.164]:43797 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753589AbZAWAIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 19:08:22 -0500
Message-ID: <49790A6F.1080000@goop.org>
Date: Thu, 22 Jan 2009 16:08:15 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Zachary Amsden <zach@vmware.com>, Nick Piggin <npiggin@suse.de>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "jeremy@xensource.com" <jeremy@xensource.com>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: lmbench lat_mmap slowdown with CONFIG_PARAVIRT
References: <20090120110542.GE19505@wotan.suse.de>	 <20090120112634.GA20858@elte.hu> <20090120140324.GA26424@elte.hu>	 <49763806.5090009@goop.org> <20090120205653.GA19710@elte.hu>	 <20090121072718.GN24891@wotan.suse.de>  <4977A051.8050203@goop.org>	 <1232663311.16317.176.camel@bodhitayantram.eng.vmware.com>	 <4978F6C6.3090003@goop.org>  <4978F7DC.1040503@zytor.com> <1232665120.16317.186.camel@bodhitayantram.eng.vmware.com> <497906A4.2030008@zytor.com>
In-Reply-To: <497906A4.2030008@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Right now a number of the call sites contain a huge push/pop sequence 
> followed by an indirect call.  We can patch in the native code to 
> avoid the branch overhead, but the register constraints and icache 
> footprint is unchanged.

That's true for the pvops hooks emitted in the .S files, but not so true 
for ones in C code (well, there are no explicit push/pops, but the 
presence of the call may cause the compiler to generate them).

The .S hooks can definitely be cleaned up, but I don't think that's 
germane to Nick's observations that the mm code is showing slowdowns.

    J
