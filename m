Return-Path: <linux-kernel-owner+w=401wt.eu-S1754700AbYE2T1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700AbYE2T1p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 15:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751203AbYE2T1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 15:27:37 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:33592 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183AbYE2T1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 15:27:37 -0400
Date: Thu, 29 May 2008 22:24:39 +0300
From: Adrian Bunk <bunk@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] Werror: Hide warnings on static module device
	tables
Message-ID: <20080529192439.GB32180@cs181133002.pp.htv.fi>
References: <20080529181726.5396.79336.stgit@warthog.procyon.org.uk> <20080529181741.5396.66279.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080529181741.5396.66279.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2008 at 07:17:41PM +0100, David Howells wrote:
> Hide warnings on static module device tables that are produced when compiling a
> driver in to the core kernel rather than compiling it as a module.
> 
> This is done by introducing a MODULE_STATIC_DEVICE_TABLE() version of
> MODULE_DEVICE_TABLE() for device ID tables that are declared static.  This
> tells the compiler that the table is unused, thus suppressing warnings of the
> type:
> 
> 	mod.c:37: warning: 'id_table' defined but not used
> 
> MODULE_STATIC_DEVICE_TABLE() should not be used for non-static tables.
> 
> A MODULE_STATIC_GENERIC_TABLE() is also added for the same reason as a version
> of MODULE_GENERIC_TABLE().
> 
> This does not automatically cause the table to be emitted by the compiler; that
> will only happen if something references it.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  drivers/char/ip2/ip2main.c       |    2 +-
>  drivers/char/rocket.c            |    2 +-
>  drivers/char/specialix.c         |    2 +-
>  drivers/isdn/hisax/config.c      |    2 +-
>  drivers/media/video/zoran_card.c |    2 +-
>  drivers/scsi/dpt_i2o.c           |    2 +-
>  drivers/scsi/fdomain.c           |    2 +-
>  drivers/scsi/initio.c            |    2 +-
>  drivers/telephony/ixj.c          |    2 +-
>  drivers/watchdog/alim1535_wdt.c  |    2 +-
>  drivers/watchdog/alim7101_wdt.c  |    2 +-
>  include/linux/module.h           |   28 +++++++++++++++++++++++-----
>  sound/oss/ad1848.c               |    2 +-
>...

Isn't the warning often a reminder that a driver should be updated to 
use pci_register_driver() etc. ?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

