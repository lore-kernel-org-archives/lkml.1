Return-Path: <linux-kernel-owner+w=401wt.eu-S1759908AbYDVA1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759908AbYDVA1O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 20:27:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758958AbYDVA05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 20:26:57 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58692 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758953AbYDVA04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 20:26:56 -0400
Date: Tue, 22 Apr 2008 01:26:52 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Sparc
Message-ID: <20080422002652.GU27459@ZenIV.linux.org.uk>
References: <alpine.LFD.1.10.0804211608570.2779@woody.linux-foundation.org> <20080421231815.GS27459@ZenIV.linux.org.uk> <20080421232534.GT27459@ZenIV.linux.org.uk> <20080421.171619.126408955.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080421.171619.126408955.davem@davemloft.net>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2008 at 05:16:19PM -0700, David Miller wrote:

> The only platforms defining a non-NOP __emul_prefix() after this
> sparc changeset are:
> 
> 1) IA-64 for PER_LINUX32 --> /emul/ia32-linux/
> 2) MIPS for riscos and IRIX compat support
> 3) ARM for ARM_BSD_EMUL --> "usr/gnemul/bsd", yikes no leading slash
>    in that path!
> 
> I bet if we really tried we could get rid of these things.

By killing altroot-related code in fs/namei.c, which is what I'm going to
do _anyway_.  If somebody really needs a working replacement, I would
very much suggest starting with figuring out the desired semantics; frankly,
I suspect that having native wrapper for their ld.so might be much better
idea as far as the location of libraries is concerned, with chroot and
bindings doing the rest.
