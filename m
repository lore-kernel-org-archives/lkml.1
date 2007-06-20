Return-Path: <linux-kernel-owner+w=401wt.eu-S1758607AbXFTPyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758607AbXFTPyk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 11:54:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755530AbXFTPyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 11:54:20 -0400
Received: from terminus.zytor.com ([192.83.249.54]:49387 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755342AbXFTPyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 11:54:19 -0400
Message-ID: <46794BE2.5020108@zytor.com>
Date: Wed, 20 Jun 2007 08:46:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Christoph Hellwig <hch@infradead.org>, Mike Frysinger <vapier@gentoo.org>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] use __asm__ and __volatile__ in asm-x86_64/msr.h
References: <200706180209.36762.vapier@gentoo.org> <200706181002.21978.vapier@gentoo.org> <20070618183651.GB17112@infradead.org> <200706182053.04116.ak@suse.de>
In-Reply-To: <200706182053.04116.ak@suse.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> asm-i386/msr.h should not be exported to userspace at all, it contains
>> nothing but kernel-internal helpers.
> 
> Actually rdtsc and rdtscll and potentially rdpmc which is in there can be very 
> useful in user space if you know what you're doing. Unfortunately a lot of its users don't,
> but not having the include probably won't stop them either.

More likely, people will just re-implement them incorrectly.

However, the rdtsc() definition in the kernel is weird (and removable, I
think there are no more users -- I have it removed in my MSR driver
rewrite tree which I need to get off my arse and push.)  Most users
would expect the rdtscll() functionality with the rdtsc() name.

	-hpa
