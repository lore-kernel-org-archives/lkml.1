Return-Path: <linux-kernel-owner+w=401wt.eu-S1756135AbZBFAp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135AbZBFAp1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 19:45:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753588AbZBFApK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 19:45:10 -0500
Received: from an-out-0708.google.com ([209.85.132.247]:35394 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491AbZBFApI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 19:45:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:newsgroups:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=Abm1/ka6LwDvUp4WQ4txVY1X2VaNNR/uFcFjz9+0AZBusi8yo4oTxTaNSHCM/YQYAz
         QwHcWUDRUwwd8VOmzzwBdSjSZpdqd4D2hZKxRhURsOb6msOHci1fPDrIvZftju+fiwRC
         jGThVrfxwNcDvffDgpGtrZ8gcFp/8LmU8gw5Q=
Message-ID: <498B880E.6070001@gmail.com>
Date: Thu, 05 Feb 2009 18:45:02 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
Newsgroups: gmane.linux.ide,gmane.linux.kernel
To: =?ISO-8859-1?Q?Pasi_K=E4rkk=E4inen?= <pasik@iki.fi>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Suggestions for debugging ata_piix and ahci driver failures on
 Xen pv_ops dom0 kernel (2.6.29-rcX)
References: <20090205082843.GD15052@edu.joroinen.fi>
In-Reply-To: <20090205082843.GD15052@edu.joroinen.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pasi Kärkkäinen wrote:
> Hello!
> 
> I'm trying to figure out what's wrong with the pv_ops dom0 kernel/patches [1]
> causing at least ata_piix and ahci drivers to fail to work.
> 
> There was legacy IRQ enabling problem earlier with the pv_ops dom0 patches, 
> which pretty much prevented the disks from being detected.. but that got fixed. 
> It could still be something related to Xen/dom0 irq handling.. 
> 
> I'd be glad if someone could take a look at this 2.6.29-rc3-tip pv_ops dom0 kernel boot log
> and comment about _possible_ causes for such behaviour of ata_piix and ahci:
> 
> http://pasik.reaktio.net/xen/pv_ops-dom0-debug/pv_ops-dom0-bootlog-11-xen331-linux-2.6.29-rc3-atadebug3.txt
> 
> In that testing box I have just one IDE hdd attached to ata_piix controller, the AHCI controller doesn't
> have any disks attached.
> 
> The exact same kernel works OK without problems on baremetal without Xen
> hypervisor. 

Seems like me like ata_piix is not receiving any interrupts.. the 
polling-based IDENTIFY and SET FEATURES work, but the READ NATIVE MAX 
ADDRESS times out and so does the READ DMA that gets tried next.

Note that the ata_piix controller is in legacy mode, not native mode, so 
it's using IRQ 14 and 15, not whatever the hardware may otherwise 
indicate. Could be the problem is related to that.
