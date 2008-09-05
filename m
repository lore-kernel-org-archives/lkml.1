Return-Path: <linux-kernel-owner+w=401wt.eu-S1753610AbYIESDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610AbYIESDv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 14:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751676AbYIESDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 14:03:42 -0400
Received: from h155.mvista.com ([63.81.120.155]:61907 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751345AbYIESDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 14:03:41 -0400
Message-ID: <48C1749E.6050002@ru.mvista.com>
Date: Fri, 05 Sep 2008 22:04:14 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Masoud Sharbiani <masouds@google.com>
Cc: bzolnier@gmail.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix pointer arithmetic in hpt3xx driver code
References: <20080905174834.GD26371@google.com>
In-Reply-To: <20080905174834.GD26371@google.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masoud Sharbiani wrote:

> Hi there,
> git commit 74811f355f4f69a187fa74892dcf2a684b84ce99 causes crash at
> module load (or boot) time on my machine with a hpt374 controller.
> Sergei says this is due to the pointer arithmatic. This patch fixes that
> and makes my machine boot again.

> Signed-Off-By: Masoud Sharbiani <masouds@google.com>

> diff --git a/drivers/ide/pci/hpt366.c b/drivers/ide/pci/hpt366.c
> index eb107ee..f41f3fd 100644
> --- a/drivers/ide/pci/hpt366.c
> +++ b/drivers/ide/pci/hpt366.c
> @@ -613,6 +613,14 @@ static int check_in_drive_list(ide_drive_t *drive, const char **list)
>  	return 0;
>  }

> +static struct hpt_info *hpt3xx_get_info(void *host_priv, struct device *hwif_dev, struct device *host_dev)

    Ugh, that's oversimplified and doesn't save much...
    I rather meant the following prototype:

static struct hpt_info *hpt3xx_get_info(struct pci_dev *dev)

In case it'll be too complex for you, I'll do it myself later.

> +{
> +	struct hpt_info *info = (struct hpt_info *)host_priv;

    Newline needed after the declaration block.

> +	if (hwif_dev == host_dev)
		return info + 1;
	else
		return info;

or

	return hwif_dev == host_dev ? info + 1 : info;

