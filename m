Return-Path: <linux-kernel-owner+w=401wt.eu-S1753136AbYLUJRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136AbYLUJRu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 04:17:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751343AbYLUJRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 04:17:35 -0500
Received: from ti-out-0910.google.com ([209.85.142.189]:31090 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbYLUJRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 04:17:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=r1pHvlEpWuhhBgJ5iaCmHO4YZKsaku2h/H61YZW0JDXtk1p+0nHliwDI0cC6T+xMOH
         r5VDVUXZ/CAA0oKTMRhhiibCvnoxOh9Ffd92fpVP1HMLfrbkX6rLZWGJ+ksgJc1o6UeU
         PR9C+W8QhwU8ixsWY4LNCqtD/HEe3bQgoy5ao=
Date: Sun, 21 Dec 2008 14:46:37 +0530
From: Rabin Vincent <rabin@rab.in>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-sh <linux-sh@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH] sh: maple: add support for Maple controller as a
	joystick
Message-ID: <20081221091637.GA23532@debian>
References: <1229728542.1441.6.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229728542.1441.6.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2008 at 11:15:42PM +0000, Adrian McMenamin wrote:
> Add support for the SEGA Dreamcast Maple controller as a joystick

[snip]

> +
> +	pad = kzalloc(sizeof(struct dc_pad), GFP_KERNEL);
> +	idev = input_allocate_device();
> +	if (!pad || !idev){
> +		error = ENOMEM;
> +		goto fail;
> +	}
> +

[snip]

> +
> +	error = input_register_device(idev);
> +	if (error)
> +		goto fail;
> +
> +	mdev->driver = mdrv;
> +	maple_set_drvdata(mdev, pad);
> +
> +	return error;
> +
> +fail:
> +	input_free_device(pad->dev);
> +	kfree(pad);
> +	maple_set_drvdata(mdev, NULL);
> +	return -error;
> +}

This will incorrectly negate the already negative error code from
input_register_device.

Rabin
