Return-Path: <linux-kernel-owner+w=401wt.eu-S1030599AbXDNAKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030599AbXDNAKx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 20:10:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030608AbXDNAKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 20:10:53 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:39640 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030599AbXDNAKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 20:10:52 -0400
Date: Fri, 13 Apr 2007 17:10:35 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Zachary Amsden <zach@vmware.com>,
       Chris Wright <chrisw@sous-sol.org>, Andi Kleen <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Crash while mapping memory in pagetable_init() (Was: Re: .config)
Message-ID: <20070414001035.GR10574@sequoia.sous-sol.org>
References: <20070413183841.GP10574@sequoia.sous-sol.org> <20070413190552.GQ10574@sequoia.sous-sol.org> <461FD97B.1010203@goop.org> <461FE36D.1050205@vmware.com> <461FE77A.6020307@zytor.com> <461FE7C7.7050204@goop.org> <461FE8EC.3090304@zytor.com> <461FE9D1.1000803@goop.org> <461FEB46.3000702@zytor.com> <461FF09D.4020902@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <461FF09D.4020902@goop.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Jeremy Fitzhardinge (jeremy@goop.org) wrote:
> Subject: i386: map enough initial memory to create lowmem mappings
> 
> head.S creates the very initial pagetable for the kernel.  This just
> maps enough space for the kernel itself, and an allocation bitmap.
> The amount of mapped memory is rounded up to 4Mbytes, and so this
> typically ends up mapping 8Mbytes of memory.
> 
> When booting, pagetable_init() needs to create mappings for all
> lowmem, and the pagetables for these mappings are allocated from the
> free pages around the kernel in low memory.  If the number of
> pagetable pages + kernel size exceeds head.S's initial mapping, it
> will end up faulting on an unmapped page.  This will only happen with
> specific combinations of kernel size and memory size.
> 
> This patch makes sure that head.S also maps enough space to fit the
> kernel pagetables as well as the kernel itself.  It ends up using an
> additional two pages of unreclaimable memory.

Yup, fixes it up here, nice catch.

Acked-by: Chris Wright <chrisw@sous-sol.org>
