Return-Path: <linux-kernel-owner+w=401wt.eu-S1753821AbXJXLtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821AbXJXLtj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 07:49:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752764AbXJXLt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 07:49:27 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:52176 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624AbXJXLtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 07:49:25 -0400
Message-ID: <471F2499.7030309@linux.vnet.ibm.com>
Date: Wed, 24 Oct 2007 16:25:21 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: linux390@de.ibm.com, linux-s390@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [BUG] 2.6.23-git19 - S390x: Kernel panic while bringing up the
 network interface
References: <471EBC02.5000907@linux.vnet.ibm.com> <20071024050633.GA12335@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20071024050633.GA12335@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko Carstens wrote:
> On Wed, Oct 24, 2007 at 08:59:06AM +0530, Kamalesh Babulal wrote:
>> Hi,
>>
>> Kernel panic's while bringing up the network interface with the 2.6.23-git19
>>
>> Setting network parameters:  Ý  OK  ¨
>> Bringing up loopback interface:  Ý  OK  ¨
>> Bringing up interface eth0:
>>  Ý<00000000002e2f72>¨ inet_ioctl+0xd6/0x110
>>  Ý<000000000027cae2>¨ sock_ioctl+0x26e/0x2a0
>>  Ý<00000000000b4c52>¨ do_ioctl+0x4a/0xac
>>  Ý<00000000000b5076>¨ vfs_ioctl+0x3c2/0x3d8
>>  Ý<00000000000b50ec>¨ sys_ioctl+0x60/0x88
>>  Ý<0000000000021b7e>¨ sysc_noemu+0x10/0x16
>>  Ý<00000200001201ca>¨ 0x200001201ca
>>
>>  <0>Kernel panic - not syncing: Fatal exception in interrupt
>> 00: HCPGSP2629I The virtual machine is placed in CP mode due to a SIGP stop from
>>  CPU 01.
>> 02: HCPGSP2629I The virtual machine is placed in CP mode due to a SIGP stop from
>>  CPU 01.
>> 03: HCPGSP2629I The virtual machine is placed in CP mode due to a SIGP stop from
>>  CPU 01.
>> 01: HCPGIR450W CP entered; disabled wait PSW 00020001 80000000 00000000 000164DE
> 
> That should be fixed with this one:
> 
> commit f1ecfd5d3b69d98b814435758c485e6fd0e112de
> Author: Ursula Braun <braunu@de.ibm.com>
> Date:   Mon Oct 22 16:16:14 2007 +0200
> 
>     remove header_ops bug in qeth driver
>     
>     Remove qeth bug caused by commit:
>     [NET]: Move hardware header operations out of netdevice.
>     
>     This is the second part of the qeth header_ops patch, since
>     first patch sent 10/19 has been insufficient.
>     Nevertheless first patch is still valid and should be kept.
>     
>     Signed-off-by: Ursula Braun <braunu@de.ibm.com>
>     Signed-off-by: Jeff Garzik <jeff@garzik.org>
> 
> Patch is in -rc1. Could you please pull and try again? Thanks.

Hi,

The kernel panic is not seen in the 2.6.24-rc1 kernel.

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
