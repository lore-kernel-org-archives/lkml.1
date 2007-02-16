Return-Path: <linux-kernel-owner+w=401wt.eu-S1945910AbXBPPPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945910AbXBPPPP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 10:15:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945911AbXBPPPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 10:15:14 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:20182 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945910AbXBPPPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 10:15:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sTcsEPH8tRKlXT9b64ohViGYf85aegYzihN+taOh8WpVGpcDo6MibPiN8MiIPP1+YUJ9WzLqihI9uToMKysvaq1d0KLRWs7GSK4XIBY1W2jy3nSrPHUfdf5BHzjGatPxbrgKplrR0k7EhSWPftMXL4M4V2a7EUd1i6yFTyzy5pc=
Message-ID: <d120d5000702160715x6f64853y59abb8a22e7d164c@mail.gmail.com>
Date: Fri, 16 Feb 2007 10:15:11 -0500
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Yoichi Yuasa" <yoichi_yuasa@tripeaks.co.jp>
Subject: Re: [PATCH] Add Cobalt button interface driver support
Cc: linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
In-Reply-To: <200702160815.l1G8FEIr078415@mbox33.po.2iij.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070216123608.733f04a3.yoichi_yuasa@tripeaks.co.jp>
	 <200702152309.44563.dtor@insightbb.com>
	 <200702160815.l1G8FEIr078415@mbox33.po.2iij.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/16/07, Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp> wrote:
> +
> +static int cobalt_buttons_open(struct inode *inode, struct file *file)
> +{
> +       buttons_timer.expires = jiffies + msecs_to_jiffies(BUTTONS_POLL_INTERVAL);
> +       add_timer(&buttons_timer);
> +
> +       return nonseekable_open(inode, file);
> +
> +}

Hi,

I am sorry, I was not clear enough - when I was talking about adding
cobalt_buttons_open/close I was not asking you to add a misc device to
the driver. I was talking about setting up open() and close() methods
in input_dev structure. These methods are called by input core when
first (or last) user opens or closes one of input interfaces, such as
/dev/input/eventX, /dev/input/jsX, etc and so it is naturally to
start/stop polling device from these functions.

Does this make sense?

-- 
Dmitry
