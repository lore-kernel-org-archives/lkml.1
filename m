Return-Path: <linux-kernel-owner+w=401wt.eu-S1757398AbYE0Ozb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757398AbYE0Ozb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 10:55:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756228AbYE0OzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 10:55:16 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:35472 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756235AbYE0OzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 10:55:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=HRVIX/eXesGIVCi8RhHgvxfWhnnTG6PdrCEc1BJZMbmJ7KT5zgKvbrslDpY+/3d/YWYwYaMj3K+tFjeYflAjQXmbWKEZv19c/BG3O36tSL0pGplQSLPU/1RBuUAnISCv0zMPIMavhsFosEP8HmCMcLyc3kFKLjyjjpRHpE7sFjg=
Date: Tue, 27 May 2008 10:55:06 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Pau Oliva Fora (pof)" <pau@eslack.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-input@vger.kernel.org
Subject: Re: [PATCH resend] HTC Shift Touchscreen Driver
Message-ID: <20080527105118.ZZRA012@mailhub.coreip.homeip.net>
References: <20080527144603.GA18796@s0.pofhq.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080527144603.GA18796@s0.pofhq.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pau,

I have couple more comments...

On Tue, May 27, 2008 at 04:46:03PM +0200, Pau Oliva Fora (pof) wrote:
> +
> +static void htcpen_close(struct input_dev *dev)
> +{
> +	free_irq(HTCPEN_IRQ, dev);

No, free_irq() should go into htcpen_remove(). Otherwise if we don't
unload the driver and open the device again we will not have IRQ
handler installed.

> +	outb_p(DEVICE_DISABLE, HTCPEN_PORT_INIT);
> +}
> +
> +static int __devinit htcpen_isa_probe(struct device *dev, unsigned int id)
> +{
> +	int err;
> +	struct input_dev *htcpen_dev;
> +
> +	inb_p(HTCPEN_PORT_IRQ_CLEAR);

You should not touch the ports until you resetved them with request
region.

-- 
Dmitry
