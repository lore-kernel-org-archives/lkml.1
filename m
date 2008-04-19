Return-Path: <linux-kernel-owner+w=401wt.eu-S1757865AbYDSJeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757865AbYDSJeg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 05:34:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753304AbYDSJe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 05:34:26 -0400
Received: from po-out-1718.google.com ([72.14.252.156]:55002 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291AbYDSJeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 05:34:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=n4k0uPZODet8mgQytaLnFQ3x9fzVVu+xv7GtnFQVN4rwHLiLWI+b0hj9++3WezaJLJs/3xADakqM4SYDAVGGCrHW4MEzWFcZPEzOs2nI8Gah1dg/x6Kvpg3iEOem+/LZ285IipRcCZkRrPyH+HbADIF80KeYVKkjr8cTWFRb4+w=
Message-ID: <19f34abd0804190234m190f7ec4ga2a652029a83bab6@mail.gmail.com>
Date: Sat, 19 Apr 2008 11:34:24 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH][trivial] mm/pagewalk.c break const constraint.
Cc: "Matt Mackall" <mpm@selenic.com>, LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <20080419181759.A8EB.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080419181759.A8EB.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 19, 2008 at 11:26 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> patch against 2.6.25
>
>  when compile 2.6.25, following warnings was outputed.
>
>   CC      mm/pagewalk.o
>  mm/pagewalk.c: In function 'walk_page_range':
>  mm/pagewalk.c:111: warning: passing argument 1 of 'pgd_offset' discards qualifiers from p\
>  ointer target type
>
>  mm argument of walk_page_range() is unnecessary const restriction.
>  this patch is no functional change. it's only remove warning.

Is this ia64 or cris? I think the correct way to resolve this is to
make pgd_offset() take a const struct mm_struct * instead.

Vegard


-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
