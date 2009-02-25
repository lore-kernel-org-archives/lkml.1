Return-Path: <linux-kernel-owner+w=401wt.eu-S1758114AbZBYHMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758114AbZBYHMu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 02:12:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753273AbZBYHMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 02:12:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41507 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431AbZBYHMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 02:12:39 -0500
Message-ID: <49A4EE85.5000907@zytor.com>
Date: Tue, 24 Feb 2009 23:08:53 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Kyle McMartin <kyle@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Sam Ravnborg <sam@ravnborg.org>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>, mingo@redhat.com,
       dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       Arnd Bergmann <arnd@arndb.de>
Subject: Re: [rfc] headers_check cleanups break the whole world
References: <20090225032553.GD6690@bombadil.infradead.org> <20090225065632.GB21903@elte.hu> <20090225070511.GG6690@bombadil.infradead.org>
In-Reply-To: <20090225070511.GG6690@bombadil.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle McMartin wrote:
> 
> Yeah, sorry, I should have been clearer, libcap does stupid
> #define _LINUX_TYPES_H_
> typedef unsigned int __u32;
> #include <linux/header.h>
> 
> Which is just horribly broken when it's included early in a file and
> then we try to #include <asm/sigcontext.h> (and doesn't get the rest
> of those types since it now includes <linux/types.h> instead of
> <asm/types.h>) (coreutils was doing this.)
> 
> The real case is something like using the dvb headers, which legitimately
> is trying to include both <sys/*.h> and then <linux/dvb/*.h> and expecting
> it to work.
> 
> The footnote in the prior mail was really just an example of why not
> having just the plain __u32 et al types in their own header.
> 

Because <linux/types.h> should work just fine once we get rid of the
__KERNEL_STRICT_NAMES idiocy?

FWIW, Arnd Bergmann has been working on exactly this cleanup.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

