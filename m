Return-Path: <linux-kernel-owner+w=401wt.eu-S933453AbZJOQjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933453AbZJOQjU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 12:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933319AbZJOQjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 12:39:20 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:55433 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932130AbZJOQjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 12:39:19 -0400
Date: Thu, 15 Oct 2009 12:37:20 -0400 (EDT)
From: Tim Abbott <tabbott@ksplice.com>
X-X-Sender: tabbott@dr-wily.mit.edu
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: sam@ravnborg.org, linuxppc-dev@lists.ozlabs.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: powerpc problem with .data.page_aligned -> __page_aligned_data
 conversion
In-Reply-To: <1255584772.2347.86.camel@pasglop>
Message-ID: <alpine.DEB.1.10.0910151229340.25434@dr-wily.mit.edu>
References: <1255584772.2347.86.camel@pasglop>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Oct 2009, Benjamin Herrenschmidt wrote:

> For some weird reason, our gcc until 4.3 (fixed in 4.3) had the weird
> idea that the alignment attribute should not be allowed to force an
> alignment greater than 32k. If attempted, it would warn -and- crop the
> alignment to 32k.
[...]
> This has a few issues for us:
> 
> 	- The patch that converted bits of powerpc to the new macro break since
> it now hits that bug

Hi Ben,

Just to make sure I understand the nature of the problem, is the current 
breakage that gcc < 4.3 will _warn_ on any compilation units on ppc64 that 
use __page_aligned data, or something worse?

The cropping is clearly a potential problem, but I read the rest of your 
email as saying that the cropping of the alignment isn't actually a 
problem with the current kernel because the kernel is currently only using 
the macro with things whose size is divisible by PAGE_SIZE.  However, I am 
not sure how to reconcile that with using the word "break" above...

	-Tim Abbott
