Return-Path: <linux-kernel-owner+w=401wt.eu-S1753713AbYKPPUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713AbYKPPUX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 10:20:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751997AbYKPPUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 10:20:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48405 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795AbYKPPUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 10:20:06 -0500
Date: Sun, 16 Nov 2008 16:20:03 +0100
From: Bernhard Walle <bwalle@suse.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       crash-utility@redhat.com
Subject: Re: Turn CONFIG_STRICT_DEVMEM in sysctl dev.mem.restricted
Message-ID: <20081116162003.04267538@kopernikus.site>
In-Reply-To: <20081116150756.3cece2de@lxorguk.ukuu.org.uk>
References: <1226846868-9595-1-git-send-email-bwalle@suse.de>
	<20081116150756.3cece2de@lxorguk.ukuu.org.uk>
Organization: SUSE Linux Products GmbH
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alan Cox [2008-11-16 15:07]:
>
> > The protection in the general case and the ability to do live debugging.
> 
> What protection. You've completely failed to explain or provide a single
> example of any protection provided by the STRICT_DEVMEM code.

I don't need to explain what protection STRICT_DEVMEM provides, just
because I didn't submit STRICT_DEVMEM. However:

    Author: Arjan van de Ven <arjan@linux.intel.com>
    Date:   Thu Apr 24 23:40:47 2008 +0200

    The X server needs access to /dev/mem for the PCI space, but it doesn't need
    access to memory; both the file permissions and SELinux permissions of /dev/mem
    just make X effectively super-super powerful. With the exception of the
    BIOS area, there's just no valid app that uses /dev/mem on actual memory.
    Other popular users of /dev/mem are rootkits and the like.
    (note: mmap access of memory via /dev/mem was already not allowed since
    a really long time)

So without that patch, a distributor needs to have two kernels: One
with SELinux and with /dev/mem protection and one without it. If I
remember correctly, you can turn off SELinux on the boot command line.
But I never used it. At least I don't see -selinux and -noselinux
kernels in Redhat.

However, with my patch you can make everything configurable. With
SELinux or Apparmor you can also protect the user from writing that
sysctl. Or from loading kernel modules that circumvent that protection.



Regards,
Bernhard
