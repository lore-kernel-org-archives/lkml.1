Return-Path: <linux-kernel-owner+w=401wt.eu-S1758933AbYBGUe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758933AbYBGUe4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 15:34:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754004AbYBGUer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:34:47 -0500
Received: from an-out-0708.google.com ([209.85.132.245]:16823 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622AbYBGUeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:34:46 -0500
Message-ID: <fa686aa40802071234r5736aec6h12d482b8a2c408c0@mail.gmail.com>
Date: Thu, 7 Feb 2008 13:34:43 -0700
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: Xilinx: hwicap driver comments
Cc: "Stephen Neuendorffer" <stephen.neuendorffer@xilinx.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <47AB6552.7040503@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47AB6552.7040503@gmail.com>
X-Google-Sender-Auth: edfe5efbc99fcedf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/7/08, Jiri Slaby <jirislaby@gmail.com> wrote:
> Hi,
>
> first of all, I think that the driver should go through lkml before upstream
> merge or at least be in -mm for a while (I think this used to be a rule some
> time ago), correct me if I'm wrong, but none of it happened.

Hmmm, if that's the rule then I apologize.  I had thought that arch
specific drivers were okay (assuming not part of a common subsystem
like USB, Eth, etc).  The driver went through a number of review
cycles on the linuxppc mailing list and the comments had settled down.
 I didn't see any problem in merging it as it is a platform specific
driver only used by the Xilinx Virtex chips.  It is only used by
arch/powerpc and only when CONFIG_XILINX_VIRTEX is selected.

Linus has already pulled Paul's tree so the patch is already merged
upstream.  Does it need to come back out?

Stephen, can you please repost you patch to the LKML?  Even if the
driver is allowed to stay in for the time being you can at least get
feedback on what needs to be changed.

Cheers,
g.

>
> Few comments I have:
> - release f_op retval is silently ignored, I guess you will get your device into
> undefined state when the first function fails (esp. when you interrupt the sem)
> - semaphores are deprecated
> - class_device_create is deprecated
> - module_init/exit functions should be __init, not __devinit/exit (not a bug,
> it's subset)
> - this piece:
>          drvdata = kmalloc(sizeof(struct hwicap_drvdata), GFP_KERNEL);
>          if (!drvdata) {
>                  dev_err(dev, "Couldn't allocate device private record\n");
>                  return -ENOMEM;
>          }
>   memset((void *)drvdata, 0, sizeof(struct hwicap_drvdata));
>
>   kmalloc + memset = kzalloc
>   null probed_devices[id] on that fail path and on failed1 label
>
> - from/to (void *) casts are useless
> - io resources are at least ulong
> - don't understand this:
>                  memcpy(kbuf, drvdata->read_buffer, bytes_remaining);
>                  drvdata->read_buffer_in_use = bytes_remaining;
>                  free_page((unsigned long)kbuf);
> - can this overlap (=>memmove)?
>                  memcpy(drvdata->read_buffer + bytes_to_read,
>                                  drvdata->read_buffer, 4 - bytes_to_read);
> - is platform probing function race-proof (like pci)?
> - run sparse on it, you mix __user with non-__user at least
>


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
