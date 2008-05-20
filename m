Return-Path: <linux-kernel-owner+w=401wt.eu-S1758714AbYETBuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758714AbYETBuA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 21:50:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754374AbYETBtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 21:49:51 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:8400 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbYETBtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 21:49:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=jtvl5HNEXKWAsnAlzqYSIDScK9dW1/ciRv2T4XdvLFdzoLmw5YPjC/C0z9Mgcz/eg5G+o5MX11Q8WcnxNpftXHt/tINQEmJkUFYT29vhrAplN2KX9b70cQQ4FQUOuRlQ6V5M437uakmKuyM7k8XWYBzOen/7s0HNQelhdmwdhHY=
Date: Mon, 19 May 2008 21:49:37 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Pau Oliva Fora <pau@eslack.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: Re: [PATCH] Add support for HTC Shift Touchscreen
Message-ID: <20080520014937.GA23247@anvil.corenet.prv>
References: <482ED31E.2000009@eslack.org> <483198F8.3000201@eslack.org> <20080519112104.ZZRA012@mailhub.coreip.homeip.net> <4832087C.6060009@eslack.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4832087C.6060009@eslack.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 01:08:44AM +0200, Pau Oliva Fora wrote:
> +
> +static int htcpen_open(struct input_dev *dev)
> +{
> +	outb_p(DEVICE_ENABLE, HTCPEN_PORT_INIT);
> +	return 0;
> +}
> +
> +static void htcpen_close(struct input_dev *dev)
> +{
> +	free_irq(HTCPEN_IRQ, dev);
> +}
> +

No, this will not work.. next time you open the device you won't have
IRQ anymore. You need the opposite of outb_p(DEVICE_ENABLE,
HTCPEN_PORT_INIT); here.


-- 
Dmitry
