Return-Path: <linux-kernel-owner+w=401wt.eu-S1755225AbYJXSnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225AbYJXSnv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 14:43:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753776AbYJXSnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 14:43:40 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:16552 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669AbYJXSnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 14:43:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=DB7p8GJQ3YH38TTF1zjp2WaW8+Ky95Fw9eDYgwQUodMfJlSEEPUx7vL0B+hVj3L7El
         2+DCYgee3bHJKWx1aAyexvLS6HOAjsHtS5aoYI/qmksFOqJqKOkC7H9+bfJ5D3MoMUdY
         Z71kkOjRFzV1UrVTp1FS0Nzdgol6T5vsW4MhM=
Message-ID: <8db1092f0810241143l1e5c3ea8g2587a2db452c3b9e@mail.gmail.com>
Date: Fri, 24 Oct 2008 20:43:37 +0200
From: "Maciej Rutecki" <maciej.rutecki@gmail.com>
To: "James Bottomley" <James.Bottomley@hansenpartnership.com>
Subject: Re: [Re: Linux 2.6.28-rc1] scsi 4:0:0:0: timing out command, waited 22s
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org,
       "SCSI development list" <linux-scsi@vger.kernel.org>
In-Reply-To: <1224871587.3307.19.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8db1092f0810241057j51f0b70eo3cea4499422f0d38@mail.gmail.com>
	 <1224871587.3307.19.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for quick response. I added patch, and DVD works OK.

Tested-by: Maciej Rutecki <maciej.rutecki@gmail.com>

> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index d5b9b72..4b95c43 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -708,7 +708,11 @@ static struct ata_queued_cmd *ata_scsi_qc_new(struct ata_device *dev,
>  {
>        struct ata_queued_cmd *qc;
>
> -       qc = ata_qc_new_init(dev, cmd->request->tag);
> +       if (cmd->request->tag != -1)
> +               qc = ata_qc_new_init(dev, cmd->request->tag);
> +       else
> +               qc = ata_qc_new_init(dev, 0);
> +
>        if (qc) {
>                qc->scsicmd = cmd;
>                qc->scsidone = done;
>
>
>


Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
