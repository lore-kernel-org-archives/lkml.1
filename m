Return-Path: <linux-kernel-owner+w=401wt.eu-S1752133AbXJZK0G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133AbXJZK0G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 06:26:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751077AbXJZKZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 06:25:55 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:64640 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbXJZKZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 06:25:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Yw9bBakC+ywXBE3rg27LzwgDNCZ4c8lkUlw/Gnlk//De98UVLXyMe/AT8rrX0PURnStfuuFkjY4/3uFH/kuOOqhQPFULRlKYj9hsuzQTlbo8/cS9kS5xg+/qC7x3Xvnrlw6QvtdrDM/Pv1Zd8cwNVEZh4ugTalkaqZyXYyErqEk=
Message-ID: <4721C0A6.4000200@gmail.com>
Date: Fri, 26 Oct 2007 19:25:42 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: James.Bottomley@steeleye.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org
Subject: Re: Disk spindown on rmmod sd_mod
References: <Pine.LNX.4.64.0710022050200.28124@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0710022050200.28124@fbirervta.pbzchgretzou.qr>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> I am using 2.6.23-rc9 with pata_sis. `modprobe -r sd_mod`, which I ran 
> from initramfs, caused all my disks to spindown - sd even told me so.
> 
> I recall there has been talk a while back about whether to spin down 
> disks on shutdown or not, but I do not think it touched the removal of 
> sd_mod, did it? So either way, can someone fill me in why the spindown 
> is done?

The problem is that it's difficult to tell why a disk is going down from
sd_shutdown(), so it issues STOP unless system state is SYSTEM_RESTART.
 Maybe we need to issue STOP only for SYSTEM_HALT, SYSTEM_POWER_OFF and
SYSTEM_SUSPEND_DISK.

Thanks.

-- 
tejun
