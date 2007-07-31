Return-Path: <linux-kernel-owner+w=401wt.eu-S1763509AbXGaXqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763509AbXGaXqg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 19:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762013AbXGaXqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 19:46:12 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:47207 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758828AbXGaXqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 19:46:08 -0400
Date: Tue, 31 Jul 2007 16:46:06 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       tony.olech@elandigitalsystems.com,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: [PATCH 25] drivers/usb/misc/ftdi-elan.c: kmalloc + memset
 conversion to kzalloc
In-Reply-To: <200707311942.10127.m.kozlowski@tuxland.pl>
Message-ID: <Pine.LNX.4.64.0707311645340.31337@schroedinger.engr.sgi.com>
References: <200707311845.48807.m.kozlowski@tuxland.pl>
 <200707311942.10127.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2007, Mariusz Kozlowski wrote:

> @@ -2777,12 +2777,14 @@ static int ftdi_elan_probe(struct usb_in
>          size_t buffer_size;
>          int i;
>          int retval = -ENOMEM;
> -        struct usb_ftdi *ftdi = kmalloc(sizeof(struct usb_ftdi), GFP_KERNEL);
> -        if (ftdi == NULL) {
> +        struct usb_ftdi *ftdi;
> +
> +	ftdi = kzalloc(sizeof(struct usb_ftdi), GFP_KERNEL);
> +	if (!ftdi) {

Whitespace damage soewhere?

