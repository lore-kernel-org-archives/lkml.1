Return-Path: <linux-kernel-owner+w=401wt.eu-S1760942AbYCZUs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760942AbYCZUs7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 16:48:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756352AbYCZUsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 16:48:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45702 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757245AbYCZUsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 16:48:50 -0400
Date: Wed, 26 Mar 2008 13:46:33 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Gary Hade <garyhade@us.ibm.com>
cc: Ingo Molnar <mingo@elte.hu>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Thomas Meyer <thomas@m3y3r.de>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>, pm@debian.org
Subject: Re: [patch] pci: revert "PCI: remove transparent bridge sizing"
In-Reply-To: <20080326203012.GB6249@us.ibm.com>
Message-ID: <alpine.LFD.1.00.0803261344430.2775@woody.linux-foundation.org>
References: <20080325165007.GA7775@elte.hu> <47E94557.4030001@m3y3r.de> <20080325201125.GD15330@elte.hu> <20080325202954.GA22007@elte.hu> <47E969E1.6080608@m3y3r.de> <alpine.LFD.1.00.0803251445500.2775@woody.linux-foundation.org> <20080326101450.GA9060@jurassic.park.msu.ru>
 <20080326135458.GA27621@elte.hu> <20080326180701.GA6249@us.ibm.com> <alpine.LFD.1.00.0803261132310.2775@woody.linux-foundation.org> <20080326203012.GB6249@us.ibm.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 26 Mar 2008, Gary Hade wrote:
> 
> Could be but without the sizing removal I doubt that the fix I
> was going to propose (see below) would be the same.  What I had
> found is that the removal of the transparent bridge sizing was
> leaving the resource record for at least region 7 (IO) of a
> hot-added transparent bridge on the docking station in a state
> that was not palatable with later executed code in pdev_sort_resource().

Ahh, ok, so it was directly caused by simply not sizing and setting up the 
bus resources properly.

> Even though the restoration of the transparent bridge sizing
> corrects the problem, pdev_sort_resource() could probably use
> some bulletproofing.  I will take a look at this.

Thanks,

			Linus
