Return-Path: <linux-kernel-owner+w=401wt.eu-S1753281AbYLSTin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281AbYLSTin (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 14:38:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751685AbYLSTie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 14:38:34 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:53001 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbYLSTid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 14:38:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=EUQyxKSK5nJJTnBJRw/2kHtI+JT3VxnErW/k8Flu9ZO0DF7ubsFdJ34q6dxjmHRMoG
         dn4yNsolc6YVUzC6vuz1d4+sIEZhUN+XqZZ95UkLwU0p0dGI9Xr+czfeJbIjJMlYP/US
         oY9FMlYl5JHBowT3czI69pW+2l4WjDqbGjI7s=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Mario Schwalbe <schwalbe@inf.tu-dresden.de>
Subject: Re: [PATCH] ide: Fix drive's DWORD-IO handling
Date: Fri, 19 Dec 2008 20:01:50 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rc8-next-20081219; KDE/4.1.3; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>
References: <494A5BC9.7000605@inf.tu-dresden.de>
In-Reply-To: <494A5BC9.7000605@inf.tu-dresden.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200812192001.51335.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 December 2008, Mario Schwalbe wrote:
> Resubmitted on request.
> 
> According the documentation, id[ATA_ID_DWORD_IO] is non-zero if
> the drive supports dword IO, while the code disables support by
> setting IDE_DFLAG_NO_IO_32BIT. In addition, this word has been
> reused by the ATA8 specification. This patch fixes both cases.
> 
> Signed-off-by: Mario Schwalbe <schwalbe@inf.tu-dresden.de>
> ---
>  drivers/ide/ide-probe.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
> index c55bdbd..859b0e5 100644
> --- a/drivers/ide/ide-probe.c
> +++ b/drivers/ide/ide-probe.c
> @@ -856,7 +856,7 @@ static void ide_port_tune_devices(ide_hwif_t *hwif)
>  		ide_drive_t *drive = &hwif->drives[unit];
> 
>  		if ((hwif->host_flags & IDE_HFLAG_NO_IO_32BIT) ||
> -		    drive->id[ATA_ID_DWORD_IO])
> +		    !ata_id_has_dword_io(drive->id))
>  			drive->dev_flags |= IDE_DFLAG_NO_IO_32BIT;
>  		else
>  			drive->dev_flags &= ~IDE_DFLAG_NO_IO_32BIT;

Since it seems that libata developers need more time to fully analyze
issues with ata_id_has_dword_io() and I don't want to delay this fix
because if it could you please modify the patch according to Sergei's
suggestion of removing id[ATA_ID_DWORD_IO] check altogether?

[ It is a safe thing to do since the old code has been enabling 32-bit
  I/O _unless_ the ATA-1 dword I/O bit for VU compatibility was set... ]

Thanks,
Bart
