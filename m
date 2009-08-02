Return-Path: <linux-kernel-owner+w=401wt.eu-S1753240AbZHBRTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbZHBRTt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 13:19:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753131AbZHBRTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 13:19:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53778 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751365AbZHBRTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 13:19:48 -0400
Date: Sun, 2 Aug 2009 10:19:42 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Matthew Wilcox <matthew@wil.cx>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Wilcox <willy@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrew Patterson <andrew.patterson@hp.com>
Subject: Re: [Regression] PCI resources allocation problem on HP nx6325
In-Reply-To: <20090802171550.GC3711@parisc-linux.org>
Message-ID: <alpine.LFD.2.01.0908021018420.3352@localhost.localdomain>
References: <200908021619.48285.rjw@sisk.pl> <alpine.LFD.2.01.0908020927410.3352@localhost.localdomain> <20090802171550.GC3711@parisc-linux.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 2 Aug 2009, Matthew Wilcox wrote:
> 
> It *might* break HP's ia64 machines.  I have this feeling that the serial
> ports may be claimed in the resource tree before the PCI resources are
> claimed (and then they need to nest under a PCI bus).
> 
> How about this variant which will insert_resource for _bus_ resources,
> but request_resource for _device_ resources?

Ugh. Please no. Hackery like this will just lead to unmaintainable crud in 
the long run. Can you just fix ia64 instead? The firmware resources should 
be added _after_ the PCI resource tree has been walked, not before.

		Linus
