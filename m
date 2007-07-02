Return-Path: <linux-kernel-owner+w=401wt.eu-S1756867AbXGBMUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867AbXGBMUJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 08:20:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753133AbXGBMT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 08:19:58 -0400
Received: from quark.didntduck.org ([69.55.226.66]:45594 "EHLO
	quark.didntduck.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822AbXGBMT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 08:19:58 -0400
X-Greylist: delayed 2675 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Jul 2007 08:19:58 EDT
Message-ID: <4688E2BC.9060908@didntduck.org>
Date: Mon, 02 Jul 2007 07:34:20 -0400
From: Brian Gerst <bgerst@didntduck.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
CC: Andreas Schwab <schwab@suse.de>, Jeremy Fitzhardinge <jeremy@goop.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [i386] Questions regarding provisional page tables initialization
References: <20070701203833.GA3498@Ahmed> <46882872.7040005@goop.org> <20070702011332.GA3503@Ahmed> <je8x9zrwof.fsf@sykes.suse.de> <20070702102303.GA17533@Ahmed>
In-Reply-To: <20070702102303.GA17533@Ahmed>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ahmed S. Darwish wrote:
> now back to head.S code:
>  	leal    0x007(%edi),%ecx	/* Create PDE entry */
> 
> Isn't the above line the same condition (bytes, not bits displacement) ?. 
> Thanks for your patience !.

The leal instruction (Load Effective Address) is often used as a way to
add a constant to one register and store the result in another register
in a single instruction.  The values don't even have to be addresses at
all, since no memory is actually referenced.  Otherwise this would be
written as:

	movl %edi,%ecx
	addl $0x007, %ecx

--
				Brian Gerst
