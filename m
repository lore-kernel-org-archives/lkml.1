Return-Path: <linux-kernel-owner+w=401wt.eu-S1754284AbYDUHvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284AbYDUHvG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 03:51:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751706AbYDUHuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 03:50:55 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:46141 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbYDUHuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 03:50:54 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Apr 2008 03:50:54 EDT
Date: Mon, 21 Apr 2008 01:44:12 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: Dmitry Baryshkov <dbaryshkov@gmail.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>,
       pHilipp Zabel <philipp.zabel@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       tony@atomide.com, David Brownell <david-b@pacbell.net>,
       hiroshi.DOYU@nokia.com
Subject: Re: [PATCH 0/5] Clocklib: generic clocks framework
In-Reply-To: <20080420082925.GA32739@doriath.ww600.siemens.net>
Message-ID: <alpine.DEB.1.00.0804210057000.17857@utopia.booyaka.com>
References: <20080420082925.GA32739@doriath.ww600.siemens.net>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dmitry,

By way of introduction, I've been working on the Linux-OMAP clock tree 
over the past several months.  I recently had the opportunity to take a 
brief look at these clocklib patches that you're posting, and had a few 
thoughts:

- I understand from the discussions in this thread that the usage of your 
  clocklib code will be optional. However, the way you implement various 
  parts of the clock interface may effectively become mandatory, and 
  clocklib may not be able to handle many of the platform-specific clock 
  details that are necessary with more complex clock layouts like OMAP.  
  Would you consider the main goal of your clocklib code to be simply the 
  removal of several of the simpler ARM clock tree implementations?  Or is 
  your intention for it to ultimately replace all of the current Linux 
  clock implementations?  If the latter, your patchset will presumably 
  need a higher standard of review, since once it is integrated, any 
  changes will affect several architectures, rather than simply one.

- As others have mentioned earlier on this thread, it seems difficult to 
  construct a good "one-size-fits-all" struct clk.  At the very least, 
  I would also suggest adding a 'void *' to allow storage of clock-specific 
  data.

- Hiroshi DOYU has proposed an alternate debugfs implementation for the
  Linux-OMAP clock tree.  I prefer it to yours, as it implements each 
  clock as a separate dentry, which makes it easy to implement additional 
  debugging functions, such as set_rate/set_parent/round_rate debugging.  
  Perhaps you'd consider it, or something similar to it, instead?  It is 
  proposed here:
     http://www.mail-archive.com/linux-omap@vger.kernel.org/msg00751.html

- I don't think that I understand the clk_functions part of your code.  
  Is this a shorthand to construct aliases to other struct clks?


regards,

- Paul
