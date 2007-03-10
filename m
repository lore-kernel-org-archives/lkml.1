Return-Path: <linux-kernel-owner+w=401wt.eu-S2993182AbXCJFrI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993182AbXCJFrI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 00:47:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993177AbXCJFrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 00:47:08 -0500
Received: from smtp.osdl.org ([65.172.181.24]:33404 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993174AbXCJFrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 00:47:05 -0500
Date: Fri, 9 Mar 2007 21:41:20 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sergio Monteiro Basto <sergio@sergiomb.no-ip.org>
cc: =?ISO-8859-1?Q?Mathieu_B=E9rard?= <Mathieu.Berard@crans.org>,
       Jeff Garzik <jeff@garzik.org>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org,
       Michal Jaegermann <michal@ellpspace.math.ualberta.ca>,
       Fabio Comolli <fabio.comolli@gmail.com>, Tejun Heo <htejun@gmail.com>,
       Janosch Machowinski <jmachowinski@gmx.de>,
       Lukas Hejtmanek <xhejtman@fi.muni.cz>, Meelis Roos <mroos@linux.ee>,
       Olivier Mondoloni <darkcore71@yahoo.fr>,
       Thomas Renninger <trenn@suse.de>, Robert Moore <robert.moore@intel.com>,
       lenb@kernel.org, linux-acpi@vger.kernel.org
Subject: Re: and try remove another quirk on this computers Re: [3/6]
 2.6.21-rc2: known regressions
In-Reply-To: <1173499896.21891.34.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0703092134330.10832@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> 
 <20070305015036.GH3441@stusta.de> <45EE9E39.3010800@garzik.org> 
 <45F20541.9090208@crans.org> <1173499896.21891.34.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 10 Mar 2007, Sergio Monteiro Basto wrote:
> 
> With this quirk I got this oops on hibernate (but computer still
> working) 

Well, strictly speaking it's a warning, not an oops per se. 

What happens is that the quirk wants to do an "ioremap_nocache()", which 
allocates memory, and that happens very early during initialization when 
interrupts are disabled.

And you're really not supposed to allocate memory, except using 
GFP_ATOMIC. But we've always been lax about that during early boot, so we 
have stuff that does. And resume ends up doing a lot of the same things 
early boot does, and shows issues like this.

So the quirk is probably still a good idea, and the warning message is 
just that - a very scary warning message, but not an indicator that 
anything is seriously screwed up for you.

(It is an indication of a real bug, though, even though it's harmless in 
practice in this case)

		Linus
