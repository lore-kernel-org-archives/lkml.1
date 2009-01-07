Return-Path: <linux-kernel-owner+w=401wt.eu-S1759724AbZAGQow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759724AbZAGQow (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 11:44:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753257AbZAGQon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 11:44:43 -0500
Received: from casper.infradead.org ([85.118.1.10]:51661 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbZAGQom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 11:44:42 -0500
Subject: Re: [PATCH] x86 byteorder.h: use __asm__/__inline__ for userspace
From: David Woodhouse <dwmw2@infradead.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Mike Frysinger <vapier@gentoo.org>, tglx@linutronix.de,
       mingo@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <20081227191223.GA10592@uranus.ravnborg.org>
References: <1230360604-6711-1-git-send-email-vapier@gentoo.org>
	 <20081227071208.GB27736@uranus.ravnborg.org>
	 <20081227084708.GA16077@elte.hu>
	 <20081227185727.GB10442@uranus.ravnborg.org> <49567AC3.4030507@zytor.com>
	 <20081227191223.GA10592@uranus.ravnborg.org>
Content-Type: text/plain
Date: Wed, 07 Jan 2009 16:44:18 +0000
Message-Id: <1231346658.10383.2.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-2.fc10) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-12-27 at 20:12 +0100, Sam Ravnborg wrote:
> 
> Speaking of what we want to use in exported headers.
> What is the recommendation with respect to uint32_t and friends?
> To my best knowledge they are banned in exported headers as they
> are not part of the kernel namespace and I see few users too.
> But is this something we should check for?

No, they're not banned. There are a few cases where they can't be used
and we have to use the kernels "speshul" __u32 types, because certain
headers get included by glibc and we can't "pollute" the namespace with
the C standard types. But in _most_ cases, using the standard C types is
just fine.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

