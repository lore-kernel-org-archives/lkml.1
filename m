Return-Path: <linux-kernel-owner+w=401wt.eu-S1753896AbYLPSdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896AbYLPSdu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 13:33:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751473AbYLPSdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 13:33:40 -0500
Received: from outbound-mail-28.bluehost.com ([69.89.17.198]:52752 "HELO
	outbound-mail-28.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750998AbYLPSdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 13:33:39 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=VpHFqdddX+0ZZ0YjjrPplDE946U+TUvrUF+GHA6KasMMmoJt2rk/h7bqrXlS3r0zU+ugS4Rm/b4hty5B6bZOh/NFreCVE2zaAKEqEhIOfKmoXC3CK+oiSTBDpOIc+dz1;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH] aerdrv: fix sanity check in report_resume
Date: Tue, 16 Dec 2008 10:31:50 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.27.5-41.fc9.x86_64; KDE/4.1.2; x86_64; ; )
Cc: linux-pci@vger.kernel.org, tom.l.nguyen@intel.com, yanmin.zhang@intel.com,
       linux-kernel@vger.kernel.org
References: <493392BA.50906@jp.fujitsu.com>
In-Reply-To: <493392BA.50906@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812161031.50552.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, November 30, 2008 11:31 pm Hidetoshi Seto wrote:
> What we have to check here before calling it is err_handler->resume.
> It seems that this block have been copy&pasted from report_slot_reset.
>
> Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> ---
>  drivers/pci/pcie/aer/aerdrv_core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/pci/pcie/aer/aerdrv_core.c
> b/drivers/pci/pcie/aer/aerdrv_core.c index dfc63d0..aac7006 100644
> --- a/drivers/pci/pcie/aer/aerdrv_core.c
> +++ b/drivers/pci/pcie/aer/aerdrv_core.c
> @@ -252,7 +252,7 @@ static void report_resume(struct pci_dev *dev, void
> *data)
>
>  	if (!dev->driver ||
>  		!dev->driver->err_handler ||
> -		!dev->driver->err_handler->slot_reset)
> +		!dev->driver->err_handler->resume)
>  		return;
>
>  	err_handler = dev->driver->err_handler;

Applied this to my for-linus branch with Yanmin's ack, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center

