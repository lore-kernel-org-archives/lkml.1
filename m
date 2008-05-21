Return-Path: <linux-kernel-owner+w=401wt.eu-S934504AbYEUOa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934504AbYEUOa3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 10:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756525AbYEUOaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 10:30:20 -0400
Received: from h155.mvista.com ([63.81.120.155]:10396 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755429AbYEUOaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 10:30:19 -0400
Message-ID: <483431E4.7020307@ru.mvista.com>
Date: Wed, 21 May 2008 18:29:56 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/22] ide: add ide_deprecated_find_port() helper
References: <20080116232556.9166.13457.sendpatchset@localhost.localdomain> <20080116232624.9166.73929.sendpatchset@localhost.localdomain>
In-Reply-To: <20080116232624.9166.73929.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

> * Factor out code for finding ide_hwifs[] slot from ide_register_hw()
>   to ide_deprecated_find_port().

> * Convert bast-ide, ide-cs and delkin_cb host drivers to use ide_device_add()
>   instead of ide_register_hw() (while at it drop doing "ide_unregister()" loop
>   which tries to unregister _all_ IDE interfaces if useable ide_hwifs[] slot
>   cannot be find).

    Er... this patch didn't actually drop that loop (late remark :-).

> This patch leaves us with only two ide_register_hw() users:
> - drivers/macintosh/mediabay.c
> - drivers/ide/ide.c

    I wonder whether ide_register_hw() was much good at all since it didn't 
actually permit to register chips using MMIO: you couldn't pass that info via 
'hw' and it set 'hwif->noprobe' to 0, thus giving you no chance to skip 
probing which wouldn't work anyway; for the same reason it was no good for DMA 
capable chips since you had not time to install ide_dma_check() and other DMA 
methods. Am I right here?

MBR, Sergei
