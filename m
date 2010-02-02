Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568Ab0BBPl4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 10:41:56 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:44937 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756355Ab0BBPlw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 10:41:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=eMZJzeQQuxBBMukNUyEK3fY2QV5AvysykweGx5lK5QfDWdoca+1OVfFw76U34JPMQg
         uqvZrbA6aq19BnYXgVRJLWuiCoL1vObhQyG2nK+qy1bj/Lvh6PPBdre15KQzsf5T6DlI
         D/rj87vGJtuIepHkqnr9yEknJJlbQwGjfc+xc=
MIME-Version: 1.0
In-Reply-To: <20100202111135.18636.62688.stgit@pc1117.cambridge.arm.com>
References: <20100202111135.18636.62688.stgit@pc1117.cambridge.arm.com>
Date: Tue, 2 Feb 2010 23:41:51 +0800
Message-ID: <d82e647a1002020741n4a048395o6ebf7ffaf8457819@mail.gmail.com>
Subject: Re: [PATCH] isp1760: Flush the D-cache for the pipe-in transfer 
	buffers
From: Ming Lei <tom.leiming@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Sebastian Siewior <bigeasy@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/2/2 Catalin Marinas <catalin.marinas@arm.com>:

> +       if (usb_pipein(urb->pipe) && usb_pipetype(urb->pipe) == PIPE_BULK) {
> +               void *ptr;
> +               for (ptr = urb->transfer_buffer;
> +                    ptr < urb->transfer_buffer + urb->transfer_buffer_length;
> +                    ptr += PAGE_SIZE)
> +                       flush_dcache_page(virt_to_page(ptr));

If the page is mapped into highmem, seems virt_to_page doesn't work well.

-- 
Lei Ming
