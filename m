Return-Path: <linux-kernel-owner+w=401wt.eu-S1753493AbZBLUNH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbZBLUNH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 15:13:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756537AbZBLUMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 15:12:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60342 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755690AbZBLUMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 15:12:54 -0500
Message-ID: <499481F2.3040107@zytor.com>
Date: Thu, 12 Feb 2009 12:09:22 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Don't override CONFIG_64BIT for ARCH={i386,x86_64} builds
References: <1234372298.3586.23.camel@macbook.infradead.org>	 <20090211172258.GE13239@elte.hu>  <20090212072644.GA10253@elte.hu> <1234427819.3586.142.camel@macbook.infradead.org>
In-Reply-To: <1234427819.3586.142.camel@macbook.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse wrote:
> 
> Ew, that's a nasty thing to be prioritising over day-to-day usability,
> and the fact that I can't just do 'make bzImage' without it screwing up
> and asking me to reconfigure.
> 
> Isn't there a CONFIG_RANDCONFIG option? We could make it
>    bool "64-bit kernel" if !CONFIG_RANDCONFIG
> 
> Alternatively, we could just the top-level Makefile set ARCH=x86 when
> it's inferred from the environment, and let people override it to i386
> or x86_64 if they want to.
> 

I think the fundamental problem here is that "make randconfig" is 
allowed to retain *any* information from the previous .config; the same 
is true for "make all*config", "make defconfig", etc.  These by 
definition should blast the current configuration away.

Now, "make randconfig" should ideally be able to generate either a 32- 
or a 64-bit configuration (which would have to be done correctly), but 
if ARCH is set we need to honor it.

	-hpa
