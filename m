Return-Path: <linux-kernel-owner+w=401wt.eu-S1753263AbYGIQS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263AbYGIQS7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 12:18:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751180AbYGIQSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 12:18:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37127 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261AbYGIQSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 12:18:49 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080709154649.57f66bb9@the-village.bc.nu>
References: <20080709154649.57f66bb9@the-village.bc.nu> <20080709113547.19235.15424.stgit@warthog.procyon.org.uk> <20080709044743.0dd15a3f.akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       alan@redhat.com, Markus.Lidel@shadowconnect.com, vvs@sw.ru,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] Mark i2o config broken on 64-bit platforms.
X-Mailer: MH-E 8.0.3+cvs; nmh 1.3; GNU Emacs 23.0.50
Date: Wed, 09 Jul 2008 17:18:18 +0100
Message-ID: <24339.1215620298@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> 64bit kernel 32bit user space should be fine,

There's a place I pointed out in an earlier email where it appears a 64-bit
kernel can screw up, even with a 32-bit userspace.  It allocates a piece of
RAM with kmalloc(), takes the address of it, passes that through
virt_to_bus(), discards the upper 32-bits from the result and posts it in an
I2O message, presumably to the device.  That would appear likely to go kaboom
on a 64-bit system with more than 4GB of RAM.

If the device doesn't use that address, then why pass it at all?

David
