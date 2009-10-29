Return-Path: <linux-kernel-owner+w=401wt.eu-S1753815AbZJ2KNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815AbZJ2KNW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 06:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752481AbZJ2KNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 06:13:21 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40761
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751663AbZJ2KNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 06:13:20 -0400
Date: Thu, 29 Oct 2009 03:13:44 -0700 (PDT)
Message-Id: <20091029.031344.102288703.davem@davemloft.net>
To: hancockrwd@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH] ide: update Kconfig text to mark as deprecated
From: David Miller <davem@davemloft.net>
In-Reply-To: <4AE64FCC.4030102@gmail.com>
References: <4AE64FCC.4030102@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Hancock <hancockrwd@gmail.com>
Date: Mon, 26 Oct 2009 19:41:32 -0600

> The current Kconfig text for CONFIG_IDE doesn't give a hint to users that this
> subsystem is currently in maintenance mode and isn't actively developed.
> Let's correct this by marking it as deprecated, and also get rid of a bunch of
> unnecessary text that doesn't really have anything to do with what the option is
> for.
> 
> Signed-off-by: Robert Hancock <hancockrwd@gmail.com>

Applied to ide-next-2.6, thanks.

But honestly, we have to reword or revert this if certain
things don't happen before the next merge window.

What it comes to is that two things have to happen before
we can completely shut down IDE and schedule it's removal.

1) Add a way for the ATA layer to create compat device
   nodes so that people can change over to use the ATA
   layer for their devices without any fstab et al. changes.

   These compat device nodes do not have to be so featureful
   that they support hdparm or smartd or anything like that,
   but they need to work well enough to mount filesystems, and
   mount swap partitions, and interact with device management
   systems like udev as if they were real IDE devices.

2) The two or so remaining devices which have IDE support but
   don't have an ATA layer driver need porting.

I plan to work on #1 if I get the time.  Someone with the requisite
hardware needs to work on #2, and I'm sure whoever wants to work on
that will find it easy to get help from some ATA layer experts.
