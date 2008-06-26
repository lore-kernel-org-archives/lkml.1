Return-Path: <linux-kernel-owner+w=401wt.eu-S1757302AbYFZBS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302AbYFZBS2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 21:18:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753067AbYFZBSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 21:18:20 -0400
Received: from gw.goop.org ([64.81.55.164]:38176 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768AbYFZBST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 21:18:19 -0400
Message-ID: <4862EE4C.4060009@goop.org>
Date: Wed, 25 Jun 2008 18:18:04 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Keith Packard <keithp@keithp.com>
CC: Dave Airlie <airlied@linux.ie>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: kmap_atomic_pfn for PCI BAR access?
References: <1214242487.11887.35.camel@koto.keithp.com>
In-Reply-To: <1214242487.11887.35.camel@koto.keithp.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keith Packard wrote:
> The graphics memory BAR is generally fairly good sized; on Intel chips,
> it's between 256M and 1G (and growing). I want to write data into this
> region from kernel space, but it's really too big to map the whole thing
> into kernel address space, especially on 32-bit systems. ioremap is not
> a good option here -- it's way too slow.
>
> With CONFIG_HIGHMEM enabled, I can use kmap_atomic_pfn (well, actually
> the kmap_atomic_proc_pfn included in the DRM tree) and things work quite
> well -- performance is good, with barely any measurable time spent in
> the PTE whacking (~1%).
>
> However, with CONFIG_HIGHMEM disabled, there aren't any PTEs reserved
> for this kind of mapping fun. This makes me suspect that abusing
> kmap_atomic for this operation would not be appreciated. 
>
> Should I use kmap_atomic_pfn to reach my PCI BAR like this?
>
> Would it be reasonable to supply a patch that made this work even
> without CONFIG_HIGHMEM?
>   

Usually people use ioremap to map device memory.  Wouldn't that work in 
this case?

    J

