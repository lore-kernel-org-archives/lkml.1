Return-Path: <linux-kernel-owner+w=401wt.eu-S1750839AbXCMTmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750839AbXCMTmW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 15:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752521AbXCMTmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 15:42:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60148 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839AbXCMTmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 15:42:21 -0400
Date: Tue, 13 Mar 2007 12:40:24 -0700
From: Greg KH <gregkh@suse.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Jeff Garzik <jeff@garzik.org>
Subject: Re: Linux v2.6.21-rc3
Message-ID: <20070313194024.GA14847@suse.de>
References: <Pine.LNX.4.64.0703062050570.5963@woody.linux-foundation.org> <m1zm6hq70n.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1zm6hq70n.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2007 at 01:26:48PM -0600, Eric W. Biederman wrote:
> - We have a network ABI regression caused by the latest sysfs
>   changes to net-sysfs.c   In particular we now cannot rename network
>   devices if our destination name happens to be the name of a sysfs file that
>   the network device appears in, and if we try the kernel gets very
>   confused and we loose access to the network device. 
> 
>   Do we just want to revert commit 43cb76d91ee85f579a69d42bc8efc08bac560278
>   Greg has been working on this off and on and has not found a
>   simple solution yet.

I do not think this should be reverted, as the odds that some one will
rename their network device to be "irq" or something else that is in the
pci device's directory is pretty slim.  It also only shows up if
CONFIG_SYSFS_DEPRECATED is disabled, not the common option.

But I am still working on it, I sent you and Kay a patch that, while it
locks up at boot time, should be close to what we need to address this
:)

> - pci_save_state, pci_restore_state are broken and have been for a
>   while if used on anything besides plain pci (pci-x, pci-e and msi)
>   and are not used in pairs. (gregkh and Andrew have the patches to 
>   correct this).

I think these are already in Linus's tree right now, right?

thanks,

greg k-h
