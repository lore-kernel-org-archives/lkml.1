Return-Path: <linux-kernel-owner+w=401wt.eu-S1754623AbYKZRSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbYKZRSO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 12:18:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753270AbYKZRR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 12:17:57 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:4825 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753276AbYKZRR4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 12:17:56 -0500
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
Subject: Re: [BUG] linux-2.6.28-rc3 regression: IRQ smp_affinities not
 respected
From: "Michael Chan" <mchan@broadcom.com>
To: "Eric Dumazet" <dada1@cosmosbay.com>
cc: "linux kernel" <linux-kernel@vger.kernel.org>,
       "Linux Netdev List" <netdev@vger.kernel.org>
In-Reply-To: <492D107B.1060303@cosmosbay.com>
References: <C27F8246C663564A84BB7AB343977242151F4B18B5@IRVEXCHCCR01.corp.ad.broadcom.com>
 <491154C8.3040401@cosmosbay.com> <492D107B.1060303@cosmosbay.com>
Date: Wed, 26 Nov 2008 09:14:52 -0800
Message-ID: <1227719692.13189.7.camel@HP1>
MIME-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5)
X-WSS-ID: 65335B3E37G20947090-01-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-11-26 at 01:01 -0800, Eric Dumazet wrote:
> Eric Dumazet a écrit :
> > Michael Chan a écrit :
> >> I believe this may be the patch that broke it:
> >>
> >> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=ce6fce4295ba727b36fdc73040e444bd1aae64cd 
> >>
> >>
> >> I don't remember all the details, but the Broadcom 5708 chip is
> >> affected because it does not support MSI per-vector masking.
> >>
> >> One way to get around is to disable MSI with bnx2 parameter
> >> disable_msi=1.
> >>
> 
> > 
> > I tried this MSI disabling and yes, it now works.
> > 
> > 16:      42726        128        105        106         89         
> > 89        145        152   IO-APIC-fasteoi   uhci_hcd:usb1, eth0, eth1
> > 
> 
> I believe the bnx2 driver doesnt work at all if !disable_msi (default setting)
> 
> Doing a "echo 0 >/sys/devices/system/cpu/cpu1/online" just freeze network
> 
> No messages logged
> 
> If loaded with disable_msi=1, the cpu unplug works as expected.
> 
> Thats a pretty serious issue.
>
Yes, that's the same issue and it is serious.  If MSI is being delivered
to CPU 1 and you then take CPU 1 offline, the MSI will not be delivered
to another CPU.

I think I can detect this problem in bnx2_timer() and try to recover.
I'll post a patch when I have something ready.  Thanks.


