Return-Path: <linux-kernel-owner+w=401wt.eu-S2993423AbXEBQGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993423AbXEBQGt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 12:06:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993424AbXEBQGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 12:06:49 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:47006 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993423AbXEBQGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 12:06:48 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4638B6F5.9070802@s5r6.in-berlin.de>
Date: Wed, 02 May 2007 18:06:13 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: John Stoffel <john@stoffel.org>
CC: Kristian H??gsberg <krh@redhat.com>, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux1394-devel <linux1394-devel@lists.sourceforge.net>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3/6] firewire: char device interface
References: <4637A29F.6070302@redhat.com>	<20070502090007.GA28174@infradead.org>	<tkrat.087ee29add656926@s5r6.in-berlin.de>	<tkrat.350cb4dfe522266e@s5r6.in-berlin.de>	<tkrat.65aea95f1451c211@s5r6.in-berlin.de>	<tkrat.2aa3f3ac11a3d60d@s5r6.in-berlin.de> <17976.44988.734513.121919@smtp.charter.net>
In-Reply-To: <17976.44988.734513.121919@smtp.charter.net>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John Stoffel wrote:
>>>>>> "Stefan" == Stefan Richter <stefanr@s5r6.in-berlin.de> writes:
[...]

Hmm, I'm just spotting some artifacts after a recent file-renaming patch:

> Stefan> --- /dev/null
> Stefan> +++ linux_juju/include/linux/firewire-cdev.h
                                       ^^^^^^^^^^^^^^^
> Stefan> @@ -0,0 +1,268 @@
> Stefan> +/*						-*- c-basic-offset: 8 -*-
> Stefan> + *
> Stefan> + * fw-device-cdev.h -- Char device interface.
              ^^^^^^^^^^^^^^^^
[...]
> Stefan> +#ifndef __fw_cdev_h
> Stefan> +#define __fw_cdev_h
                   ^^^^^^^^^^^
[...]
> Stefan> +#define TCODE_WRITE_QUADLET_REQUEST	0
> Stefan> +#define TCODE_WRITE_BLOCK_REQUEST	1
[...]
> Stefan> +#define SCODE_100			0x0
> Stefan> +#define SCODE_200			0x1
> Stefan> +#define SCODE_400			0x2
> Stefan> +#define SCODE_800			0x3
> Stefan> +#define SCODE_1600			0x4
> Stefan> +#define SCODE_3200			0x5
> 
> These are also defined in fw-transaction.h, though that file doesn't
> have all the values.  Can these just be combined into a single
> fw-constants.h file instead?  
> 
> I honestly haven't checked all your defines....
[...]

Right, there are some overlaps...

Note, firewire-cdev.h declares a userspace ABI, while fw-transaction.h
declares an in-kernel API.  I'm not quite sure right now how it should
rather be organized.  Maybe rename fw-transaction.h's macros.  Only
fw-cdev.c (which implements the userspace ABI) includes both header files.

(PS: I'm not the author; only subsystem maintainer.)
-- 
Stefan Richter
-=====-=-=== -=-= ---=-
http://arcgraph.de/sr/
