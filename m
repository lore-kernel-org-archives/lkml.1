Return-Path: <linux-kernel-owner+w=401wt.eu-S1759904AbYDSKGI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759904AbYDSKGI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 06:06:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753387AbYDSKF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 06:05:57 -0400
Received: from aun.it.uu.se ([130.238.12.36]:53193 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753351AbYDSKF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 06:05:56 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18441.50147.324276.27512@harpo.it.uu.se>
Date: Sat, 19 Apr 2008 12:05:23 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: dean gaudet <dean@arctic.org>
Cc: Joe Perches <joe@perches.com>, Harvey Harrison <harvey.harrison@gmail.com>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       Alexander van Heukelum <heukelum@fastmail.fm>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Alternative implementation of the generic __ffs
In-Reply-To: <alpine.DEB.1.10.0804182112360.6108@twinlark.arctic.org>
References: <20080331171506.GA24017@mailshack.com>
	<20080401084710.GB4787@elte.hu>
	<20080401094618.GA24862@mailshack.com>
	<alpine.DEB.1.10.0804060958580.7751@twinlark.arctic.org>
	<1207507897.18129.1246358115@webmail.messagingengine.com>
	<alpine.DEB.1.10.0804061320470.7751@twinlark.arctic.org>
	<1207563950.7880.1246457209@webmail.messagingengine.com>
	<20080418201809.GA5036@mailshack.com>
	<alpine.DEB.1.10.0804181642150.6108@twinlark.arctic.org>
	<1208563762.10414.19.camel@brick>
	<alpine.DEB.1.10.0804181719390.6108@twinlark.arctic.org>
	<1208566724.4891.25.camel@localhost>
	<1208567093.10414.20.camel@brick>
	<alpine.DEB.1.10.0804181810500.6108@twinlark.arctic.org>
	<1208573728.11990.14.camel@localhost>
	<alpine.DEB.1.10.0804182112360.6108@twinlark.arctic.org>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dean gaudet writes:
 > On Fri, 18 Apr 2008, Joe Perches wrote:
 > 
 > > On Fri, 2008-04-18 at 18:11 -0700, dean gaudet wrote: 
 > > > have you benchmarked it?
 > > 
 > > I modified Alexander's benchmark:
 > > http://lkml.org/lkml/2008/4/18/267
 > > to include 32 and 64 bit variants called smallest.
 > > 
 > > On an old ARM:
 > 
 > i'm guessing the 32-bit constants suck :(
 > 
 > the code could be modified to use 16-bit constants only

16-bit immediates don't help, as ARMs express immediate
operands in arithmetic instructions as 8-bit values plus
a 4-bit rotation count (which is multiplied by 2).

Very new ARMs can construct full 16-bit immediates, but
that still takes an additional instruction and an additional
register.
