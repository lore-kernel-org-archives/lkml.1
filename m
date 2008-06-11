Return-Path: <linux-kernel-owner+w=401wt.eu-S932363AbYFKSKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932363AbYFKSKY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 14:10:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764731AbYFKSKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 14:10:09 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:55808 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932328AbYFKSKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 14:10:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=GL5wjNX9aJLcSMR04fKY6Rr5u8pJQdB0/RZ8h+HnM6TgNb45jhKzaISmfc1UvmQymA
         +J3encSxGqfH2wWQu+KtFmblWJRf6qxKuzz3oy6XR5oXIVBu+CTv95ztnvHCcxJTOIOz
         r8OkL4CO6Y7kXOkwKVZTJzCtPIUQOPoIme42U=
Message-ID: <485014B5.7080305@gmail.com>
Date: Wed, 11 Jun 2008 20:08:53 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: pnp changes -> suspend oops [Was: 2.6.26-rc5-mm2]
References: <20080609223145.5c9a2878.akpm@linux-foundation.org>
In-Reply-To: <20080609223145.5c9a2878.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2008 07:31 AM, Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.26-rc5/2.6.26-rc5-mm2/

Hi,

I face problems after some of the pnp changes. If this is not known, I may 
bisect it, it's 100% reproducible. I have no real logs, It panics prior to 
network is woken up to see something on netconsole, I just captured a function 
name and an offset of place where it oopses.

pnpacpi_encode_resources, ACPI_RESOURCE_TYPE_DMA case, pnp_get_resource(dev, 
IORESOURCE_DMA, dma) returns NULL, which is dereferenced at pnpacpi_encode_dma 
at p->flags.

It happens on resume after mem > /sys/power/state.
