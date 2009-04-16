Return-Path: <linux-kernel-owner+w=401wt.eu-S1757419AbZDPSdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419AbZDPSdk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 14:33:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756220AbZDPSda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 14:33:30 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33324 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438AbZDPSda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 14:33:30 -0400
Date: Thu, 16 Apr 2009 19:33:27 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block/genhd.c: fix sparse warning
Message-ID: <20090416183327.GC26366@ZenIV.linux.org.uk>
References: <BD79186B4FD85F4B8E60E381CAEE1909015F8DFA@mi8nycmail19.Mi8.com> <19f34abd0904152146l3db9961bt3b52f224abc8d960@mail.gmail.com> <BD79186B4FD85F4B8E60E381CAEE1909015F8F6D@mi8nycmail19.Mi8.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE1909015F8F6D@mi8nycmail19.Mi8.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 16, 2009 at 02:03:39PM -0400, H Hartley Sweeten wrote:

> Maybe something like:
> 
> 	#define container_of(ptr, type, member) ({			\
> 		const typeof( ((type *)0)->member ) *__m_##ptr = (ptr);	\
> 		(type *)( (char *)__m_##ptr - offsetof(type,member) );})
> 
> I don't know if that actually works. ;-)

_Think_ of it.  Will do bleeding wonders if you say
	container_of(f(), struct foo, bar)
won't it?

No, the real solution for that is this:
#define container_of(ptr, type, member) (type *)	\
	((char *)(1 ? (ptr) : ((const typeof(((type *)0)->member) *)(ptr))) \
         - offsetof(type, member))
Same amount of typechecking, no local variables, no ({ }) uses.
