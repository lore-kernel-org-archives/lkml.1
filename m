Return-Path: <linux-kernel-owner+w=401wt.eu-S1761176AbYF3Tvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761176AbYF3Tvx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 15:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763070AbYF3Tvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 15:51:41 -0400
Received: from vena.lwn.net ([206.168.112.25]:46738 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756383AbYF3Tvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 15:51:41 -0400
Date: Mon, 30 Jun 2008 13:51:39 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: "Pan, Weimin" <weimin.pan@hp.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Why  get_user_pages fails?
Message-ID: <20080630135139.2b53c93d@bike.lwn.net>
In-Reply-To: <6B24EEDBA38D764293B27C04FE414CC64E4091DE4E@G1W0491.americas.hpqcorp.net>
References: <6B24EEDBA38D764293B27C04FE414CC64E4091DE4E@G1W0491.americas.hpqcorp.net>
Organization: LWN.net
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.3; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2008 19:32:41 +0000
"Pan, Weimin" <weimin.pan@hp.com> wrote:

> I booted the kernel and set "mem=512M" and then mmapped the physical
> memory above 512M to user space and got the user space virtual
> address for that memory. When I passed that address to my driver to
> do direct IO. The get_user_pages() in my driver fails. I found that
> this is due to the VM_IO and VM_PFNMAP are set. Does that mean the
> page structures are not built when I mmapped physical memory to user
> space (using remap_pfn_range())?
> 
> Do I have a way to solve this problem? How can I map the physical
> memory to user space virtual address and can pass this address to my
> driver to do direct IO by using get_user_pages() function?

In this situation, you already know where the memory sits in physical
space, and there's no point in trying to pin it.  So a call to
get_user_pages() is entirely unnecessary.  You're bypassing the Linux
VM, so bypass it entirely.

However, this whole scheme seems a little...baroque.  Why are you doing
things this way?  As always in such cases, posting your code can enable
others to help you find the right solution to your problem.

jon
