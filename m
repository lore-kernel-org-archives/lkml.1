Return-Path: <linux-kernel-owner+w=401wt.eu-S1753439AbYLTPRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439AbYLTPRR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 10:17:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751946AbYLTPRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 10:17:04 -0500
Received: from cs20.apochromatic.org ([204.152.189.161]:50750 "EHLO
	cs20.apochromatic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719AbYLTPRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 10:17:03 -0500
Date: Sat, 20 Dec 2008 15:16:59 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-sh <linux-sh@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH] sh: maple: add support for Maple controller as a
	joystick
Message-ID: <20081220151511.GA6528@console-pimps.org>
References: <1229728542.1441.6.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229728542.1441.6.camel@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2008 at 11:15:42PM +0000, Adrian McMenamin wrote:
> 
> Add support for the SEGA Dreamcast Maple controller as a joystick
> 

[snip]

> +	struct dc_pad *pad = maple_get_drvdata(mapledev);
> +	struct input_dev *dev = pad->dev;
> +	unsigned char *res = mq->recvbuf;
> +
> +	buttons = ~cpu_to_le16(*(unsigned short *)(res + 8));
> +

I may be wrong but shouldn't this use the I/O accessor functions?

> +
> +	pad = kzalloc(sizeof(struct dc_pad), GFP_KERNEL);
> +	idev = input_allocate_device();
> +	if (!pad || !idev){
> +		error = ENOMEM;
> +		goto fail;
> +	}

[snip]

> +fail:
> +	input_free_device(pad->dev);

Possible NULL pointer dereference?
