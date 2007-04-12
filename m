Return-Path: <linux-kernel-owner+w=401wt.eu-S1161530AbXDLCyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161530AbXDLCyn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 22:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161528AbXDLCyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 22:54:08 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:19890 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161527AbXDLCx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 22:53:57 -0400
X-IronPort-AV: i="4.14,399,1170651600"; 
   d="scan'208"; a="27033404:sNHT22963556"
Subject: Re: [PATCH 0/12] Pass MAP_FIXED down to get_unmapped_area
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Memory Management <linux-mm@kvack.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1176344427.242579.337989891532.qpush@grosgo>
References: <1176344427.242579.337989891532.qpush@grosgo>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Thu, 12 Apr 2007 10:56:29 +0800
Message-Id: <1176346589.29581.32.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-12 at 12:20 +1000, Benjamin Herrenschmidt wrote:
> This is a "first step" as there are still cleanups to be done in various
> areas touched by that code but I think it's probably good to go as is and
> at least enables me to implement what I need for PowerPC.
> 
> (Andrew, this is also candidate for 2.6.22 since I haven't had any real
> objection, mostly suggestion for improving further, which I'll try to
> do later, and I have further powerpc patches that rely on this).
> 
> The current get_unmapped_area code calls the f_ops->get_unmapped_area or
> the arch one (via the mm) only when MAP_FIXED is not passed. That makes
> it impossible for archs to impose proper constraints on regions of the
> virtual address space. To work around that, get_unmapped_area() then
> calls some hugetlbfs specific hacks.
> 
> This cause several problems, among others:
> 
>  - It makes it impossible for a driver or filesystem to do the same thing
> that hugetlbfs does (for example, to allow a driver to use larger page
> sizes to map external hardware) if that requires applying a constraint
> on the addresses (constraining that mapping in certain regions and other
> mappings out of those regions).
> 
>  - Some archs like arm, mips, sparc, sparc64, sh and sh64 already want
> MAP_FIXED to be passed down in order to deal with aliasing issues.
> The code is there to handle it... but is never called.
> 

Is there any support consideration for nommu arch such as blackfin which
is in the -mm tree now?

It is very kind of you to point out some idea about MAP_FIXED for
Blackfin arch, I will do some help for this.

Thanks 
-Bryan
