Return-Path: <linux-kernel-owner+w=401wt.eu-S1754960AbYKZSSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960AbYKZSSy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 13:18:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752376AbYKZSSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 13:18:44 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:59110 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227AbYKZSSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 13:18:43 -0500
Date: Wed, 26 Nov 2008 10:18:41 -0800
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-pci <linux-pci@vger.kernel.org>
Subject: Re: [PATCH] fakephp: Allocate PCI resources before adding the device
Message-ID: <20081126181841.GF6539@plum>
Reply-To: djwong@us.ibm.com
References: <20081125212422.22631.69619.stgit@elm3a70.beaverton.ibm.com> <Pine.LNX.4.64.0811251919590.5161@t2.domain.actdsltmp> <20081126074808.GE6539@plum> <Pine.LNX.4.58.0811260131200.24816@shell4.speakeasy.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0811260131200.24816@shell4.speakeasy.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2008 at 01:56:45AM -0800, Trent Piepho wrote:
> Ok, that makes sense.  The device I'm using fakephp for doesn't have a
> kernel driver so I wouldn't have noticed that.
> 
> Have you tested this with a device that isn't present at boot?  I found
> that I needed to a call to pci_enable_device() after assigning resources,
> otherwise the BARs wouldn't be enabled.  This only happened if the device
> wasn't present at boot time.

Yes, I was actually using this driver to <cough> turn the ioatdma
controller on after turning it off in the BIOS.

> My hardware doesn't run on the latest kernel so I can't test it.  It looks
> like there have been a bunch of pci hotplug changes so back porting this
> might not be feasible.  It also looks a previous patch by Alex Chiang
> completely changed the sysfs interface for fakephp.  I thought sysfs
> interfaces were supposed to be stable?!  Also looks like it made fakephp

I doubt that, sysfs interfaces change all the time.  I think only the
syscall interface has any sort of stability guarantee.

> useless.  How are you supposed to figure out which "fake-n" directory is
> the right one to disable the device you want?

cat /sys/bus/pci/slots/fake*/address

--D
