Return-Path: <linux-kernel-owner+w=401wt.eu-S1754224AbZD1EVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224AbZD1EVG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 00:21:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750829AbZD1EUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 00:20:53 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:42520 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750735AbZD1EUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 00:20:53 -0400
Date: Tue, 28 Apr 2009 00:20:47 -0400 (EDT)
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Paul Mundt <lethal@linux-sh.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 11/14] powerpc: Use macros for .data.page_aligned
 section.
In-Reply-To: <1240864388-26315-12-git-send-email-tabbott@mit.edu>
Message-ID: <alpine.DEB.1.10.0904280015040.15450@vinegar-pot.mit.edu>
References: <1240864388-26315-1-git-send-email-tabbott@mit.edu> <1240864388-26315-2-git-send-email-tabbott@mit.edu> <1240864388-26315-3-git-send-email-tabbott@mit.edu> <1240864388-26315-4-git-send-email-tabbott@mit.edu> <1240864388-26315-5-git-send-email-tabbott@mit.edu>
 <1240864388-26315-6-git-send-email-tabbott@mit.edu> <1240864388-26315-7-git-send-email-tabbott@mit.edu> <1240864388-26315-8-git-send-email-tabbott@mit.edu> <1240864388-26315-9-git-send-email-tabbott@mit.edu> <1240864388-26315-10-git-send-email-tabbott@mit.edu>
 <1240864388-26315-11-git-send-email-tabbott@mit.edu> <1240864388-26315-12-git-send-email-tabbott@mit.edu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Apr 2009, Tim Abbott wrote:

> +++ b/arch/powerpc/kernel/vmlinux.lds.S
> @@ -222,6 +222,7 @@ SECTIONS
>  
>  #ifdef CONFIG_PPC32
>  	.data : AT(ADDR(.data) - LOAD_OFFSET) {
> +		PAGE_ALIGNED_DATA
>  		DATA_DATA
>  		*(.sdata)
>  		*(.got.plt) *(.got)

Just noticed that PAGE_ALIGNED_DATA is only being added for CONFIG_PPC32.

Since there will be several more FOO_DATA macros being added to the .data 
section, I think the right fix is to first unify the two .data output 
section definitions, and then convert to using PAGE_ALIGNED_DATA.

	-Tim Abbott
