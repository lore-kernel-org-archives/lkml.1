Return-Path: <linux-kernel-owner+w=401wt.eu-S1753774AbXFKVF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774AbXFKVF4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 17:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbXFKVFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 17:05:48 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:18377 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbXFKVFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 17:05:47 -0400
X-IronPort-AV: i="4.16,409,1175486400"; 
   d="scan'208"; a="41821103:sNHT25417490"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Matt Mackall" <mpm@selenic.com>
Subject: Re: [PATCH, RFD]: Unbreak no-mmu mmap
Date: Mon, 11 Jun 2007 17:08:27 -0400
User-Agent: KMail/1.9.5
Cc: "Bernd Schmidt" <bernds_cb1@t-online.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "David Howells" <dhowells@redhat.com>,
       "Wu, Bryan" <Bryan.Wu@analog.com>, Greg Ungerer <gerg@snapgear.com>
References: <46695F6D.5050600@t-online.de> <20070609191010.GB11166@waste.org>
In-Reply-To: <20070609191010.GB11166@waste.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706111708.28058.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 11 Jun 2007 21:05:38.0859 (UTC) FILETIME=[43480FB0:01C7AC6C]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 9 Jun 2007 15:10, Matt Mackall pondered:
> On Fri, Jun 08, 2007 at 03:53:49PM +0200, Bernd Schmidt wrote:
> > 2. It is no longer possible to get blocks smaller than a page through
> >    mmap.  This behaviour was used by simplemalloc, which is an insane
> >    way of implementing malloc on nommu systems and hopefully not used
> >    by anyone anymore.
> 
> That's worrisome. Breaking existing apps/libraries seems like a bad
> idea.

It is a bad idea - but on noMMU - breaking existing apps/libraries is 
(unfortunately) a pretty common thing...
  - the standard distribution - uClinux - rebuilds all things : kernel, apps,
     libc, shell, etc which run on the target - everytime you type 'make'
 - the standard library - uClibc - has little concept of binary 
     compatibility, and has none in their years of releasing things.
     (which is OK, since everything is re-built with a simple 'make' anyway)

Plus - what Bernd talked about - uClibc's simple malloc, isn't used that often 
(at all that I am aware of), on any modern uClibc systems. The overhead of 
calling the kernel to manage memory kills performance.

As a user of the kernel in a noMMU environment - I would rather have Bernd's 
patch - which makes things closer to a MMU environment - and allows standard 
applications to work better (at all) - rather than backwards binary 
compatibility.

-Robin
