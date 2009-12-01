Return-Path: <linux-kernel-owner+w=401wt.eu-S1754134AbZLAAEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbZLAAEM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 19:04:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754066AbZLAAEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 19:04:10 -0500
Received: from ozlabs.org ([203.10.76.45]:60673 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754056AbZLAAEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 19:04:09 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH] virtio: set pci bus master enable bit
Date: Tue, 1 Dec 2009 10:34:01 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-15-generic; KDE/4.3.2; i686; ; )
Cc: Mark McLoughlin <markmc@redhat.com>, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org,
       Anthony Liguori <anthony@codemonkey.ws>, kvm@vger.kernel.org,
       Yan Vugenfirer <yvugenfi@redhat.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
References: <20091129155200.GA6667@redhat.com>
In-Reply-To: <20091129155200.GA6667@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912011034.02251.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Nov 2009 02:22:01 am Michael S. Tsirkin wrote:
> As all virtio devices perform DMA, we
> must enable bus mastering for them to be
> spec compliant.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/virtio/virtio_pci.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
> index 28d9cf7..717bae1 100644
> --- a/drivers/virtio/virtio_pci.c
> +++ b/drivers/virtio/virtio_pci.c
> @@ -648,6 +648,7 @@ static int __devinit virtio_pci_probe(struct pci_dev *pci_dev,
>  		goto out_req_regions;
>  
>  	pci_set_drvdata(pci_dev, vp_dev);
> +	pci_set_master(pci_dev);

I can believe this, but I have no idea if it's right.  I've applied it, and
hope Jesse will comment if there's something wrong with it.

Thanks,
Rusty.
