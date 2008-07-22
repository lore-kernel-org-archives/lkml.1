Return-Path: <linux-kernel-owner+w=401wt.eu-S1754501AbYGVWAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501AbYGVWAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 18:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751782AbYGVWAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 18:00:22 -0400
Received: from gate.crashing.org ([63.228.1.57]:49591 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404AbYGVWAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 18:00:22 -0400
Subject: Re: [PATCH 18/79] device create: macintosh: convert device_create
	to device_create_drvdata
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1216703983-21448-18-git-send-email-gregkh@suse.de>
References: <20080722051805.GA17373@suse.de>
	 <1216703983-21448-18-git-send-email-gregkh@suse.de>
Content-Type: text/plain
Date: Wed, 23 Jul 2008 08:00:16 +1000
Message-Id: <1216764016.11027.209.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-21 at 22:18 -0700, Greg Kroah-Hartman wrote:
> device_create() is race-prone, so use the race-free
> device_create_drvdata() instead as device_create() is going away.

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

> ---
>  drivers/macintosh/adb.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/macintosh/adb.c b/drivers/macintosh/adb.c
> index e5d4468..cae5248 100644
> --- a/drivers/macintosh/adb.c
> +++ b/drivers/macintosh/adb.c
> @@ -862,7 +862,8 @@ adbdev_init(void)
>  	adb_dev_class = class_create(THIS_MODULE, "adb");
>  	if (IS_ERR(adb_dev_class))
>  		return;
> -	device_create(adb_dev_class, NULL, MKDEV(ADB_MAJOR, 0), "adb");
> +	device_create_drvdata(adb_dev_class, NULL, MKDEV(ADB_MAJOR, 0), NULL,
> +			      "adb");
>  
>  	platform_device_register(&adb_pfdev);
>  	platform_driver_probe(&adb_pfdrv, adb_dummy_probe);

