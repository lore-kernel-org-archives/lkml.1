Return-Path: <linux-kernel-owner+w=401wt.eu-S934140AbZGQG3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934140AbZGQG3m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 02:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934122AbZGQG3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 02:29:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:45468 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934116AbZGQG3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 02:29:41 -0400
Message-ID: <4A601AC5.1010308@kernel.org>
Date: Fri, 17 Jul 2009 15:31:33 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/4] drivers/block: adjust NULL test
References: <Pine.LNX.4.64.0907132243110.12374@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0907132243110.12374@ask.diku.dk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 17 Jul 2009 06:29:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> dtp is derefenced on the lines above the test !dtp, and so it cannot be
> NULL at this point.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://www.emn.fr/x-info/coccinelle/)
> 
> // <smpl>
> @r@
> expression x,E,E1;
> identifier f,l;
> position p1,p2;
> @@
> 
> *x@p1->f = E1;
> ... when != x = E
>     when != goto l;
> (
> *x@p2 == NULL
> |
> *x@p2 != NULL
> )
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Indeed, added to my temp block tree.  Will forward upstream in a few
days.

Thanks.

-- 
tejun
