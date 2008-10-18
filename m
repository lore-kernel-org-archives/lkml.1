Return-Path: <linux-kernel-owner+w=401wt.eu-S1752092AbYJRPAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092AbYJRPAZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 11:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751453AbYJRPAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 11:00:09 -0400
Received: from netrider.rowland.org ([192.131.102.5]:2307 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751322AbYJRPAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 11:00:08 -0400
Date: Sat, 18 Oct 2008 11:00:06 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Andrew Morton <akpm@linux-foundation.org>
cc: Oliver Bock <bock@tfh-berlin.de>, <linux-kernel@vger.kernel.org>,
       <linux-acpi@vger.kernel.org>, <xfs-masters@oss.sgi.com>,
       <linux-usb@vger.kernel.org>
Subject: Re: 2.6.27: "array subscript is above array bounds" warnings
In-Reply-To: <20081017235046.f3c6c86e.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.44L0.0810181050570.1298-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Oct 2008, Andrew Morton wrote:

> (cc's added)
> 
> On Tue, 14 Oct 2008 22:17:36 +0200 Oliver Bock <bock@tfh-berlin.de> wrote:
> 
> > Hi all,
> > 
> > FYI, I just came across the following warnings when compiling 2.6.27 
> > (release) using gcc 4.3.2 (Debian 4.3.2-1) on Debian Lenny (i386):

...

> > drivers/usb/core/hcd.c: In function ___usb_hcd_poll_rh_status___:
> > include/asm/string_32.h:75: warning: array subscript is above array bounds

Does this refer to the call to memcpy() in usb_hcd_poll_rh_status()?

Line 75 in string_32.h is part of the __constant_memcpy() function.  
That function should not be involved here because the length argument 
isn't a compile-time constant.

This has to be either a compiler bug or else a bug in the
implementation of memcpy.

Alan Stern

