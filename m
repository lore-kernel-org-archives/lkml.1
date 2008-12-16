Return-Path: <linux-kernel-owner+w=401wt.eu-S1756846AbYLPM1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846AbYLPM1j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 07:27:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752986AbYLPM12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 07:27:28 -0500
Received: from mta23.gyao.ne.jp ([125.63.38.249]:30993 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751334AbYLPM11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 07:27:27 -0500
Date: Tue, 16 Dec 2008 21:25:24 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: hjk@linutronix.de, gregkh@suse.de, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [RESEND][PATCH] uio: Add of_platform_driver to uio_pdrv_genirq
Message-ID: <20081216122524.GA29546@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Wolfram Sang <w.sang@pengutronix.de>, hjk@linutronix.de,
	gregkh@suse.de, linux-kernel@vger.kernel.org,
	linuxppc-dev@ozlabs.org
References: <1229007937-5501-1-git-send-email-w.sang@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229007937-5501-1-git-send-email-w.sang@pengutronix.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2008 at 04:05:37PM +0100, Wolfram Sang wrote:
> Make the generic uio-driver also accessible for of devices. It utilizes the
> standard 'reg' and 'interrupt' properties. A typical usage would look like
> this:
> 
> 	fpga-io@00003000 {
> 		compatible = "generic-uio";
> 		reg = <0x00003000 0x20>;
> 		interrupts = <0xa>;
> 		interrupt-parent = <&fpga_irq_mux>;
> 	};
> 
> To achieve this, the probe function has been refactored, so it can be used by
> platform and of code. Then, the of driver has been added.
> 
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>

It is pretty poor form to not even bother to Cc the only author of the
code you are modifying, and have no Signed-off-by or Acked-by to even
suggest that it was ever even looked at. This isn't something that ought
to have to be pointed out, either.

In addition to the stuff pointed out by Greg, I don't see what you
actually gain by hacking the OF crap in to this driver. You would be
better off layering the OF driver on top of this, rather than trying to
make them live together in the same file.

See pata_platform/pata_of_platform for an example of how to do this a bit
more sanely.
