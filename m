Return-Path: <linux-kernel-owner+w=401wt.eu-S1754510AbYJQHMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510AbYJQHMS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 03:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751902AbYJQHMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 03:12:03 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:38529 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666AbYJQHMA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 03:12:00 -0400
Message-Id: <48F85711.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 Beta 
Date: Fri, 17 Oct 2008 08:12:49 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "Chris Lalancette" <clalance@redhat.com>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH]: Fix Xen domU boot with batched		
	 mprotect
References: <48F5CE10.3060403@redhat.com> <48F6274D.76E4.0078.0@novell.com>
 <48F61919.2050005@goop.org> <48F72C7A.76E4.0078.0@novell.com>
 <48F76773.2090700@goop.org>
In-Reply-To: <48F76773.2090700@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Jeremy Fitzhardinge <jeremy@goop.org> 16.10.08 18:10 >>>
>The current x86-64 implementation is:
>
>bool __virt_addr_valid(unsigned long x)
>{
>	if (x >= __START_KERNEL_map) {
>		x -= __START_KERNEL_map;
>		if (x >= KERNEL_IMAGE_SIZE)
>			return false;

This, imo, is still broken (i.e. the name of the function still isn't matched
by the implementation): KERNEL_IMAGE_SIZE is a constant and doesn't
account for the fact that only the real kernel image can be relied upon
to be mapped.

>and 32-bit is similar (but simpler, since it doesn't need to worry about a separate kernel mapping).

This continues to be broken, but not as badly as it used to be - while it
now covers user space and the vmalloc area (I'm unclear why this is
excluded only after booting completed, though), hypervisor space
continues to not be considered here.

But as mentioned before - excluding the vmalloc area seems bogus wrt
the name of the function, but as I take it the confusion here is intended.

Jan

