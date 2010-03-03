Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582Ab0CCSpl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 13:45:41 -0500
Received: from mail-iw0-f182.google.com ([209.85.223.182]:56276 "EHLO
	mail-iw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755416Ab0CCSpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 13:45:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=q11fn01MdKvx0q97hlbOd+DM5sVE7bSvNVsXaVSIYCKusFcyzvUQNMLNP5fhcNVLYE
         5Wn77LWK7Jiy3fkVUuQlGTk389MemuiyW+EJF/ji3mIk5ISnMJ9p0ZHQKLc/itLMrWeO
         yfj+Rh/IBOQwSI60u2PXo04B27eMUvWrlkbPM=
Message-ID: <4B8EAE50.2090800@pobox.com>
Date: Wed, 03 Mar 2010 13:45:36 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Anton Vorontsov <avorontsov@ru.mvista.com>
CC: Sergei Shtylyov <sshtylyov@mvista.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/11] ahci: Get rid of host->iomap usage
References: <20100303171713.GA6322@oksana.dev.rtsoft.ru> <20100303171734.GA12362@oksana.dev.rtsoft.ru>
In-Reply-To: <20100303171734.GA12362@oksana.dev.rtsoft.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2010 12:17 PM, Anton Vorontsov wrote:
> Currently the driver uses host->iomap to store all the iomapped BARs
> of a PCI device (while AHCI devices actually use just a single memory
> window).
>
> We're going to teach AHCI to work with non-PCI buses, so there are two
> options to make this work:
>
> 1. "fake" host->iomap array for non-PCI devices, and place the needed
>     address at iomap[AHCI_PCI_BAR];
> 2. Get rid of host->iomap usage, instead introduce a private mmio
>     field.
>
> This patch implements the second option.
>
> Signed-off-by: Anton Vorontsov<avorontsov@ru.mvista.com>
> ---
>   drivers/ata/ahci.c |   34 ++++++++++++++++++++--------------
>   1 files changed, 20 insertions(+), 14 deletions(-)

Does platform code not contain any devres support?

At a minimum, you should be using devm_ioremap(), yes?

	Jeff



