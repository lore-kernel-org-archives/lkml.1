Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab0CCRgB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 12:36:01 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:34829 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754971Ab0CCRf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 12:35:59 -0500
Message-ID: <4B8E9D7B.6040709@ru.mvista.com>
Date: Wed, 03 Mar 2010 20:33:47 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Anton Vorontsov <avorontsov@ru.mvista.com>
CC: Jeff Garzik <jgarzik@pobox.com>, Sergei Shtylyov <sshtylyov@mvista.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/11] ahci: Move generic code into libahci
References: <20100303171713.GA6322@oksana.dev.rtsoft.ru> <20100303171747.GI12362@oksana.dev.rtsoft.ru>
In-Reply-To: <20100303171747.GI12362@oksana.dev.rtsoft.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Anton Vorontsov wrote:

> This patch should contain no functional changes, just moves code
> around.
>
> Currently libahci.c and ahci.c are built into a single module,
> so there is no need for EXPORT_SYMBOL_GPL()s, yet. Exports will be
> added in a subsequent patch.
>   

   This is not true anymore, so the exports are probably needed.

> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> ---
>  drivers/ata/Makefile  |    2 +-
>  drivers/ata/ahci.c    | 2271 +------------------------------------------------
>  drivers/ata/libahci.c | 2059 ++++++++++++++++++++++++++++++++++++++++++++
>  drivers/ata/libahci.h |  330 +++++++
>  4 files changed, 2391 insertions(+), 2271 deletions(-)
>  create mode 100644 drivers/ata/libahci.c
>  create mode 100644 drivers/ata/libahci.h
>
> diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
> index b7d4923..75e3abd 100644
> --- a/drivers/ata/Makefile
> +++ b/drivers/ata/Makefile
> @@ -1,7 +1,7 @@
>  
>  obj-$(CONFIG_ATA)		+= libata.o
>  
> -obj-$(CONFIG_SATA_AHCI)		+= ahci.o
> +obj-$(CONFIG_SATA_AHCI)		+= libahci.o ahci.o
>   

   This means 2 different modules: libahci.ko and ahci.ko.

MBR, Sergei

