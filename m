Return-Path: <linux-kernel-owner+w=401wt.eu-S1752990AbYKGOiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990AbYKGOiA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 09:38:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751750AbYKGOht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 09:37:49 -0500
Received: from rn-out-0910.google.com ([64.233.170.184]:29900 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbYKGOhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 09:37:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:sender:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references:x-google-sender-auth;
        b=GdweCCDHPGYGnX7mYNCoxCtOoM+OkEirjeqIhxgHKK0oqe+YHK7oAjXB5qbaUjHyTL
         bXkW0Jbwp02cnZjS3OX/JTma0g/snJ9kCBAWictUH4M8A6MmxKExCbYexc1bse1EzkHm
         3K2BYdv1ldlZ1KJf4ZPuoSaF2i1c1UAdAFhaI=
Message-ID: <788014650811070637k723c74d9s176a3afdcd3618bb@mail.gmail.com>
Date: Fri, 7 Nov 2008 22:37:46 +0800
From: "KueiHuan Chen" <khchen@synology.com>
Reply-To: khchen@synology.com
To: "Jeff Garzik" <jgarzik@pobox.com>
Subject: Re: [PATCH] ata: ata_id_is_ssd() bugfix
Cc: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <490694D0.2060804@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200810182222.13281.bzolnier@gmail.com>
	 <20081019180545.GT19428@kernel.dk>
	 <200810192052.47819.bzolnier@gmail.com>
	 <20081019191202.GW19428@kernel.dk> <490694D0.2060804@pobox.com>
X-Google-Sender-Auth: dd900bdf1ce92887
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I had a transcend 32GB SSD. It use ATA8 but lack of support word 217.
So this is not really work for all SSD currently...

Here is the spec of such SSD
http://www.transcend.com.tw/support/dlcenter/datasheet/SSD25S-JMI%20Datasheet%20v1.05.pdf

--
Best Regards,
KueiHuan-Chen

2008/10/28 Jeff Garzik <jgarzik@pobox.com>
>
> It seems highly unlikely that any drive that claims ATA8 would repurpose word 217, therefore upstream logic IMO should look like
>
>        if (id[ATA_ID_ROT_SPEED] == 0x01 &&
>            ((ata_id_major_version(id) >= 8) ||
>             (a list of ATA6/7 exceptions that Jens wishes to supply)))
>
> Regards,
>
>        Jeff
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
