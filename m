Return-Path: <linux-kernel-owner+w=401wt.eu-S939019AbXFHLBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939019AbXFHLBW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 07:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937992AbXFHLBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 07:01:16 -0400
Received: from canuck.infradead.org ([209.217.80.40]:42673 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937981AbXFHLBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 07:01:15 -0400
Subject: Re: [SERIAL] Don't optimise away baud rate changes when BOTHER is
	used
From: David Woodhouse <dwmw2@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, paulus@samba.org
In-Reply-To: <20070607235441.17dbd5cc@the-village.bc.nu>
References: <20070523172739.1d3a918c@the-village.bc.nu>
	 <1180012135.8303.89.camel@shinybook.infradead.org>
	 <20070524144109.7bd0f4d0@the-village.bc.nu>
	 <1180014338.8303.95.camel@shinybook.infradead.org>
	 <20070524160559.54c2c639@the-village.bc.nu>
	 <1181133010.4096.26.camel@pmac.infradead.org>
	 <20070606160310.27d6d3b8@the-village.bc.nu>
	 <1181150998.2785.13.camel@pmac.infradead.org>
	 <20070607163808.19984208@the-village.bc.nu>
	 <1181231421.2785.68.camel@pmac.infradead.org>
	 <20070607225528.0d5e7b29@the-village.bc.nu>
	 <1181254517.20322.6.camel@shinybook.infradead.org>
	 <20070607235441.17dbd5cc@the-village.bc.nu>
Content-Type: text/plain
Date: Fri, 08 Jun 2007 12:01:07 +0100
Message-Id: <1181300467.2801.20.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-17.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-07 at 23:54 +0100, Alan Cox wrote:
> If it doesn't only involve editing the header files for this case (and
> maybe needing a define to indicate old==new) then the tty layer wants
> fixing to sort that out. Its on my todo list. 

It works fine. The only problem is that if I set a _standard_ baud rate
with BOTHER and then read it back with something that doesn't grok
BOTHER, I get it back just as I set it.

[root@pegasos ~]# ./testit1 
Get: c_flag 0x1f0b1f(31,31), ispeed 38400, ospeed 38400
[root@pegasos ~]# stty
speed 0 baud; line = 0;

It might be better if it was returning B38400, rather than BOTHER.
Should we be using tty_termios_encode_baud_rate() for TCGETS()?

-- 
dwmw2

