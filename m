Return-Path: <linux-kernel-owner+w=401wt.eu-S1754520AbXJJMEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520AbXJJMEk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 08:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752696AbXJJMEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 08:04:32 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:60188 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752500AbXJJMEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 08:04:31 -0400
Date: Wed, 10 Oct 2007 13:09:23 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: wit <is01kzh@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: about probing a device
Message-ID: <20071010130923.004ee895@the-village.bc.nu>
In-Reply-To: <105610bf0710091839r3b2fc1bfp4260ceaf6ad94b7@mail.gmail.com>
References: <105610bf0710091839r3b2fc1bfp4260ceaf6ad94b7@mail.gmail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Oct 2007 09:39:44 +0800
wit <is01kzh@gmail.com> wrote:

> Hi,
> I found these routines in the kernel, does this means only one driver
> can be matched to a device? What if two drivers both can drive the
> device, like sd & sg in scsi subsystem?

The first one which matches and successfully attaches "wins". Thus you
can allow two drivers to match an identifier and load either one or the
other. You can also deal with cases where the same identifier is used for
two different devices (eg with the revision id distinguishing them), by
having the probe methods fail if the revision is wrong.

For things like sd/sg this isn't an issue. The hardware driver interfaces
to the scsi layer which itself provides interfaces for sd, sr, sg, ... etc

If you have a PCI device with multiple device functions on one PCI
function it can be a problem. We have some special case drivers for
serial/parallel multiport cards for exactly this reason, and some ugly
hacks in AGP and EDAC that arise from this limit.

Alan
