Return-Path: <linux-kernel-owner+w=401wt.eu-S1754096AbYJFMzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096AbYJFMzK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 08:55:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752970AbYJFMy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 08:54:57 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:57671 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618AbYJFMy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 08:54:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent:sender;
        b=DzkODcvydKQzcMFKOUcWQodEhrmpfJ9SSQTOHsSc7r4ln4U7/7Tw0hqy0q0SsFlhFV
         GqnTztZJPuJ/KfIphD1hHcYey84w2Xb4cXaVI37cDgpMK72HzL2znNN7WvyLPIu+Id2H
         6nKgiKBiF/zeCPq7wX6ybNM3iWNQ2OBesztWM=
Date: Mon, 6 Oct 2008 08:53:34 -0400
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Alan Cox <alan@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 22/76] serial: Make uart_port's ioport "unsigned long".
Message-ID: <20081006125334.GA19412@yoda.jdub.homelinux.org>
References: <20081005160231.1997.10462.stgit@localhost.localdomain> <20081005160737.1997.74180.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081005160737.1997.74180.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 05, 2008 at 05:07:41PM +0100, Alan Cox wrote:
>From: David Miller <davem@davemloft.net>
>
>Otherwise the top 32-bits of the resource value get chopped
>off on 64-bit systems, and the resulting I/O accesses go to
>random places.
>
>Thanks to testing and debugging by Josip Rodin, which helped
>track this down.
>
>Signed-off-by: David S. Miller <davem@davemloft.net>
>Signed-off-by: Alan Cox <alan@redhat.com>
>---
>
> include/linux/serial_core.h |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
>
>diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
>index 3b2f6c0..e27f216 100644
>--- a/include/linux/serial_core.h
>+++ b/include/linux/serial_core.h
>@@ -241,7 +241,7 @@ typedef unsigned int __bitwise__ upf_t;
> 
> struct uart_port {
> 	spinlock_t		lock;			/* port lock */
>-	unsigned int		iobase;			/* in/out[bwl] */
>+	unsigned long		iobase;			/* in/out[bwl] */

Does using resource_size_t make more sense here?  There are
32-bit CPUs that have 64-bit address spaces.  (Perhaps not
that use iobase, but it might be cleaner in general.)

josh
