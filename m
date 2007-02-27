Return-Path: <linux-kernel-owner+w=401wt.eu-S1751474AbXB0CNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474AbXB0CNA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 21:13:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751475AbXB0CNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 21:13:00 -0500
Received: from terminus.zytor.com ([192.83.249.54]:38203 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbXB0CM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 21:12:59 -0500
Message-ID: <45E392E8.1010908@zytor.com>
Date: Mon, 26 Feb 2007 18:09:44 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Kyle Moffett <mrmacman_g4@mac.com>
CC: Christoph Hellwig <hch@infradead.org>, David Miller <davem@davemloft.net>,
       a.gruenbacher@computer.org, bunk@stusta.de,
       linux-kernel@vger.kernel.org, jmorris@redhat.com, dwmw2@infradead.org
Subject: Re: include/linux/xattr.h: how much userpace visible?
References: <20060724085701.B2083275@wobbly.melbourne.sgi.com> <200607242031.11815.a.gruenbacher@computer.org> <45E36D39.2030605@zytor.com> <20070226.154308.112620497.davem@davemloft.net> <45E372CA.9020709@zytor.com> <20070227000318.GA3448@infradead.org> <45E376E8.8020901@zytor.com> <3E0E2D98-5FEC-403E-831F-2B5BE6A3281A@mac.com>
In-Reply-To: <3E0E2D98-5FEC-403E-831F-2B5BE6A3281A@mac.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle Moffett wrote:
> 
> Not a bad idea, but it could use some extra error checking to make sure 
> that somebody remembers to "#define __kstruct_foo" before "#include 
> <linux/foo.h>" (perhaps indirectly through linux/bar.h).  Maybe 
> something like this (plays nice with the very-basic unifdef parsing too):
> 
> #ifdef __KERNEL__
> # define __kstruct_stat stat
> # define __kstruct_foo foo
> # define __kstruct_bar bar
> #endif
> 
> #ifdef __LINUX_KERNEL_EXPORT
> # define __kstruct_stat stat
> # define __kstruct_foo foo
> # define __kstruct_bar bar
> #endif
> 
> #ifndef __kstruct_stat
> # error "Missing definition of __kstruct_stat, please insert:"
> # error "  #define __kstruct_stat <name-for-stat-struct>"
> # error "into your C file before '#include <linux/foo.h>'"
> #endif
> struct __kstruct_stat {
> }
> 
> Someone who wanted to keep the name __kstruct_stat could of course 
> "#define __kstruct_stat __kstruct_stat" easily.
> 

True, but if someone makes errors on that level in your libc, don't you 
think the fact that gcc will throw an error is sufficient?  Writing that 
kind of error generators is a lot of work, and probably for little gain.

	-hpa
