Return-Path: <linux-kernel-owner+w=401wt.eu-S1754185AbYIEUP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185AbYIEUP6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 16:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751608AbYIEUPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 16:15:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39648 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbYIEUPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 16:15:49 -0400
Message-ID: <48C19296.6020201@zytor.com>
Date: Fri, 05 Sep 2008 13:12:06 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: linux@sandersweb.net, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi-suse@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG] x86 kenel won't boot under Virtual PC
References: <200808311422.12525.linux@sandersweb.net> <20080831122751.72afafb5@infradead.org> <alpine.LFD.1.10.0808311237290.12958@nehalem.linux-foundation.org> <200809051138.20615.linux@sandersweb.net> <48C17754.76E4.0078.0@novell.com>
In-Reply-To: <48C17754.76E4.0078.0@novell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
> 
> I disagree here: If I configure a 686+ kernel, I expect these NOPs to be
> that way (and to work). If you want to run on something that's not
> compliant, you just shouldn't configure your kernel that way.
> 

Okay, we do not generate P6 NOPs statically if CONFIG_X86_GENERIC_CPU is 
enabled -- unless, of course gcc/binutils generates them, which they now 
do for certain CPU types.  If you are selecting a specific CPU *and* you 
don't select GENERIC, you should get valid code for the selected CPU only.

As far as using them dynamically, there is code in -tip that determines 
dynamically and explicitly if the long NOPs are available, and only uses 
them if they are.

	-hpa
