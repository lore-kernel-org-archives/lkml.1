Return-Path: <linux-kernel-owner+w=401wt.eu-S1760251AbYBGQiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760251AbYBGQiU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 11:38:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755181AbYBGQiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 11:38:06 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53188 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752281AbYBGQiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 11:38:05 -0500
Date: Thu, 7 Feb 2008 11:37:52 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Kexec Mailing List <kexec@lists.infradead.org>,
       Horms <horms@verge.net.au>
Subject: Re: why kexec insists on syncing with recent kernels?
Message-ID: <20080207163752.GD11969@redhat.com>
References: <47AB120A.1000600@wpkg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47AB120A.1000600@wpkg.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2008 at 03:13:30PM +0100, Tomasz Chmielewski wrote:
> According to kernel/kexec.c:
>
>  * kexec does not sync, or unmount filesystems so if you need
>  * that to happen you need to do that yourself.
>
>

In latest kexec code I do see it syncing. But it does not unmount the
filesystems. So this comment looks like partially wrong.

> I saw this was true with 2.6.18 kernel (i.e., it didn't sync), but kexec 
> syncs with recent kernels (I checked 2.6.23.14 and 2.6.24):
>
> # kexec -e
> md: stopping all md devices
> sd 2:0:0:0: [sdb] Synchronizing SCSI cache

Which kexec-tools you are using? 

syncing is initiated by user space so changing kernel will not have
any effect (as long as user space is same). I think just that message
are spitted by kernel, so probably 2.6.18 did not spit any message and
2.6.24 does.

>
>
> With kexec on 2.6.18 it was executing a loaded kernel immediately.
>
>
> Generally, it's a good thing to sync before jumping into a new kernel, but 
> it breaks my setup here after upgrading from 2.6.18 to 2.6.24.
>
> Why?
>
> I have a couple of diskless (iSCSI-boot) machines with a buggy BIOS (old 
> Supermicro P4SBR/P4SBE) which randomly freeze after rebooting (the machine 
> shuts down just fine, but instead of booting again, showing BIOS bootup 
> messages etc. you can just see blank screen).
>
> Therefore, I use kexec as a workaround for this rebooting problem.
>
> The way kexec works now makes rebooting unreliable again:
> - network interfaces are brought down,
> - kernel tries to sync - it never will, as we're booted off network, which 
> is down
>

Kexec has got an option -x --no-ifdown, which will not bring the network
down. Try that. "kexec- -e -x"


> Any ideas why kexec insists on syncing?

To me it makes sense. Just making sure that cache changes make to the file
system before you boot into new kernel.

In latest kexec-tools, I do see sync() is done first and then network
interfaces are brought down. 

Try latest kexec tools from:

http://www.vergenet.net/~horms/linux/kexec/kexec-tools/testing/kexec-tools-testing-20071017-rc.tar.gz

and see if it works fine for you.

Thanks
Vivek
