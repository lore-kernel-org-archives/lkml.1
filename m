Return-Path: <linux-kernel-owner+w=401wt.eu-S968337AbXEHVsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968337AbXEHVsR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 17:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967397AbXEHVsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 17:48:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:38532 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966266AbXEHVsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 17:48:15 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [patch 4/4] Add common orderly_poweroff()
Date: Tue, 8 May 2007 17:45:17 -0400
User-Agent: KMail/1.9.5
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
       "David S. Miller" <davem@davemloft.net>
References: <20070508205129.064843364@goop.org> <20070508205517.358968475@goop.org>
In-Reply-To: <20070508205517.358968475@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705081745.18201.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 May 2007 16:51, Jeremy Fitzhardinge wrote:
> Various pieces of code around the kernel want to be able to trigger an
> orderly poweroff.  This pulls them together into a single
> implementation.
> 
> By default the poweroff command is /sbin/poweroff, but it can be set
> via sysctl: kernel/poweroff_cmd.  This is split at whitespace, so it
> can include command-line arguments.
> 
> This patch replaces four other instances of invoking either "poweroff"
> or "shutdown -h now": one sparc64, two sbus drivers, and acpi thermal
> management.
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
> Cc: Chris Wright <chrisw@sous-sol.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Andi Kleen <ak@suse.de>
> Cc: Len Brown <lenb@kernel.org>

Re: the ACPI parts
Acked-by: Len Brown <len.brown@intel.com>

thanks,
-Len
 
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: David S. Miller <davem@davemloft.net>
> 
> ---
>  arch/sparc64/kernel/power.c     |   40 +------------------------------
>  drivers/acpi/thermal.c          |   24 +-----------------
>  drivers/sbus/char/bbc_envctrl.c |    5 +--
>  drivers/sbus/char/envctrl.c     |    7 +----
>  include/linux/reboot.h          |    5 +++
>  include/linux/sysctl.h          |    1
>  kernel/sys.c                    |   50 +++++++++++++++++++++++++++++++++++++++
>  kernel/sysctl.c                 |   10 +++++++
>  8 files changed, 74 insertions(+), 68 deletions(-)
