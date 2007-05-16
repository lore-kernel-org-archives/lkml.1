Return-Path: <linux-kernel-owner+w=401wt.eu-S934110AbXEPXct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934110AbXEPXct (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 19:32:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757629AbXEPXck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 19:32:40 -0400
Received: from de01egw01.freescale.net ([192.88.165.102]:44180 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756728AbXEPXcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 19:32:39 -0400
Message-ID: <464B9427.1010204@freescale.com>
Date: Wed, 16 May 2007 18:30:47 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.2pre) Gecko/20070111 SeaMonkey/1.1
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Al Viro <viro@ftp.linux.org.uk>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, zippel@linux-m68k.org,
       kbuild-devel@lists.sourceforge.net
Subject: Re: [RFC] select and dependencies in Kconfig
References: <E1Ho2om-0003TN-Ah@ZenIV.linux.org.uk> <20070516033335.GH4095@ftp.linux.org.uk> <464B141E.3020400@s5r6.in-berlin.de>
In-Reply-To: <464B141E.3020400@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:

> "A... select B" is just a flavor of "A... depends on B", with the
> additional instruction to the Kconfig UIs:  Don't hide A if you can
> silently switch on B.

I think you mean "A... select B" is just a flavor of "B... depends on A".  There is one 
minor difference between the two.

If A is a driver and B is a library, then it's more intuitive to update the Kconfig option 
for A then it is to update the Kconfig option for B.  For example, if I want to add a new 
driver C that uses library B, I can just add this:

C
	select B

If I have to use "depends on", then I would have to change the Kconfig option for B like this:

B
	depends on A || C

And every time I create a new driver that depends on library B, I have to update that 
"depends on" line *in addition to* creating the Kconfig line for the new driver.  If 10 
drivers use library B, you'll have this:

B
	depends on A || C || D || E || F || G || H || I || J || K

> How about throwing "select" out of the Kconfig language and improving
> the UIs instead, so that users find what they want and need?

I know a lot of people don't like 'select', but I prefer it over 'depends on'.

-- 
Timur Tabi
Linux Kernel Developer @ Freescale
