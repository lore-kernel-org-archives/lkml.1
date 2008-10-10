Return-Path: <linux-kernel-owner+w=401wt.eu-S1763807AbYJJUVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763807AbYJJUVW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 16:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761248AbYJJUVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 16:21:14 -0400
Received: from kroah.org ([198.145.64.141]:59698 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760696AbYJJUVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 16:21:13 -0400
Date: Fri, 10 Oct 2008 13:18:05 -0700
From: Greg KH <greg@kroah.com>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: stable@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [stable] [PATCH] x86: Reserve FIRST_DEVICE_VECTOR in
	used_vectors bitmap
Message-ID: <20081010201805.GC32164@kroah.com>
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

Is there a problem with being assigned to IRQ0 in situations like this?

thanks,

greg k-h
