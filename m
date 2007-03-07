Return-Path: <linux-kernel-owner+w=401wt.eu-S1750821AbXCGQ02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750821AbXCGQ02 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 11:26:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750992AbXCGQ02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 11:26:28 -0500
Received: from smtp.osdl.org ([65.172.181.24]:42328 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821AbXCGQ01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 11:26:27 -0500
Date: Wed, 7 Mar 2007 08:25:54 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tim Waugh <tim@cyberelk.net>, linux-parport@lists.infradead.org
Subject: Re: Linux v2.6.21-rc3
In-Reply-To: <45EEB99D.7020406@googlemail.com>
Message-ID: <Pine.LNX.4.64.0703070813460.5963@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0703062050570.5963@woody.linux-foundation.org>
 <45EEB99D.7020406@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Mar 2007, Michal Piotrowski wrote:
> 
> BTW. Does anyone care about parport console?

I do think we care, but I don't think anybody in particular feels singled 
out as a maintainer...

> console=lp0 hangs since at least 2.6.18

Ok, that's not exactly new then, which implies that not a *lot* of people 
even care ;)

Do you think you'd be willing to try to figure out when it started? You 
seem to be the first one to have even noticed.

(I tried to google it, and the most recent thing google finds is your 
report, although I also saw a report of somebody trying it under qemu in 
July last year and also reported a hang)

Looking through the history of the last few years (it in git), I don't see 
anything even *remotely* suspicious there, so it's probably either 
 (a) really old, and hasn't worked in a loong time and nobody just uses it
 (b) something really stupid that happened while doing other cleanups (but 
     the changes in the last two years are *literally* just things like 
     removing devfs support)
 (c) some infrastructure change that subtly broke lpconsole, probably 
     causing an oops during printk, which obviously results in a printk 
     itself, which thus hangs.

It would be good to get it fixed, although for obvious reasons it's not a 
huge priority..

		Linus
