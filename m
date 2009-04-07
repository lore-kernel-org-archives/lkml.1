Return-Path: <linux-kernel-owner+w=401wt.eu-S1755397AbZDGCMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397AbZDGCMp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 22:12:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752162AbZDGCMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 22:12:36 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:6686 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbZDGCMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 22:12:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:newsgroups:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=L4PUYuV6OnNjyPZ+YSrX4R1f3s5vS9u2MlmfTnareIYtdeUPkg3iNszGyM70PzLHFD
         FFJXG3/bnJeQXDybvcBBFzRSgPTlGT1r5VUSc4zmH2FrLwCaLem61ffiGWVa5FjCq/fG
         ipdqeDvnrcXEihytv5/RGYpzP2hCxA8/+mLS0=
Message-ID: <49DAB689.30801@gmail.com>
Date: Mon, 06 Apr 2009 20:12:25 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: l.genoni@oltrelinux.com
CC: jgarzik@pobox.com, linux-kernel@vger.kernel.org
Subject: Re: nvida sata controller CK804  and  NCQ not working on linux-2.6.28||29.1
References: <Pine.LNX.4.64.0904061458540.3110@Phoenix.oltrelinux.com>
In-Reply-To: <Pine.LNX.4.64.0904061458540.3110@Phoenix.oltrelinux.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

l.genoni@oltrelinux.com wrote:
> 
> Hi,
> to make NCQ work with nvidia sata CK804 I had to introduce this simple 
> change into sata-nv.c. Is there some reason I am missing why adma_enable 
> is not by default one, so later in the dome NCQ is not enabled?

It's had some problems with certain hotplug scenarios and seemingly 
others (like command timeouts) with different systems/drives. I use it 
on my system and it seems to work fine, but others have had some issues.

NVIDIA won't release any public register specs for this controller (the 
support there now was based on a partially finished version they 
released), and haven't been very helpful with debugging. I suspect some 
of the issues with it are related to hardware errata/bugs, which may 
partially explain their silence. There definitely are hardware bugs in 
this controller - just connect a SATA optical drive to it and try to 
read a scratched DVD with read errors. Even under Windows, with either 
NVIDIA's driver or the default Microsoft IDE driver, it'll usually 
either hardlock or machine-check blue screen the system. (It's known 
that the ATAPI part of ADMA is busted and unusable, but this happens 
with or without it enabled.)

> 
> 
> 
> --- linux/drivers/ata/sata_nv.c.old     2009-04-06 14:56:19.000000000 +0200
> +++ linux/drivers/ata/sata_nv.c 2009-04-06 14:56:24.000000000 +0200
> @@ -577,7 +577,7 @@
>  MODULE_DEVICE_TABLE(pci, nv_pci_tbl);
>  MODULE_VERSION(DRV_VERSION);
> 
> -static int adma_enabled;
> +static int adma_enabled = 1;
>  static int swncq_enabled = 1;
> 
>  static void nv_adma_register_mode(struct ata_port *ap)
> 
> regards
> 
> Luigi Genoni

