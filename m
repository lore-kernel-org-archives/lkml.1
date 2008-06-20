Return-Path: <linux-kernel-owner+w=401wt.eu-S1758384AbYFTP4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758384AbYFTP4d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 11:56:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756883AbYFTP4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 11:56:25 -0400
Received: from mail.suse.de ([195.135.220.2]:42217 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756819AbYFTP4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 11:56:24 -0400
From: Bernhard Walle <bwalle@suse.de>
To: kexec@lists.infradead.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, vgoyal@redhat.com,
       Bernhard Walle <bwalle@suse.de>
Subject: Introduce userspace interface for Firmware-provided memory map
Date: Fri, 20 Jun 2008 17:56:57 +0200
Message-Id: <1213977420-1555-1-git-send-email-bwalle@suse.de>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch (as request for comments) introduces a new userspace interface
/proc/firmware_mem that provides the unfiltered view of the BIOS on
memory configuration. That's usable for two reasons:

 1) Debugging (yes, the E820 memory is printed in kernel ring buffer, but that's
    not the case for all platforms, on IA64 you have to enable some magic define
    to print the EFI memory map, for example),
 
 2) Kexec. When the user or the system uses a special command line to modify the
    memory configuration, kexec still needs a method to get the original memory
    map.  While the filtered view is useful for generating ELF core headers for
    crashdumps, the unfiltered view is necessary to boot the next kernel without
    the "limitations" the original kernel has.

We had the discussion to add iomem_used on kexec mailing list. However, I think
it's better to let /proc/iomem represent the *filtered* (i.e. "used") view of
the I/O resources and introduce a new interface for the *unfiltered* view.
There are two reasons:

 1) On i386 (the oldest architectures), /proc/iomem always represented the
    *filtered* view (i.e. "mem" parameter was also visible in /proc/iomem).
    I think we should not change the semantics of an interface without a reason.
 
 2) /proc/iomem_used would it make necessary to duplicate all registration between
    /proc/iomem and /proc/iomem_used. Because currently the resource root
    is exported and used everywhere in the kernel source, that would make
    changes of the whole resource infrastructure necessary if code duplication
    should be avoided.

Maybe you think that /proc/firmware_mem is not the right place to export that.
I don't know, I also don't care that much about the naming or the way to export
that. So, please advise me if you agree that it's ok for kexec to export an
unfiltered view of the memory map.

The patch has been tested on i386 and x86_64.



Signed-off-by: Bernhard Walle <bwalle@suse.de>



