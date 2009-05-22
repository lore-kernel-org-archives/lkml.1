Return-Path: <linux-kernel-owner+w=401wt.eu-S1757155AbZEVLPF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757155AbZEVLPF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 07:15:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754314AbZEVLOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 07:14:42 -0400
Received: from sh.osrg.net ([192.16.179.4]:53045 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756303AbZEVLOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 07:14:40 -0400
Date: Fri, 22 May 2009 20:13:16 +0900
To: ian.campbell@citrix.com
Cc: fujita.tomonori@lab.ntt.co.jp, jeremy@goop.org, beckyb@kernel.crashing.org,
       okir@suse.de, mingo@elte.hu, gregkh@suse.de,
       xendevel@lists.xensource.com, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: swiotlb: remove __weak hooks in favour of
 architecture-specific functions
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1242922528-5982-1-git-send-email-ian.campbell@citrix.com>
References: <1242906335.22654.188.camel@zakaz.uk.xensource.com>
	<1242922528-5982-1-git-send-email-ian.campbell@citrix.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090522201325I.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 22 May 2009 20:13:16 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 May 2009 17:15:21 +0100
Ian Campbell <ian.campbell@citrix.com> wrote:

> At the end of this series there are no more __weak functions in
> lib/swiotlb.c
> 
> The series adds several hook functions to the x86 architecture. Would
> they be preferred as a struct x86_swiotlb_ops or as individual hooks?
> 
> I was unsure what to do about powerpc in most places since the
> existing support seems to in-progress so it wasn't always clear where
> to put the implementation. If there is a tree somewhere with more
> complete support I'll be happy to provide additional patches.
> 
> Boot tested on x86 under xen but not even compiled for ia64 or
> powerpc. If someone can point me to a decent source of cross compilers
> I can sort that out. (http://www.kernel.org/pub/tools/crosstool/ seems
> to be out-of-date and only has ia64 in any case)
> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> Cc: Becky Bruce <beckyb@kernel.crashing.org>
> Cc: Olaf Kirch <okir@suse.de>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Greg KH <gregkh@suse.de>
> Cc: xen-devel <xendevel@lists.xensource.com>
> Cc: x86 maintainers <x86@kernel.org>
> Cc: lkml <linux-kernel@vger.kernel.org>

Sorry, Nack.

As I wrote in another mail, this patch makes the code more difficult
to understand; it just moves the hacks in lib/swiotlb.c somewhere else
in a strange way instead of killing them.

Please go with the following way (that I posted yesterday):

http://marc.info/?l=xen-devel&m=124292666214380&w=2


Export the core feature of swiotlb, managing iotlb buffer and
implement the Xen mapping functions. With that approach, there is not
much code duplication and there is no need for ugly hooks for dom0;
the phys/bus address conversion and address checking.
