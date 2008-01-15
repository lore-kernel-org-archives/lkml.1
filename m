Return-Path: <linux-kernel-owner+w=401wt.eu-S1754320AbYAOKJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320AbYAOKJz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 05:09:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756610AbYAOKIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 05:08:54 -0500
Received: from mail.suse.de ([195.135.220.2]:57788 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755662AbYAOKIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 05:08:52 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Jan Beulich" <jbeulich@novell.com>
Subject: Re: [PATCH] [0/31] Great change_page_attr patch series v2
Date: Tue, 15 Jan 2008 11:06:15 +0100
User-Agent: KMail/1.9.6
Cc: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
References: <200801141116.534682000@suse.de> <478C86E0.76E4.0078.0@novell.com>
In-Reply-To: <478C86E0.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801151106.15452.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 January 2008 10:11:44 Jan Beulich wrote:
> >>> Andi Kleen <ak@suse.de> 14.01.08 23:16 >>>
> >
> >Lots of improvements to change_page_attr(). Make it a lot more
> >efficient and fix various bugs.
> >
> >Changes against earlier version
> >
> >- Fixed some checkpatch.pl complaints
> >- Improved self test suite
> >- Fixed more reference bugs 
> >- Fix NX handling on 32bit
> >- Remove some useless code there
> >- Few other random fixes
> 
> The one concept that I'm missing (but that I can easily produce a follow-up
> patch for, as I had this in my c_p_a() changes) is the tracking and adjusting
> of the reference protection for a large page range that got fully converted
> to another type (namely relevant for .rodata if it exceeds 2/4 Mb), allowing
> to use a large page mapping in this case even for non-default mappings.

Ah -- i got rid of that by changing the rodata code to not do this
except for the debugging case

>>
CPA: Only unmap kernel init pages in text mapping when CONFIG_DEBUG_RODATA is set

Otherwise the kernel will likely always run with 4K pages instead of 2MB pages,
which is costly in terms of TLBs.
<<

But you're right that would be an useful feature. But wouldn't it require
aligning rodata to 2MB in the vmlinux to be really effective? 

> 
> Apart from the other comments, the whole series
> 
> Acked-by: Jan Beulich <jbeulich@novell.com>

Thanks.

-Andi



