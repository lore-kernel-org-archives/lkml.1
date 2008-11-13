Return-Path: <linux-kernel-owner+w=401wt.eu-S1753996AbYKMOS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996AbYKMOS0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 09:18:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751530AbYKMOSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 09:18:17 -0500
Received: from yw-out-2324.google.com ([74.125.46.29]:44825 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbYKMOSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 09:18:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=FKecIp+99tUYcK+UEk6awbkWf5XLmEyagmozo6m2Q+ub6BMg/B3QnTSRiz31a/qtgD
         PPC2zrnkUvikS7lykvhDq6mlNnJq0a2Mfo3NgG3tdF3YfkOzEsUKcnBJKY7k3ebMm8Qd
         6apv+b/lYMNr314EsFfIz9sNnfmwq5dgoCFLw=
Message-ID: <b637ec0b0811130618o2f76e34bh17055f2f165d89a5@mail.gmail.com>
Date: Thu, 13 Nov 2008 15:18:15 +0100
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Bernhard Walle" <bwalle@suse.de>
Subject: Re: [PATCH] Allow SCSI_WAIT_SCAN to be deselected
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1226585472-12559-1-git-send-email-bwalle@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1226585472-12559-1-git-send-email-bwalle@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So I'm not the only one :-)
Please see this thread:

http://lkml.org/lkml/2008/10/22/355



On Thu, Nov 13, 2008 at 3:11 PM, Bernhard Walle <bwalle@suse.de> wrote:
> This patch adds a proper help for SCSI_WAIT_SCAN and allows the module to be
> deselected. I see no reason to force it being build. It also makes it
> impossible to compile-in the module.
>
>
> Signed-off-by: Bernhard Walle <bwalle@suse.de>
> ---
>  drivers/scsi/Kconfig |   11 ++++++++---
>  1 files changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 403ecad..42b8355 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -257,10 +257,15 @@ config SCSI_SCAN_ASYNC
>          or async on the kernel's command line.
>
>  config SCSI_WAIT_SCAN
> -       tristate
> +       tristate "Module to wait until all the async scans are complete"
>        default m
> -       depends on SCSI
> -       depends on MODULES
> +       depends on SCSI && m
> +    help
> +      This is a simple module to wait until all the async scans are
> +      complete.  The idea is to use it in initrd/initramfs scripts.  You
> +      modprobe it after all the modprobes of the root SCSI drivers and it
> +      will wait until they have all finished scanning their busses before
> +      allowing the boot to proceed
>
>  menu "SCSI Transports"
>        depends on SCSI
> --
> 1.6.0.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
