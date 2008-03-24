Return-Path: <linux-kernel-owner+w=401wt.eu-S1759297AbYCXLu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759297AbYCXLu0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 07:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757844AbYCXLuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 07:50:14 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:65272 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757693AbYCXLuN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 07:50:13 -0400
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH,TRIVIAL] AF_UNIX, accept() and addrlen
References: <20080308022321.GC5853@implementation>
	<20080323.215641.192753003.davem@davemloft.net>
	<20080324104330.GF4434@implementation.uk.xensource.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 24 Mar 2008 12:50:10 +0100
In-Reply-To: <20080324104330.GF4434@implementation.uk.xensource.com>
Message-ID: <87abko734d.fsf@basil.nowhere.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 24 Mar 2008 11:43:33.0145 (UTC) FILETIME=[49BEC090:01C88DA4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Samuel Thibault <samuel.thibault@ens-lyon.org> writes:

> David Miller, le Sun 23 Mar 2008 21:56:41 -0700, a écrit :
> > From: Samuel Thibault <samuel.thibault@ens-lyon.org>
> > Date: Sat, 8 Mar 2008 02:23:21 +0000
> > 
> > > Accept and getpeername are supposed to return the amount of bytes
> > > written in the returned address.  However, on unnamed sockets, only
> > > sizeof(short) is returned, while a 0 is put in the sun_path member.
> > > This patch adds 1 for that additional byte.
> > > 
> > > Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
> > 
> > This change isn't correct.  It's the fact that the
> > length returned is sizeof(short) that tells the caller
> > that the unix socket is unnamed.
> 
> Mmm, where that is documented?
> 
> I can't find any details about that in SUS, and man 7 unix says
> 
> `If sun_path starts with a null byte ('' '), then it refers to the
> abstract namespace main- tained by the Unix protocol module.'

[I wrote unix(7) originally]. The abstract name space is a Linux
extension and there is no written standard and whatever the kernel
implements is the de-facto standard. If unix(7) differs in anything
from what the code does please send patches to the manpages
maintainer.

-Andi
