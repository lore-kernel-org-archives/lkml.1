Return-Path: <linux-kernel-owner+w=401wt.eu-S1757132AbXINKtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757132AbXINKtb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 06:49:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756956AbXINKtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 06:49:22 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50355 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756952AbXINKtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 06:49:21 -0400
Date: Fri, 14 Sep 2007 03:48:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Olof Johansson <olof@lixom.net>
Cc: linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org, hch@lst.de,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] pcmcia: Convert io_req_t to use kio_addr_t
Message-Id: <20070914034854.1658a9cf.akpm@linux-foundation.org>
In-Reply-To: <20070905142742.GA1760@lixom.net>
References: <20070905142742.GA1760@lixom.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Sep 2007 09:27:43 -0500 Olof Johansson <olof@lixom.net> wrote:

> Convert the io_req_t members to kio_addr_t, to allow use on machines with
> more than 16 bits worth of IO port address space (ppc64 in this case,
> but it applies to others as well).

drivers/usb/host/sl811_cs.c: In function 'sl811_cs_config':
drivers/usb/host/sl811_cs.c:263: warning: format '%04x' expects type 'unsigned int', but argument 2 has type 'kio_addr_t'
drivers/usb/host/sl811_cs.c:263: warning: format '%04x' expects type 'unsigned int', but argument 3 has type 'long unsigned int'

That's not just a cosmetic thing - the printk can print junk and if there's
a %s in the control string after the %x's, printk() will crash.

I don't know how many instances of this are in the tree, but they'll all
need to be found and fixed.

