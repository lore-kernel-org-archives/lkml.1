Return-Path: <linux-kernel-owner+w=401wt.eu-S1754190AbZAKVGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190AbZAKVGs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 16:06:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752432AbZAKVGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 16:06:40 -0500
Received: from mu-out-0910.google.com ([209.85.134.188]:26878 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbZAKVGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 16:06:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=EIH/q9FbjuhyQshSlb5d2wOqSMBzNb8vUpk5JumxoAJcvb1sl4Lcq7nCF/kfC/9IuI
         HbGxsycu3AhlKJst/0UrS/C/EjoQLN8iQnJbw3A9IRiSmY2aDlTDUb5VSMmnHAc9sO4m
         rEXxk0eYhkoo5ZjMR2LjfKlebJm9F9WE9u3Ig=
Message-ID: <64bb37e0901111306sf1efbachbeb5ad523fa17e26@mail.gmail.com>
Date: Sun, 11 Jan 2009 22:06:37 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Gene Heskett" <gene.heskett@gmail.com>
Subject: Re: Linux 2.6.29-rc1 MAJOR advisory
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <200901111510.30064.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.2.00.0901101551420.6528@localhost.localdomain>
	 <200901111510.30064.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2009 at 9:10 PM, Gene Heskett <gene.heskett@gmail.com> wrote:
> I don't believe it is.  MAJOR problem. I have an ASUS M2N-SLI Deluxe
> motherboard I paid about $275 for in late Sept 2008, and one attempt to boot
> the 2.6.29-rc1 I had built destroyed the MCP55 eth0 port, no power on the
> port at all now, and I've rebooted to 2.6.28, still no eth0, so I have now
> enabled in the bios and am using the 2nd & last eth1 port on this mobo.

I have also an ASUS MCP55 board, a KFN5-D.

To save the crash I reported in the "[git pull] x86 fixes" thread, I
had to boot the patch -rc1 a second time.
After saving the Oops on my second pc I rebooted my test system (the
one with the MCP55) into 2.6.28 and the boot process hung as it wanted
to mount its NFS filesystems. Trying to connect from the second system
failed, not even a ping reply.
But: Just removing the ethernet cable and immediately reconnecting it
seemed to have kicked my MCP55 ethernet port back in working order.

No fishy things in the syslog...

Jan 11 17:14:15 treogen [   61.412278] tg3 0000:03:00.0: irq 379 for MSI/MSI-X
Jan 11 17:14:15 treogen [   61.790728] tg3 0000:02:00.0: irq 378 for MSI/MSI-X
Jan 11 17:14:15 treogen [   64.481794] tg3: eth1: Link is up at 1000
Mbps, full duplex.
Jan 11 17:14:15 treogen [   64.481802] tg3: eth1: Flow control is on
for TX and on for RX.
Jan 11 17:14:21 treogen mdadm[2934]: NewArray event detected on md
device /dev/md0
Jan 11 17:14:21 treogen mdadm[2934]: NewArray event detected on md
device /dev/md1
Jan 11 17:14:26 treogen ntpdate[2945]: no server suitable for
synchronization found
Jan 11 17:14:26 treogen /etc/init.d/ntp-client[2937]: ERROR:
ntp-client failed to start
Jan 11 17:14:27 treogen rpc.statd[2972]: Version 1.1.4 Starting
Jan 11 17:14:27 treogen rpc.statd[2972]: Flags:
Jan 11 17:14:27 treogen rpc.statd[2972]: statd running as root. chown
/var/lib/nfs/sm to choose different user
Jan 11 17:14:28 treogen [   86.282514] RPC: failed to contact local
rpcbind server (errno 5).
-> here the boot hung until I disconnected/reconnected the cable...
Jan 11 17:16:25 treogen [  203.592837] tg3: eth1: Link is down.
Jan 11 17:16:28 treogen [  206.255079] tg3: eth1: Link is up at 1000
Mbps, full duplex.
Jan 11 17:16:28 treogen [  206.255086] tg3: eth1: Flow control is on
for TX and on for RX.
Jan 11 17:17:57 treogen postfix/postfix-script[3067]: starting the
Postfix mail system

Torsten
