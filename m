Return-Path: <linux-kernel-owner+w=401wt.eu-S932795AbXGRXLO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932795AbXGRXLO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 19:11:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759698AbXGRXK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 19:10:59 -0400
Received: from ns.suse.de ([195.135.220.2]:56509 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759442AbXGRXK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 19:10:57 -0400
Date: Thu, 19 Jul 2007 01:10:50 +0200
From: Bernhard Walle <bwalle@suse.de>
To: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
Cc: vgoyal@in.ibm.com, kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       Dan Aloni <da-x@monatomic.org>, Neil Horman <nhorman@redhat.com>
Subject: Re: Determine version of kernel that produced vmcore
Message-ID: <20070718231050.GB25660@suse.de>
Mail-Followup-To: Ken'ichi Ohmichi <oomichi@mxs.nes.nec.co.jp>,
	vgoyal@in.ibm.com, kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org, Dan Aloni <da-x@monatomic.org>,
	Neil Horman <nhorman@redhat.com>
References: <20070716123633.GA10920@in.ibm.com> <20070718230740oomichi@mail.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070718230740oomichi@mail.jp.nec.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

* Ken'ichi Ohmichi <oomichi@mxs.nes.nec.co.jp> [2007-07-18 16:07]:
> I propose the solution including Dan's, Vivek's and Bernhard's opinions.
> How about the following sequence for distributors ?
> (It is not necessary to rebuild 2nd-kernel initrd even if 1st-kernel changes.
>  A new option "--mkdfinfo" is added to kexec command.)
> 
> * On the kernel building system
>   1. Create the kernel files.
>      # cd linux-2.6.xx
>      # make
>   2. Create the mkdfinfo file from the vmlinux.
>      # makedumpfile -g mkdfinfo-2.6.xx -x vmlinux
>      (OSRELEASE is taken from the vmlinux.)
>   3. Pack the kernel package with the kernel files and the mkdfinfo file.
> 
> * On each system
>   4. Preload 2nd-kernel and the mkdfinfo file.
>      # kexec -p vmlinux-kdump --mkdfinfo=mkdfinfo-2.6.xx ...
>      - 2nd-kernel is preloaded.
>      - 1st-kernel's PAGESIZE is taken by sysconf().
>      - The mkdfinfo file and the above PAGESIZE is preloaded
>        into /proc/vmcore's PT_NOTE segment.
>   5. Panic happens, and the system switchs to 2nd-kernel.
>   6. Create a filtered dump file.
>      # makedumpfile -cd31 /proc/vmcore dumpfile
>      (User doesn't need to specify the mkdfinfo file, because the
>       contents of the mkdfinfo file is included into /proc/vmcore.)

I like the proposal. The advantage over exporting the needed
information from the kernel directly is that makedumpfile (and the
contents of the mkdfinfo file [1]) can be changed without changing the
kernel which simplifies maintenance.

If now everybody agrees that this is the way to go, I can also offer
to implement the kernel and kexec userspace utility part
implementation of that stuff.

Maybe we should wait until Simon Horman is back here as he's the
current maintainer of kexec-tools(-testing).


Thanks,
   Bernhard

[1] didn't we agree to vmcoreinfo?
