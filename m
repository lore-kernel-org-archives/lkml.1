Return-Path: <linux-kernel-owner+w=401wt.eu-S1756221AbXJXFGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221AbXJXFGs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 01:06:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753797AbXJXFGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 01:06:37 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:35292 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724AbXJXFGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 01:06:35 -0400
Date: Wed, 24 Oct 2007 07:06:33 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: linux390@de.ibm.com, linux-s390@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [BUG] 2.6.23-git19 - S390x: Kernel panic while bringing up the
	network interface
Message-ID: <20071024050633.GA12335@osiris.boeblingen.de.ibm.com>
References: <471EBC02.5000907@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <471EBC02.5000907@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2007 at 08:59:06AM +0530, Kamalesh Babulal wrote:
> Hi,
> 
> Kernel panic's while bringing up the network interface with the 2.6.23-git19
> 
> Setting network parameters:  Ý  OK  ¨
> Bringing up loopback interface:  Ý  OK  ¨
> Bringing up interface eth0:
>  Ý<00000000002e2f72>¨ inet_ioctl+0xd6/0x110
>  Ý<000000000027cae2>¨ sock_ioctl+0x26e/0x2a0
>  Ý<00000000000b4c52>¨ do_ioctl+0x4a/0xac
>  Ý<00000000000b5076>¨ vfs_ioctl+0x3c2/0x3d8
>  Ý<00000000000b50ec>¨ sys_ioctl+0x60/0x88
>  Ý<0000000000021b7e>¨ sysc_noemu+0x10/0x16
>  Ý<00000200001201ca>¨ 0x200001201ca
> 
>  <0>Kernel panic - not syncing: Fatal exception in interrupt
> 00: HCPGSP2629I The virtual machine is placed in CP mode due to a SIGP stop from
>  CPU 01.
> 02: HCPGSP2629I The virtual machine is placed in CP mode due to a SIGP stop from
>  CPU 01.
> 03: HCPGSP2629I The virtual machine is placed in CP mode due to a SIGP stop from
>  CPU 01.
> 01: HCPGIR450W CP entered; disabled wait PSW 00020001 80000000 00000000 000164DE

That should be fixed with this one:

commit f1ecfd5d3b69d98b814435758c485e6fd0e112de
Author: Ursula Braun <braunu@de.ibm.com>
Date:   Mon Oct 22 16:16:14 2007 +0200

    remove header_ops bug in qeth driver
    
    Remove qeth bug caused by commit:
    [NET]: Move hardware header operations out of netdevice.
    
    This is the second part of the qeth header_ops patch, since
    first patch sent 10/19 has been insufficient.
    Nevertheless first patch is still valid and should be kept.
    
    Signed-off-by: Ursula Braun <braunu@de.ibm.com>
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

Patch is in -rc1. Could you please pull and try again? Thanks.
