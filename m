Return-Path: <linux-kernel-owner+w=401wt.eu-S1756070AbYJPKcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070AbYJPKcP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 06:32:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753342AbYJPKcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 06:32:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35099 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbYJPKb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 06:31:59 -0400
Message-ID: <48F717F6.10804@zytor.com>
Date: Thu, 16 Oct 2008 03:31:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jiri Slaby <jirislaby@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, "David S. Miller" <davem@davemloft.net>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: GIT head no longer boots on x86-64
References: <alpine.LFD.2.00.0810130752020.3288@nehalem.linux-foundation.org> <1223910693-28693-1-git-send-email-jirislaby@gmail.com> <20081013164717.7a21084a@lxorguk.ukuu.org.uk> <20081015115153.GA16413@elte.hu> <alpine.LFD.2.00.0810150758310.3288@nehalem.linux-foundation.org> <alpine.LFD.2.00.0810150815000.3288@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0810150815000.3288@nehalem.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> Oh, btw. This patch is *totally* untested. I don't even enable modules. So 
> if it doesn't compile, it isn't perfect. But while it may not _work_, at 
> least it's not _ugly_.
> 
> (Quite frankly, I think an even more correct fix is to rename the whole 
> "vmalloc_to_page()" function, since it's clearly used for other things 
> than vmalloc. Maybe "kernel_virtual_to_page()". Whatever. This is trying 
> to be minimal without being totally disgusting).
> 

I have verified that this patch fixes the problem, at least in my test 
rig, and has queued it up for tip:x86/urgent.  It should be in the next 
pull request.

Note that this bug only bites when CONFIG_DEBUG_VIRTUAL=y and we're 
running an SMP kernel on UP.  Not that that is any excuse.

	-hpa
