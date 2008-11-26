Return-Path: <linux-kernel-owner+w=401wt.eu-S1753402AbYKZJFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402AbYKZJFz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 04:05:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751824AbYKZJFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 04:05:42 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59301
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751239AbYKZJFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 04:05:41 -0500
Date: Wed, 26 Nov 2008 01:05:41 -0800 (PST)
Message-Id: <20081126.010541.158438052.davem@davemloft.net>
To: viro@ftp.linux.org.uk
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/32] of_platform_driver noise on sparce
From: David Miller <davem@davemloft.net>
In-Reply-To: <E1L3wNs-0006R4-JQ@ZenIV.linux.org.uk>
References: <E1L3wNs-0006R4-JQ@ZenIV.linux.org.uk>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 22 Nov 2008 17:35:04 +0000

> 
> switch to __init for those; unlike powerpc sparc has no hotplug support
> for that stuff and their ->probe() tends to call __init functions while
> being declared __devinit.
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  arch/sparc64/kernel/pci_fire.c   |    2 +-
>  arch/sparc64/kernel/pci_psycho.c |    4 ++--
>  arch/sparc64/kernel/pci_sun4v.c  |    2 +-
>  drivers/sbus/char/bbc_i2c.c      |    6 +++---
>  sound/sparc/cs4231.c             |   10 +++++-----
>  5 files changed, 12 insertions(+), 12 deletions(-)

There's tons of sparc specific drivers not handled here.
For example, drivers/scsi/sun_esp.c, drivers/scsi/qlogicpti.c,
and on and on and on.

In fact there are more sparc specific drivers using
of_platform_driver under drivers/ thans powerpc :)

I don't think I want to do this for now, sorry Al.
