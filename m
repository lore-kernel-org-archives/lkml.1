Return-Path: <linux-kernel-owner+w=401wt.eu-S1754520AbZKLV5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520AbZKLV5V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 16:57:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754389AbZKLV5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 16:57:14 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:41552 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372AbZKLV5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 16:57:14 -0500
Authentication-Results: sj-iport-5.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAJYS/EqrR7H+/2dsb2JhbADFM5gYhDwE
X-IronPort-AV: E=Sophos;i="4.44,731,1249257600"; 
   d="scan'208";a="103794325"
Date: Thu, 12 Nov 2009 16:56:49 -0500
From: David VomLehn <dvomlehn@cisco.com>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: linux-embedded@vger.kernel.org, akpm@linux-foundation.org,
       dwm2@infradead.org, linux-kernel@vger.kernel.org, mpm@selenic.com,
       paul.gortmaker@windriver.com
Subject: Re: [PATCH, RFC] panic-note: Annotation from user space for panics
Message-ID: <20091112215649.GA28349@dvomlehn-lnx2.corp.sa.net>
References: <20091112021322.GA6166@dvomlehn-lnx2.corp.sa.net> <4AFC4D31.2000101@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AFC4D31.2000101@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Switched from top posting)

On Thu, Nov 12, 2009 at 01:00:17PM -0500, Marco Stornelli wrote:
> David VomLehn ha scritto:
> > Allows annotation of panics to include platform information. It's no big
> > deal to collect information, but way helpful when you are collecting
> > failure reports from a eventual base of millions of systems deployed in
> > other people's homes.
> > 
> Sincerely, I don't understand why we should involve the kernel to gather
> this kind of information when we can use other (user-space) tools, only
> to have "all" in a single report maybe? I think it's a bit weak reason
> to include this additional behavior in the kernel.

Good question. Some more detail on our application might help. In some
situations, we may have no disk and only enough flash for the bootloader.
The kernel is downloaded over the network. When we get to user space, we
initialize a number of things dynamically. For example, we dynamically
compute some MAC address, and most of the IP addresses are obtained with
DHCP. This are very useful to have for panic analysis.

Since there is neither flash nor disk, user space has no place to store
this information, should the kernel panic. When we come back up, we will get
different MAC and IP addresses. Storing them in memory is our only hope.

Fortunately, there is a section of RAM that the bootloader promises not
to overwrite. On a panic, we capture the messages written on the console
and store them in the protected area. If the information from the
/proc file is written as part of the panic, we will capture it, too.

There is a later email suggesting this be done in a panic notifier, and I
think that's a better approach. Then, instead of having this be a /proc file,
we could have a pseudo-device in /dev.

> Marco
