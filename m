Return-Path: <linux-kernel-owner+w=401wt.eu-S1754065AbXJWQ5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065AbXJWQ5y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 12:57:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752750AbXJWQ5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 12:57:46 -0400
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:44463 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456AbXJWQ5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 12:57:45 -0400
Date: Tue, 23 Oct 2007 17:57:38 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Adrian Bunk <bunk@kernel.org>
cc: Ralf Baechle <ralf@linux-mips.org>, Franck Bui-Huu <vagabon.xyz@gmail.com>,
       linux-arch@vger.kernel.org, linux-mips@linux-mips.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Discardable strings for init and exit sections
In-Reply-To: <20071012181544.GC6476@stusta.de>
Message-ID: <Pine.LNX.4.64N.0710231753250.8693@blysk.ds.pg.gda.pl>
References: <Pine.LNX.4.64N.0710121711120.21684@blysk.ds.pg.gda.pl>
 <20071012171938.GB6476@stusta.de> <20071012175209.GA1110@linux-mips.org>
 <20071012181544.GC6476@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Oct 2007, Adrian Bunk wrote:

> - Most of the string annotations are (naturally) dev{init,exit}
>   annotations, and bugs there are therefore in configurations that have
>   only extremely low testing coverage during -rc.
> - I'm counting 22 annotations in the driver Maciej converted as an
>   example. When estimating the number of possible annotations based
>   on the number of C files in the kernel I'm getting a six digit
>   number.
> 
> No matter how hard it would be to teach gcc about it, when thinking of 
> the amount of __*init*/__*exit* bugs we already have I simply can't 
> imagine the string annotations as a maintainable solution.

 Well, it is up to the maintainer of code in question to get it right if 
interested.  Otherwise having no annotation and leaving the relevant 
strings resident in the memory throughout the lifespan of the system is a 
valid and perfectly working option.

 If you worry about the reverse case, where an annotation should be 
removed because the containing function is no longer __*init*/__*exit*, 
then I think `modpost' does a reasonably good job finding such places.

  Maciej
