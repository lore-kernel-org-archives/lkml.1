Return-Path: <linux-kernel-owner+w=401wt.eu-S1755658AbYCLW1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658AbYCLW1P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 18:27:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751815AbYCLW06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 18:26:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47146 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751124AbYCLW06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 18:26:58 -0400
Date: Wed, 12 Mar 2008 15:25:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <greg@kroah.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Garzik <jeff@garzik.org>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <len.brown@intel.com>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: pcibios_scanned needs to be set in ACPI?  (was Re: 2.6.25-rc5:
 Reported regressions from 2.6.24)
In-Reply-To: <20080312213826.GA17101@kroah.com>
Message-ID: <alpine.LFD.1.00.0803121521550.3557@woody.linux-foundation.org>
References: <200803110014.52985.rjw@sisk.pl> <alpine.LFD.1.00.0803101913340.5896@woody.linux-foundation.org> <47D6D61F.4050805@garzik.org> <200803112341.42517.rjw@sisk.pl> <alpine.LFD.1.00.0803121300160.3557@woody.linux-foundation.org> <20080312203205.GB17187@kroah.com>
 <20080312212704.GA16836@kroah.com> <20080312213826.GA17101@kroah.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 12 Mar 2008, Greg KH wrote:
> 
> Actually, here's a simple patch from -next that should test this logic
> for you.  Can you let me know if this solves the start up WARNING dump
> for you?

This patch looks bogus.

Why do you introduce a "dev->is_added" field that apparently has to match 
the old "list_empty(&dev->global_list)" 1:1 anyway?

In other words: when is it *ever* permissible for "is_added" to have a 
different value from the "list_empty(..)" logic? And if they must always 
match (and it looks like they have to, since you set and clear the flag 
exactly when you add/remove it from the list), then what exactly is this 
supposed to fix?

			Linus
