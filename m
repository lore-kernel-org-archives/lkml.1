Return-Path: <linux-kernel-owner+w=401wt.eu-S1754768Ab0AYTWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab0AYTWL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 14:22:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754698Ab0AYTWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 14:22:10 -0500
Received: from outbound-mail-01.bluehost.com ([69.89.21.11]:43887 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753140Ab0AYTWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 14:22:09 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=e13lQOwNdU5QRcNyl9aHwpgvm3EYH+isCFtny/1JOqmA0Q5E8I1MI3HKdPHQb08nV2HIA8MlUvHcAfI6xEmN8nyzU2VQvpEudNgzODVGxiMQfCfQY3COZhEstIIt9vxz;
Date: Mon, 25 Jan 2010 11:21:56 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Scott Murray <scott@spiteful.org>, linux-pci@vger.kernel.org
Subject: Re: [PATCH 1/1] PCI: hotplug/cpcihp, fix pci device refcounting
Message-ID: <20100125112156.7daa3bc2@jbarnes-piketon>
In-Reply-To: <1263993354-23066-1-git-send-email-jslaby@suse.cz>
References: <1263993354-23066-1-git-send-email-jslaby@suse.cz>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jan 2010 14:15:54 +0100
Jiri Slaby <jslaby@suse.cz> wrote:

> Stanse found an ommitted pci_dev_put on one error path in
> cpcihp_generic_init. The path is taken on !dev, but also when
> dev->hdr_type != PCI_HEADER_TYPE_BRIDGE. However it omits to
> pci_dev_put on the latter.
> 
> As it is fine to pass NULL to pci_dev_put, put it in there
> uncoditionally.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Scott Murray <scott@spiteful.org>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> Cc: linux-pci@vger.kernel.org
> ---
>  drivers/pci/hotplug/cpcihp_generic.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/pci/hotplug/cpcihp_generic.c
> b/drivers/pci/hotplug/cpcihp_generic.c index 148fb46..fb3f846 100644
> --- a/drivers/pci/hotplug/cpcihp_generic.c
> +++ b/drivers/pci/hotplug/cpcihp_generic.c
> @@ -162,6 +162,7 @@ static int __init cpcihp_generic_init(void)
>  	dev = pci_get_slot(bus, PCI_DEVFN(bridge_slot, 0));
>  	if(!dev || dev->hdr_type != PCI_HEADER_TYPE_BRIDGE) {
>  		err("Invalid bridge device %s", bridge);
> +		pci_dev_put(dev);
>  		return -EINVAL;
>  	}
>  	bus = dev->subordinate;

Applied to linux-next, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
