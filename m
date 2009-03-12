Return-Path: <linux-kernel-owner+w=401wt.eu-S1752369AbZCLHvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369AbZCLHvA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 03:51:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751191AbZCLHuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 03:50:51 -0400
Received: from www.tglx.de ([62.245.132.106]:49261 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047AbZCLHuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 03:50:50 -0400
Date: Thu, 12 Mar 2009 08:50:34 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: john stultz <johnstul@us.ibm.com>
cc: Frans Pop <elendil@planet.nl>, linux-s390@vger.kernel.org,
       Roman Zippel <zippel@linux-m68k.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG,2.6.28,s390] Fails to boot in Hercules S/390 emulator
In-Reply-To: <1236823066.7680.178.camel@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0903120849270.29264@localhost.localdomain>
References: <200903080230.10099.elendil@planet.nl>  <200903091604.56455.elendil@planet.nl> <1236733226.6080.28.camel@localhost>  <200903111703.41663.elendil@planet.nl>  <1236817822.7680.148.camel@localhost.localdomain>  <1236818863.7680.156.camel@localhost.localdomain>
  <alpine.LFD.2.00.0903120201040.29264@localhost.localdomain> <1236823066.7680.178.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Mar 2009, john stultz wrote:
> Maybe a different way of expressing what we're calculating is the
> following:
> 
> xtime.tv_nsec = (clock->xtime_nsec + (1<<clock->shift)) >> clock->shift
> clock->xtime_nsec = (1<<clock->shift) 
> 			- (clock->xtime_nsec &((1<<clock->shift)-1)
> 
> In other words: The rounded up portion - the masked remainder in
> xtime_nsec.
> 
> Does that make sense?

Yes, now that my brain works again. I knew I was missing something.

You are definitely right: math _is_ hard :)

    tglx
