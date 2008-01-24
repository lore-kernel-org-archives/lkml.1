Return-Path: <linux-kernel-owner+w=401wt.eu-S1754398AbYAXHBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398AbYAXHBb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 02:01:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752114AbYAXHBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 02:01:23 -0500
Received: from gate.crashing.org ([63.228.1.57]:58865 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751962AbYAXHBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 02:01:22 -0500
Cc: mporter@kernel.crashing.org, paulus@samba.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Message-Id: <71AAAC27-C150-4C3D-B065-BC15196BED2B@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Zhang Wei <wei.zhang@freescale.com>
In-Reply-To: <11854393771067-git-send-email-wei.zhang@freescale.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v915)
Subject: Re: [PATCH 5/5 v3] Add the memory management driver to RapidIO.
Date: Thu, 24 Jan 2008 01:01:07 -0600
References: <11854393721520-git-send-email-wei.zhang@freescale.com> <11854393733580-git-send-email-wei.zhang@freescale.com> <11854393741899-git-send-email-wei.zhang@freescale.com> <11854393753986-git-send-email-wei.zhang@freescale.com> <11854393763547-git-send-email-wei.zhang@freescale.com> <11854393771067-git-send-email-wei.zhang@freescale.com>
X-Mailer: Apple Mail (2.915)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 26, 2007, at 3:42 AM, Zhang Wei wrote:

> This patch adds the memory management driver to RapidIO.
> The RapidIO system size is changed to automatically detection.
> Add the memory mapping driver to RapidIO basic driver.
> Multi master ports are supported.
> Add a simple Bitmap RapidIO space allocator driver.

Can we break up the functionality here into separate patches.  I'm  
seeing 4 logical patches:
* system size is changed to automatic detection
* support for multi master ports
* bitmap allocator
* memory map driver


> Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
> ---
> drivers/net/rionet.c                |   17 +-
> drivers/rapidio/Kconfig             |   18 +-
> drivers/rapidio/Makefile            |    1 +
> drivers/rapidio/rio-access.c        |   10 +-
> drivers/rapidio/rio-scan.c          |   53 +++--
> drivers/rapidio/rio-sysfs.c         |    3 +-
> drivers/rapidio/rio.c               |  479 ++++++++++++++++++++++++++ 
> ++++++++-
> drivers/rapidio/rio.h               |    9 +-
> drivers/rapidio/sallocator/Kconfig  |    9 +
> drivers/rapidio/sallocator/Makefile |   12 +
> drivers/rapidio/sallocator/bitmap.c |  382 ++++++++++++++++++++++++++ 
> ++
> include/linux/rio.h                 |   71 +++++-
> include/linux/rio_drv.h             |   41 +++-
> 13 files changed, 1046 insertions(+), 59 deletions(-)
> create mode 100644 drivers/rapidio/sallocator/Kconfig
> create mode 100644 drivers/rapidio/sallocator/Makefile
> create mode 100644 drivers/rapidio/sallocator/bitmap.c

[snip]

> +config RAPIDIO_PROC_FS
> +	bool "I/O and Memory resource debug"
> +	depends on RAPIDIO && PROC_FS
> +	default y
> +	---help---
> +	  Enable this option, it will create a /proc/riores node for
> +	  monitoring the RapidIO I/O and Memory resource.
> +

This isn't going to be acceptable.  You should use sysfs or debugfs  
not proc.

- k
