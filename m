Return-Path: <linux-kernel-owner+w=401wt.eu-S1763317AbXLNDrN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763317AbXLNDrN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 22:47:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750929AbXLNDq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 22:46:58 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:41602 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbXLNDq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 22:46:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=jXKhNvD/A7V3mNm1yIjQLwq+pKVw9SHxCBuGZe5RUZIjL9YufmHzPLFudCBPhNhMynKp2/Tew7HvLL0n0ELyT7QAgWiqImwU6YrclI9+eSfM4XJTTAkUl9qf0A80Bgne4ZPcs57NFvxIeXqh7bdV0Fc1hY9szazp9xwPMmNbaKY=
Message-ID: <4761FCAA.7080305@gmail.com>
Date: Fri, 14 Dec 2007 12:46:50 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       Tejun Heo <htejun@gmail.com>
Subject: Re: ATAPI/pata_amd regression
References: <20071212151025.GA21445@moesenspecht.in.y0ur.4ss>
In-Reply-To: <20071212151025.GA21445@moesenspecht.in.y0ur.4ss>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Friedrich Göpel wrote:
> Hi,
> 
> While testing 2.6.24-rc5 I noticed my Plextor DVD writer locking up as
> soon I start k3b (KDE CD burning app) with the following:
> 
>  ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
>  ata5.00: cmd a0/00:00:00:08:00/00:00:00:00:00/a0 tag 0 pio 8 in
>           cdb ac 00 00 00 00 00 00 00  00 01 03 00 00 00 00 00
>           res 58/00:02:00:08:00/00:00:00:00:00/a0 Emask 0x2 (HSM violation)
>  ata5.00: status: { DRDY DRQ }
>  ata5: soft resetting link
>  ata5.00: qc timeout (cmd 0xa1)
>  ata5.00: failed to IDENTIFY (I/O error, err_mask=0x4)
>  ata5.00: revalidation failed (errno=-5)
>  ata5: failed to recover some devices, retrying in 5 secs
>  ata5: port is slow to respond, please be patient (Status 0x80)
>  ata5: device not ready (errno=-16), forcing hardreset
>  ata5: soft resetting link
>  ata5.00: qc timeout (cmd 0xa1)
>  ata5.00: failed to IDENTIFY (I/O error, err_mask=0x4)
>  ata5.00: revalidation failed (errno=-5)
>  ata5: failed to recover some devices, retrying in 5 secs
>  ata5: port is slow to respond, please be patient (Status 0x80)
>  ata5: device not ready (errno=-16), forcing hardreset
>  ata5: soft resetting link
>  ata5.00: qc timeout (cmd 0xa1)
>  ata5.00: failed to IDENTIFY (I/O error, err_mask=0x4)
>  ata5.00: revalidation failed (errno=-5)
>  ata5.00: disabled
>  ata5: port is slow to respond, please be patient (Status 0x80)
>  ata5: device not ready (errno=-16), forcing hardreset
>  ata5: soft resetting link
>  ata5: EH complete
> 
> 
> Whereas doing the same on .23 just yields:
> 
>  ata5.00: 16 bytes trailing data
>  ata5.00: 16 bytes trailing data
>  ata5.00: 16 bytes trailing data
>  ata5.00: 16 bytes trailing data
> 
> 
> On .24 the drive is completely irresponsive afterwards, until I reboot.
> Burning a DVD from a terminal with growisofs works though, if I don't start k3b.

Known problem.  Patches posted.

http://thread.gmane.org/gmane.linux.ide/26215

-- 
tejun
