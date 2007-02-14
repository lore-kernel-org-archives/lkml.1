Return-Path: <linux-kernel-owner+w=401wt.eu-S932265AbXBNCfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265AbXBNCfG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 21:35:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932262AbXBNCfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 21:35:06 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:41652 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932267AbXBNCfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 21:35:05 -0500
Message-ID: <45D27534.1070608@vmware.com>
Date: Tue, 13 Feb 2007 18:34:28 -0800
From: Dan Hecht <dhecht@vmware.com>
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@osdl.org>,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 05/21] Xen-paravirt: paravirt_ops: allocate a fixmap slot
References: <20070213221729.772002682@goop.org> <20070213221829.845132535@goop.org> <45D2649D.4080508@vmware.com> <45D26797.5090600@goop.org>
In-Reply-To: <45D26797.5090600@goop.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Feb 2007 02:35:04.0840 (UTC) FILETIME=[BBFAE880:01C74FE0]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2007 05:36 PM, Jeremy Fitzhardinge wrote:
> Dan Hecht wrote:
>> Why doesn't Xen allocate the shared_info page from the pseudo-physical
>> space?  Doesn't it already have to steal pages from the
>> pseudo-physical space for e.g. initial page tables, console, etc?  Why
>> not do the same for shared_info, and then you don't need a reserve the
>> fixmap slot.
> 
> Unlike the pagetable pages or the console page, the shared info page
> doesn't have a pseudo-physical address, so in order to map it we need to
> directly construct a pte containing the mfn for that page. 

Right.  But that is only because Xen decides to allocate the page from 
the (machine) physical space, rather than from the pseudo-physical 
space.  My question is: why doesn't Xen allocate shared_info from the 
pseudo-physical space?  If it had, then this page wouldn't need to be 
treated specially.  I'm not sure, but I seem to remember on 64-bit 
Xen/XenLinux allocated shared_info from pseudo-physical space already...

  Inserting
> this mapping into the fixmap space seems like the easiest way to do
> this.  It's not like a fixmap slot costs anything.
> 
>

I don't really have an objection to stealing a fixmap slot, just seems 
cleaner if you didn't have to special case the shared_info.

Dan
