Return-Path: <linux-kernel-owner+w=401wt.eu-S933597AbYD3WT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933597AbYD3WT5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 18:19:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756948AbYD3WTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 18:19:49 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:49163 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761611AbYD3WTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 18:19:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=uuVTk4yhPQhWFh6hiahxyggEMaBfc7dJ3qrfMbaG2bToE0GJ9SGlxqyg5CIjbFnSf0DG8nhEG/MdpKT2le8iaIIJrnTtcUK3Yko46ApiWhvjv5L047h3xll7gxvtztqtmgtmW44c3AGL97YK6HN3xEwHWtMbYLjAz3I8F9DeH3I=
Subject: Re: [PATCH 07/10] net: fix returning void-valued expression
	warnings
From: Harvey Harrison <harvey.harrison@gmail.com>
To: David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: akpm@linux-foundation.org, jeff@garzik.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080430.150832.107441339.davem@davemloft.net>
References: <1209593023.24729.117.camel@brick>
	 <20080430.150832.107441339.davem@davemloft.net>
Content-Type: text/plain
Date: Wed, 30 Apr 2008 15:20:05 -0700
Message-Id: <1209594005.24729.127.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-30 at 15:08 -0700, David Miller wrote:
> From: Harvey Harrison <harvey.harrison@gmail.com>
> Date: Wed, 30 Apr 2008 15:03:43 -0700
> 
> > drivers/net/8390.c:37:2: warning: returning void-valued expression
> > drivers/net/bnx2.c:1635:3: warning: returning void-valued expression
> > drivers/net/xen-netfront.c:1806:2: warning: returning void-valued expression
> > net/ipv4/tcp_hybla.c:105:3: warning: returning void-valued expression
> > net/ipv4/tcp_vegas.c:171:3: warning: returning void-valued expression
> > net/ipv4/tcp_veno.c:123:3: warning: returning void-valued expression
> > net/sysctl_net.c:85:2: warning: returning void-valued expression
> > 
> > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> 
> I wish this weren't marked with a warning, what spits this out,
> sparse?

Yes, sparse warning.

> 
> I know the kernel is written in C and not C++, but even Stroustrup
> mentions this case explicitly in his book:
> 
> 	 A void function cannot return a value.  However, a call of a
> 	 void function doesn't yield a value, so a void function can
> 	 use a call of a void function as the expression in a return
> 	 statement.
> 
> And I see no reason why there's anything wrong with this construct.

Well, in an X86_32 allyesconfig, this only trips 32 times...so it's not
exactly common.  I agree that there is nothing _wrong_ with this, I'll
just add Linus and see if we can just call it codingstyle ;)

This is just a _trivial_ way to make the sparse output easier for people
to use day-to-day for the kernel. There's lots more to do, but this set
removes all remaining integer as NUll/ returning void-value/ single bit
signed bitfield warnings.

Cheers,

Harvey

