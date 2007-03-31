Return-Path: <linux-kernel-owner+w=401wt.eu-S965085AbXCaDgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965085AbXCaDgM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 23:36:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965084AbXCaDgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 23:36:12 -0400
Received: from wr-out-0506.google.com ([64.233.184.235]:30351 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965085AbXCaDgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 23:36:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=j5wF5KhrfUlpRPCnWnDMcB60AGtJ/KJarQHn35hyDL9eHjn34ssA5gCsAKoq0UIs7EhNvVY3mFEfo05YzR3/w6YRLYjDOoIc9JWk6zQkhh1skzJRcgtcSjtr1VSeEe0JSRtE1t4emEObslqdDd+vDCCBA+qLWKI78fS6bg0P6Rw=
Message-ID: <460DD725.1040607@gmail.com>
Date: Sat, 31 Mar 2007 12:36:05 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Mark Lord <mlord@pobox.com>
CC: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: libata bugfix: preserve LBA bit for HDIO_DRIVE_TASK
References: <20070330205938.984247529@mini.kroah.org> <20070330210659.GK29450@kroah.com> <460D8510.1050102@pobox.com>
In-Reply-To: <460D8510.1050102@pobox.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Ideally, this would go into linux-2.6.21.
> 
> Preserve the LBA bit in the DevSel/Head register for HDIO_DRIVE_TASK.
> 
> Signed-off-by:  Mark Lord <mlord@pobox.com>
> ---
> --- linux/drivers/ata/libata-scsi.c.orig    2007-03-21
> 13:35:02.000000000 -0400
> +++ linux/drivers/ata/libata-scsi.c    2007-03-30 17:40:58.000000000 -0400
> @@ -333,7 +333,7 @@
>     scsi_cmd[8]  = args[3];
>     scsi_cmd[10] = args[4];
>     scsi_cmd[12] = args[5];
> -    scsi_cmd[13] = args[6] & 0x0f;
> +    scsi_cmd[13] = args[6] & 0x4f;
>     scsi_cmd[14] = args[0];
> 
>     /* Good values for timeout and retries?  Values below

IDE seems to be just overriding devsel (0x10) and leaving the rest
alone.  Maybe we should do (args[6] & ~0x10) here?  Or is it safer this way?

Thanks.

-- 
tejun
