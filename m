Return-Path: <linux-kernel-owner+w=401wt.eu-S1757980AbXGJMwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980AbXGJMwz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 08:52:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751931AbXGJMws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 08:52:48 -0400
Received: from mail.suse.de ([195.135.220.2]:49641 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508AbXGJMwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 08:52:47 -0400
Date: Tue, 10 Jul 2007 14:52:46 +0200
From: Bernhard Walle <bwalle@suse.de>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: Determine version of kernel that produced vmcore
Message-ID: <20070710125245.GB22862@suse.de>
Mail-Followup-To: kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org
References: <20070706132814.GA7079@suse.de> <20070710121315oomichi@mail.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070710121315oomichi@mail.jp.nec.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

* Ken'ichi Ohmichi <oomichi@mxs.nes.nec.co.jp> [2007-07-10 05:13]:
> Plan 1:
>   A new option [--osrelease="string"] is added.
>   The OSRELEASE of CONFIGFILE is overwritten by "string".
>   In the kernel building process, distributors should specify "string"
>   as the building kernel version.
> 
> Plan2:
>   Remove the OSRELEASE from CONFIGFILE.
>   Instead of checking the OSRELEASE, makedumpfile only checks whether the
>   area of /proc/vmcore specified by the symbol "system_utsname" in CONFIGFILE
>   is the string "2.6.". If CONFIGFILE and /proc/vmcore don't match, the
>   "system_utsname" must not point to the correct area in most cases.
>   Old makedumpfile needs OSRELEASE, and it cannot work by new CONFIGFILE.
>   But I think there are not any problems because old makedumpfile will not
>   read new CONFIGFILE. Now, CONFIGFILE is used only by RHEL5's kdump initramfs,
>   the CONFIGFILE is generated during 1st-kernel running. Even if CONFIGFILE
>   will be updated, makedumpfile can read the CONFIGFILE because makedumpfile
>   should be updated with CONFIGFILE.

I would propose a third method. Some information cannot be extracted
from the vmlinux file, even with debugging information. That is
currently the page size.

So why not adding an option to makedumpfile which specifies the
.config of the kernel? If the .config is available, it can extract the
missing information (page size) from the .config and also use the
kernel version from this file.

If no config is available, the current process is right since using
the version of the running kernel ensures to some degree (not 100 %)
that the page size is correct.


Thanks,
   Bernhard
