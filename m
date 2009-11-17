Return-Path: <linux-kernel-owner+w=401wt.eu-S1755459AbZKQQul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459AbZKQQul (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 11:50:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754940AbZKQQul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 11:50:41 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:46557 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988AbZKQQuk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 11:50:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=bFSQC6XRlxrTAo5wi9nZesNHaCihpXAVSWarrgEq2/XjhlMYjDry5Fj3vSQJ7Po+Qz
         esPzC56qwA1PLd9tJFhdNc97x6Uoy/XzbKVzKe1zOJtA+blFcUNDL6IK/PsVG5vbZnJD
         EHfkDNzFMXKuIw75fgCH3yeWgU2SWzLZYxJwg=
MIME-Version: 1.0
In-Reply-To: <20091117154641.3879.73168.stgit@localhost.localdomain>
References: <20091117154641.3879.73168.stgit@localhost.localdomain>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 17 Nov 2009 11:50:24 -0500
Message-ID: <8bd0f97a0911170850x40f68e02y5a3d8ad39c4f9b90@mail.gmail.com>
Subject: Re: [RESEND PATCH] gpio_addr_flash: Fix warnings
To: Alan Cox <alan@linux.intel.com>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 10:46, Alan Cox wrote:
> --- a/drivers/mtd/maps/gpio-addr-flash.c
> +++ b/drivers/mtd/maps/gpio-addr-flash.c
> -       state->gpio_addrs     = (void *)gpios->start;
> +       state->gpio_addrs     = (void *)(unsigned long)gpios->start;
> -       state->map.virt       = (void __iomem *)memory->start;
> +       state->map.virt       = (void __iomem *)(unsigned long)memory->start;

on what system do you see warnings ?  start should be resource_size_t
which should be phys_addr_t which should cast fine to a void*.
-mike
