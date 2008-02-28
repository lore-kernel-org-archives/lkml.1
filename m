Return-Path: <linux-kernel-owner+w=401wt.eu-S1760287AbYB1X1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760287AbYB1X1O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 18:27:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757297AbYB1X07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 18:26:59 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:54370 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752100AbYB1X06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 18:26:58 -0500
Date: Thu, 28 Feb 2008 15:25:41 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pavel Roskin <proski@gnu.org>
cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Jon Masters <jcm@jonmasters.org>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 2.6.25] module: allow ndiswrapper to use GPL-only
 symbols
In-Reply-To: <1204236662.3612.6.camel@dv>
Message-ID: <alpine.LFD.1.00.0802281525170.5780@woody.linux-foundation.org>
References: <1204236662.3612.6.camel@dv>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 28 Feb 2008, Pavel Roskin wrote:
>
> A change after 2.6.24 broke ndiswrapper by accidentally removing its
> access to GPL-only symbols.  Revert that change and add comments about
> the reasons why ndiswrapper and driverloader are treated in a special
> way.

I'm not seeing why ndiswrapper should be treated separately.

If it loads non-GPL modules, it shouldn't be able to use GPLONLY symbols.

So if ndiswrapper needs GPL-only symbols, you'd better ask the people who 
made those symbols GPL-only whether they could be made available to 
ndiswrapper.

ndiswrapper itself is *not* compatible with the GPL. Trying to claim that 
ndiswrapper somehow itself is GPL'd even though it then loads modules that 
aren't is stupid and pointless. Clearly it just re-exports those GPLONLY 
functions to code that is *not* GPL'd.

		Linus
