Return-Path: <linux-kernel-owner+w=401wt.eu-S1763422AbXFES53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763422AbXFES53 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 14:57:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753393AbXFES5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 14:57:23 -0400
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:45702 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753359AbXFES5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 14:57:22 -0400
Date: Tue, 5 Jun 2007 14:57:21 -0400
To: Tom Moore <tmoore@spatial.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 4Gb ram not showing up
Message-ID: <20070605185721.GW10006@csclub.uwaterloo.ca>
References: <46642C60.209@spatial.ca> <20070604191052.GD10008@csclub.uwaterloo.ca> <46646B4C.2070707@spatial.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46646B4C.2070707@spatial.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2007 at 03:43:08PM -0400, Tom Moore wrote:
> Thank you for the reply back.  Your answer makes perfect sense to me, 
> and it is what I had suspected but was not sure about.  The math seems 
> to indicate that 4Gb of ram plus 1Gb of PCI address space equals 5Gb of 
> memory space.  So it does sound like I should have a larger kernel model.
> 
> What confused me the most (and still does), is the help message string 
> that is presented for the CONFIG_HIGHMEM4G option:
>  "Select this if you have a 32-bit processor and between 1 and 4 
> gigabytes of physical RAM."

A better description would be:

"Select this if you have a 32-bit processor and memory mapped in the 1GB
to 4GB address range."

> Well that sounds like the amount of memory that I have, so that is what 
> I selected.
> 
> Also, although I know what PAE stands for, I don't know how to select it 
> when building a kernel.  Would I get this from the CONFIG_HIGHMEM64G 
> option?  The help text for that says:
>  "Select this if you have a 32-bit processor and more than 4 gigabytes 
> of physical RAM."

That one would be better as:

"Select this if you have a 32-bit processor and ram mapped in the address
range above 4GB."

> This does not sound like it applies to my hardware.  There is something 
> wrong with my understanding, or with these message strings.  I am still 
> confused.

In the past a number of machines couldn't remap memory, so you simply
lost any that was covered by the PCI address space.  In that case 4GB
ram mean you got 3GB or 3.5GB ram, and turning on HIGHMEM64G wouldn't
help.

In your case with some ram mapped above 4GB, you want the option that
supports up to 64GB ram (the limit of PAE) which is the
CONFIG_HIGHMEM64G.  After all since some ram is mapped between 4 and
5GB, it is as if you had 5GB ram, but the part between 3 and 4GB was
covered up.  You are just lucky enough that the covered up part got
moved out of the way instead so you get to use it.

--
Len Sorensen
