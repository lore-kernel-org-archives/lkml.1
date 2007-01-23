Return-Path: <linux-kernel-owner+w=401wt.eu-S933063AbXAWGUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933063AbXAWGUN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 01:20:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933073AbXAWGUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 01:20:13 -0500
Received: from nz-out-0506.google.com ([64.233.162.224]:3147 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933063AbXAWGUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 01:20:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=lTM+EMY9gSDOoJnUokiFRtFsVDNelGzxZUt0zIzood1dR8UQbzA4tMZshTreLnQPRX4g/7K5uR35OViYTEivgoTI0rCcsi9XG4ReO4IXR9wB8trk9wWoly032zpkiNGpYKcTHhI8tZnmMu5V0GdofUlGkQ3c7H383mx0GYthflE=
Message-ID: <45B5A901.5050309@gmail.com>
Date: Tue, 23 Jan 2007 15:19:45 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Soeren Sonnenburg <kernel@nn7.de>
CC: Jeff Garzik <jeff@garzik.org>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: SATA hotplug from the user side ?
References: <1168588629.5403.7.camel@localhost>	 <45A7BFB0.9090308@garzik.org> <1168639639.3707.6.camel@localhost>	 <45A83C22.6050409@gmail.com> <1168672966.3707.24.camel@localhost>	 <45AAE52B.2070705@gmail.com> <1169456682.2901.18.camel@localhost>
In-Reply-To: <1169456682.2901.18.camel@localhost>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Soeren Sonnenburg wrote:
> OK, how about this (please especially check the non SIL part):
> 
> SATA Hotplug from the User Side
> 
> - For SIL3114 and SIL3124 you don't have to run any commands at all. It

ahci and ck804 flavor of sata_nv's can do hotplug without user
assistance too.

[--snip--]
> - For other chipsets one in addition to stop using the device before
> unplugging has to call scsiadd -r to fully remove it, e.g. in the
> following example the disk on scsi host 3 channel 0 id 0 lun 0 will be
> removed, then on reinserting a disk call scsiadd -s :
> 
> # scsiadd -p
> 
> Attached devices:
> Host: scsi2 Channel: 00 Id: 00 Lun: 00
>   Vendor: ATA      Model: ST3400832AS      Rev: 3.01
>   Type:   Direct-Access                    ANSI SCSI revision: 05
> Host: scsi3 Channel: 00 Id: 00 Lun: 00
>   Vendor: ATA      Model: ST3400620AS      Rev: 3.AA
>   Type:   Direct-Access                    ANSI SCSI revision: 05
> 
> # scsiadd -r 3 0 0 0
> # scsiadd -s

Doing the above might not be such a good idea on drivers which don't
implement new EH yet.  Those are sata_mv, sata_promise (getting there)
and sata_sx4.

Thanks.

-- 
tejun
