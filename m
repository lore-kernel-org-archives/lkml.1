Return-Path: <linux-kernel-owner+w=401wt.eu-S1761879AbZCPThz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761879AbZCPThz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 15:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761439AbZCPThK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 15:37:10 -0400
Received: from gw.goop.org ([64.81.55.164]:51763 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761798AbZCPThJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 15:37:09 -0400
Message-ID: <49BEAA61.4020208@goop.org>
Date: Mon, 16 Mar 2009 12:37:05 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       David Airlie <airlied@linux.ie>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 10/27] xen: make sure swiotlb	 allocation
 isphysically contigious
References: <1236963612-14287-1-git-send-email-jeremy@goop.org> <1236963612-14287-11-git-send-email-jeremy@goop.org> <49BE627E.76E4.0078.0@novell.com>
In-Reply-To: <49BE627E.76E4.0078.0@novell.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
>  
> While on native using alloc_bootmem_low_pages() is a requirement here,
> on Xen this should explicitly not be used, as we realized just a couple of
> days ago:

Which conversation was this?

>  The way the bootmem allocator works, running out of space
> below 4Gb is pretty easy on machines with lots of memory, and since the
> swiotlb is a requirement for Dom0, the risk of allocation failures must be
> kept as low as possible.
>   

Are we talking about a 32 or 64 bit dom0 here?  If its 32-bit, then yes, 
low memory is a precious resource, but I don't see why that depends on 
the total amount of memory.  And if its 64-bit, why is below-4G 
particularly constrained?  That would only matter for 32-bit devices?

    J
