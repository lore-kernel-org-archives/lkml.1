Return-Path: <linux-kernel-owner+w=401wt.eu-S935545AbXGLQoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935545AbXGLQoQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 12:44:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753151AbXGLQoC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 12:44:02 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:46084 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752248AbXGLQoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 12:44:00 -0400
Date: Thu, 12 Jul 2007 12:44:00 -0400
To: James <LinuxKernel@jamesplace.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Problem recovering a failed RIAD5 array with 4-drives.
Message-ID: <20070712164400.GD31195@csclub.uwaterloo.ca>
References: <200707120849.16068.LinuxKernel@jamesplace.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707120849.16068.LinuxKernel@jamesplace.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2007 at 08:49:15AM -0500, James wrote:
> My apologies if this is not the correct forum. If there is a better place to 
> post this please advise.
> 
> 
> Linux localhost.localdomain 2.6.17-1.2187_FC5 #1 Mon Sep 11 01:17:06 EDT 2006 
> i686 i686 i386 GNU/Linux
> 
> (I was planning to upgrade to FC7 this weekend, but that is currently on hold 
> because-)
> 
> I've got a problem with a software RIAD5 using mdadm.
> Drive sdc failed causing sda to appear failed. Both drives where marked 
> as 'spare'.
> 
> What follows is a record of the steps I've taken and the results. I'm looking 
> for some direction/advice to get the data back. 
> 
> 
> I've tried a few cautions things to bring the array back up with the three 
> good drives with no luck. 
> 
> The last thing attempted had some limited success. I was able to get all 
> drives powered up. I checked the Event count on the three good drives and 
> they were all equal. So I assumed it would be safe to do the following. I 
> hope I was not wrong. I issued the following commands to try to bring the 
> array into a usable state.
> 
> 
> 
> 
> []# 
> mdadm --create --verbose /dev/md0 --assume-clean --level=raid5 --raid-devices=4 --spare-devices=0  /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1

Don't you want assemble rather than create if it already exists?

How did two drives fail at the same time?  Are you running PATA drives
with two drives on a single cable?  That is a no no for raid.  PATA
drive failures often take out the bus and you never want two drives in a
single raid to share an IDE bus.

You probably want to try and assemble the non failed drives, and then
add in the new replacement drive afterwards, since after all it is NOT
clean.  Hopefully the raid will accept back sda even though it appeared
failed.  Then you can add the new sdc to resync the raid.

--
Len Sorensen
