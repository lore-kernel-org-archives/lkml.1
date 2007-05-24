Return-Path: <linux-kernel-owner+w=401wt.eu-S1751476AbXEXQpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476AbXEXQpZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 12:45:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750733AbXEXQpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 12:45:14 -0400
Received: from [216.16.235.2] ([216.16.235.2]:47359 "EHLO rubicon.netdirect.ca"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750724AbXEXQpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 12:45:13 -0400
X-Originating-Ip: 99.246.112.70
Date: Thu, 24 May 2007 12:43:07 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Satyam Sharma <satyam.sharma@gmail.com>
cc: Krzysztof Halasa <khc@pm.waw.pl>, Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: any value to "NORET_TYPE" macro?
In-Reply-To: <a781481a0705230646x9a0255ak4254d05ba5442cad@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0705241239560.10926@localhost.localdomain>
References: <Pine.LNX.4.64.0705220904320.13623@localhost.localdomain> 
 <20070522135927.GA2098@stusta.de>  <Pine.LNX.4.64.0705221002350.14457@localhost.localdomain>
  <20070522161951.GC2098@stusta.de> <m3ejl8k6e3.fsf@maximus.localdomain> 
 <Pine.LNX.4.64.0705221616270.18792@localhost.localdomain> 
 <m37ir0iodl.fsf@maximus.localdomain>  <a781481a0705230137v4c8ba82fx263212a2958b55b9@mail.gmail.com>
  <Pine.LNX.4.64.0705230908180.4309@localhost.localdomain>
 <a781481a0705230646x9a0255ak4254d05ba5442cad@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2007, Satyam Sharma wrote:

> Actually there's another thing :-) The __attribute__((xxx)) must go
> with the function _declarations_ (and not the
> implementations/definitions).

that's not true, AFAICT.  the pattern seems to be that, in the case of
declarations, attributes go at the end, as in:

arch/sparc/boot/btfixupprep.c:void fatal(void) __attribute__((noreturn));

while in actual definitions, they typically go after the return type,
as in arch/arm/kernel/traps.c:

void __attribute__((noreturn)) __bug(const char *file, int line)
{
        printk(KERN_CRIT"kernel BUG at %s:%d!\n", file, line);
        *(int *)0 = 0;

        /* Avoid "noreturn function does return" */
        for (;;);
}

  is that the standard that most people use?  if it is, i can use that
standard for the cleanup.

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
