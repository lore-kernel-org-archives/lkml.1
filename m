Return-Path: <linux-kernel-owner+w=401wt.eu-S1753187AbYDSA7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187AbYDSA7h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 20:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751012AbYDSA7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 20:59:30 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:3725 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbYDSA73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 20:59:29 -0400
Subject: Re: Alternative implementation of the generic __ffs
From: Joe Perches <joe@perches.com>
To: dean gaudet <dean@arctic.org>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       Alexander van Heukelum <heukelum@fastmail.fm>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0804181719390.6108@twinlark.arctic.org>
References: <20080331171506.GA24017@mailshack.com>
	 <20080401084710.GB4787@elte.hu> <20080401094618.GA24862@mailshack.com>
	 <alpine.DEB.1.10.0804060958580.7751@twinlark.arctic.org>
	 <1207507897.18129.1246358115@webmail.messagingengine.com>
	 <alpine.DEB.1.10.0804061320470.7751@twinlark.arctic.org>
	 <1207563950.7880.1246457209@webmail.messagingengine.com>
	 <20080418201809.GA5036@mailshack.com>
	 <alpine.DEB.1.10.0804181642150.6108@twinlark.arctic.org>
	 <1208563762.10414.19.camel@brick>
	 <alpine.DEB.1.10.0804181719390.6108@twinlark.arctic.org>
Content-Type: text/plain
Date: Fri, 18 Apr 2008 17:58:44 -0700
Message-Id: <1208566724.4891.25.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-04-18 at 17:20 -0700, dean gaudet wrote:
> any reasonable compiler should figure out the two are the same... but i 
> really prefer spelling out the lack of dependencies of the computations by 
> breaking it out per-bit.

It seems gcc 4.3 (-Os or -O2) isn't a reasonable compiler.

I think this might be best:

int ffs32(unsigned int value)
{
	int x;

	value &= -value;
	if (!(value & 0x55555555))
		x = 1;
	else
		x = 0;
	if (!(value & 0x33333333))
		x |= 2;
	if (!(value & 0x0f0f0f0f))
		x |= 4;
	if (!(value & 0x00ff00ff))
		x |= 8;
	if (!(value & 0x0000ffff))
		x |= 16;

	return x;
}

