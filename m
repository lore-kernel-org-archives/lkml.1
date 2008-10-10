Return-Path: <linux-kernel-owner+w=401wt.eu-S1763211AbYJJUTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763211AbYJJUTx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 16:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760916AbYJJUTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 16:19:45 -0400
Received: from kroah.org ([198.145.64.141]:43692 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760380AbYJJUTo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 16:19:44 -0400
Date: Fri, 10 Oct 2008 13:16:10 -0700
From: Greg KH <greg@kroah.com>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: stable@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [stable] [PATCH] x86: Reserve FIRST_DEVICE_VECTOR in
	used_vectors bitmap
Message-ID: <20081010201610.GA32164@kroah.com>
References: <48EFB4B2.2020508@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48EFB4B2.2020508@canonical.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2008 at 04:01:54PM -0400, Stefan Bader wrote:
> Affected: 2.6.24-2.6.27
> 
> Someone from the community found out, that after repeatedly unloading and
> loading a device driver that uses MSI IRQs, the system eventually assigned
> the vector initially reserved for IRQ0 to the device driver.
> 
> The reason for this is, that although IRQ0 is tied to the FIRST_DEVICE_VECTOR
> when declaring the irq_vector table, the corresponding bit in the used_vectors
> map is not set. So, if vectors are released and assigned often enough, the
> vector will get assigned to another interrupt. This happens more often with
> MSI interrupts as those are exclusively using a vector.
> 
> Fix this by setting the bit for the FIRST_DEVICE_VECTOR in the bitmap.
> 
> Signed-off-by: Stefan Bader <stefan.bader@canonical.com>

Hint, if you want patches to go into the -stable tree, just add:
	cc: Stable <stable@kernel.org>
to the patch when you submit it in the signed-off-by area, and it will
be automatically sent to us when it goes into the main kernel tree.

That makes it easier for the stable team, as we don't have to track
things "by hand" to determine when and if a patch does go into Linus's
tree.

So if you can, please do this in the future.

thanks,

greg k-h
