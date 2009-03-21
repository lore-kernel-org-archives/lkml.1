Return-Path: <linux-kernel-owner+w=401wt.eu-S1755450AbZCUKcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450AbZCUKcg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 06:32:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754181AbZCUKc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 06:32:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54499 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753731AbZCUKc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 06:32:26 -0400
Date: Sat, 21 Mar 2009 03:26:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: ngupta@vflare.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] compcache documentation
Message-Id: <20090321032636.fdeae224.akpm@linux-foundation.org>
In-Reply-To: <49C3A4B0.3050503@vflare.org>
References: <49C3A31D.6070208@vflare.org>
	<49C3A4B0.3050503@vflare.org>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Mar 2009 19:44:08 +0530 Nitin Gupta <ngupta@vflare.org> wrote:

> ...
>
> +   backing_dev: This is block device to be used as backing store for compcache.
> +	It must be a valid swap partition. We move data to this device when we
> +	encounter incompressible page or memlimit is reached. TODO: we may also
> +	move some pages from compcache to this device in case system is really
> +	low on memory.
> +	This device is not directly visible to kernel as a swap device
> +	(/proc/swaps will only show /dev/ramzswap0 and not this device).
> +	Managing this backing device is the job of compcache module.

hrm, OK, it kinda/sorta/maybe might be a little bit like a "compressed
cache".  But if someone comes up with a real compressed cache (ie:
pagecache) then they'll want their name back.

Also, the kernel already has a widespread and well-established "backing
device" concept, in include/linux/backing-dev.h.  This new feature's
poaching of that identifier is a bit confusing.  It would be nice to do a
wholesale rename if possible.  secondary_dev?  nv_dev?

