Return-Path: <linux-kernel-owner+w=401wt.eu-S1756699AbZIVO0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699AbZIVO0N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 10:26:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755937AbZIVO0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 10:26:10 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:64286 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755529AbZIVO0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 10:26:09 -0400
To: michael@ellerman.id.au
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6.31] Memory leak in SCSI initialization?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200909221318.IFD17141.OQLtSFJVOOFFMH@I-love.SAKURA.ne.jp>
	<1253625194.5923.10.camel@concordia>
In-Reply-To: <1253625194.5923.10.camel@concordia>
Message-Id: <200909222326.GGB13598.JFVOtQFOMOSLHF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 22 Sep 2009 23:26:08 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Michael Ellerman wrote:
> I think this will fix it:
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 9ce5c34..284bcbe 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -957,7 +957,7 @@ static inline void scsi_destroy_sdev(struct scsi_device *sdev)
>  	if (sdev->host->hostt->slave_destroy)
>  		sdev->host->hostt->slave_destroy(sdev);
>  	transport_destroy_device(&sdev->sdev_gendev);
> -	put_device(&sdev->sdev_gendev);
> +	put_device(&sdev->sdev_dev);
>  }
>  
>  #ifdef CONFIG_SCSI_LOGGING

Yes. This patch solved the memory leak.

Thank you.
