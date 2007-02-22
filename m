Return-Path: <linux-kernel-owner+w=401wt.eu-S1751379AbXBVF6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751379AbXBVF6b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 00:58:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751389AbXBVF6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 00:58:31 -0500
Received: from terminus.zytor.com ([192.83.249.54]:60691 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbXBVF6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 00:58:31 -0500
Message-ID: <45DD30DE.20503@zytor.com>
Date: Wed, 21 Feb 2007 21:57:50 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Jose Goncalves <jose.goncalves@inov.pt>,
       Frederik Deweerdt <deweerdt@free.fr>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: Serial related oops
References: <20070219134539.GA27370@flint.arm.linux.org.uk> <20070220142442.GF566@slug> <20070219143520.GB27370@flint.arm.linux.org.uk> <20070220144814.GJ566@slug> <20070219150508.GD27370@flint.arm.linux.org.uk> <45D9D073.7020701@inov.pt> <20070219164200.GF27370@flint.arm.linux.org.uk> <45D9E46C.4030408@inov.pt> <20070219212347.GA4258@flint.arm.linux.org.uk> <45DC537B.6020108@inov.pt> <20070221230503.GA28156@flint.arm.linux.org.uk>
In-Reply-To: <20070221230503.GA28156@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King wrote:

> 
> Plainly, %ebx changed across the call to serial_in() at c01c0f7b.
> First thing to notice is this violates the C code - "up" can not
> change.
> 
> Now let's look at serial_in:
> 
> c01bfa70:       55                      push   %ebp
> c01bfa71:       89 e5                   mov    %esp,%ebp
> c01bfa73:       53                      push   %ebx
> ...
> c01bfab7:       5b                      pop    %ebx
> c01bfab8:       5d                      pop    %ebp
> c01bfab9:       c3                      ret
> 
> This code tells the CPU to preserves %ebx and %ebp.  But we know %ebx
> _wasn't_ preserved.  Ergo, your CPU is plainly not doing what the code
> told it to do.
> 

... assuming nothing else clobbered the stack slot (which would be a 
compiler error, or a wild pointer.)

Got a disassembly of the whole function?

	-hpa
