Return-Path: <linux-kernel-owner+w=401wt.eu-S1760604AbYHUWXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760604AbYHUWXv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 18:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757602AbYHUWXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 18:23:43 -0400
Received: from outbound-mail-116.bluehost.com ([69.89.22.16]:53902 "HELO
	outbound-mail-116.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756787AbYHUWXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 18:23:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=coJCXAKHBKl6bky+c8VKil8NWs4XY35499r+8Pm8YHE9o0Hy4OUI2IUm+UVNpIwoYSRMW/9salq8Qc3CN6XvNWfAxwYsU2NvVVThG5JCUmnk2RwHEW1ZyobFW6lZIbdd;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Greg KH <gregkh@suse.de>
Subject: Re: refcount leak in pci_get_device()?
Date: Thu, 21 Aug 2008 15:23:35 -0700
User-Agent: KMail/1.9.9
Cc: Matthew Wilcox <matthew@wil.cx>, Alex Chiang <achiang@hp.com>,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080821201918.GA24411@ldl.fc.hp.com> <20080821202504.GU8318@parisc-linux.org> <20080821204758.GB31543@suse.de>
In-Reply-To: <20080821204758.GB31543@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808211523.35556.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 21, 2008 1:47 pm Greg KH wrote:
> Subject: PCI: fix reference leak in pci_get_dev_by_id()
>
> From: Greg Kroah-Hartman <gregkh@suse.de>
>
> Alex Chiang and Matthew Wilcox pointed out that pci_get_dev_by_id() does
> not properly decrement the reference on the from pointer if it is
> present, like the documentation for the function states it will.
>
> Cc: Matthew Wilcox <matthew@wil.cx>
> Cc: Alex Chiang <achiang@hp.com>
> Cc: stable <stable@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>
>
> diff --git a/drivers/pci/search.c b/drivers/pci/search.c
> index 217814f..3b3b5f1 100644
> --- a/drivers/pci/search.c
> +++ b/drivers/pci/search.c
> @@ -280,6 +280,8 @@ static struct pci_dev *pci_get_dev_by_id(const struct
> pci_device_id *id, match_pci_dev_by_id);
>  	if (dev)
>  		pdev = to_pci_dev(dev);
> +	if (from)
> +		pci_dev_put(from);
>  	return pdev;
>  }

Wow, thanks Greg, that was fast.  I applied this to my for-linus branch; I'll 
ask Linus to pull it for 2.6.27.

Thanks,
--
Jesse Barnes, Intel Open Source Technology Center
