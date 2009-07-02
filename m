Return-Path: <linux-kernel-owner+w=401wt.eu-S1752003AbZGBFoD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003AbZGBFoD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 01:44:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750822AbZGBFny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 01:43:54 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2823 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbZGBFnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 01:43:53 -0400
Subject: Re: printk regression?
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.01.0907012119370.3380@localhost.localdomain>
References: <4A4C3410.8080704@kernel.org>
	 <alpine.LFD.2.01.0907012119370.3380@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 01 Jul 2009 22:42:36 -0700
Message-Id: <1246513356.28915.62.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-01 at 21:23 -0700, Linus Torvalds wrote:
> 
> On Wed, 1 Jul 2009, Yinghai Lu wrote:
> >
> > [   75.690022] <7>printing local APIC contents on CPU#0/0:
> 
> Yes. This is because the io_apic code should be fixed.
> 
> It does:
> 
> 	printk("\n" KERN_DEBUG "printing local APIC
> 
> and that "\n" at the beginning should just be deleted. The log-level 
> should be at the beginning of the printk, not in the middle.

There's at least 72 of them:

$ grep -Pr --include=*.[ch] "\bprintk.*\\\n.*KERN_" *


