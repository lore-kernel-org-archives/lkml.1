Return-Path: <linux-kernel-owner+w=401wt.eu-S1759276AbXJCS0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759276AbXJCS0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 14:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758125AbXJCS0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 14:26:07 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:43827 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758072AbXJCS0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 14:26:06 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Roland Dreier <roland@digitalvampire.org>
Cc: Greg KH <greg@kroah.com>, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org
Subject: Re: MSI: Use correct data offset for 32-bit MSI in read_msi_msg()
References: <87abr0oyj4.fsf@shaolin.home.digitalvampire.org>
Date: Wed, 03 Oct 2007 12:25:36 -0600
In-Reply-To: <87abr0oyj4.fsf@shaolin.home.digitalvampire.org> (Roland Dreier's
	message of "Wed, 03 Oct 2007 11:15:11 -0700")
Message-ID: <m1ir5ocaxr.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier <roland@digitalvampire.org> writes:

> While reading the MSI code trying to find a reason why MSI wouldn't
> work for devices that have a 32-bit MSI address capability, I noticed
> that read_msi_msg() seems to read the message data from the wrong
> offset in this case.

Doh!  Sorry about that.

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
> Signed-off-by: Roland Dreier <roland@digitalvampire.org>
> ---
> Unfortunately MSI still doesn't seem to work with Intel 945GM
> integrated graphics on my laptop, even with this fix....
>
>  drivers/pci/msi.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
> index be1df85..87e0161 100644
> --- a/drivers/pci/msi.c
> +++ b/drivers/pci/msi.c
> @@ -132,7 +132,7 @@ void read_msi_msg(unsigned int irq, struct msi_msg *msg)
>  			pci_read_config_word(dev, msi_data_reg(pos, 1), &data);
>  		} else {
>  			msg->address_hi = 0;
> -			pci_read_config_word(dev, msi_data_reg(pos, 1), &data);
> +			pci_read_config_word(dev, msi_data_reg(pos, 0), &data);
>  		}
>  		msg->data = data;
>  		break;
