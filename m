Return-Path: <linux-kernel-owner+w=401wt.eu-S1759254AbXEJVy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759254AbXEJVy6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 17:54:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759304AbXEJVyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 17:54:51 -0400
Received: from mail.tmr.com ([64.65.253.246]:33093 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758697AbXEJVyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 17:54:50 -0400
Message-ID: <4643947C.10105@tmr.com>
Date: Thu, 10 May 2007 17:54:04 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] "volatile considered harmful" document
References: <25493.1178744744@lwn.net>
In-Reply-To: <25493.1178744744@lwn.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Corbet wrote:

> +There are still a few rare situations where volatile makes sense in the
> +kernel:
> +
> +  - The above-mentioned accessor functions might use volatile on
> +    architectures where direct I/O memory access does work.  Essentially,
> +    each accessor call becomes a little critical section on its own and
> +    ensures that the access happens as expected by the programmer.
> +
> +  - Inline assembly code which changes memory, but which has no other
> +    visible side effects, risks being deleted by GCC.  Adding the volatile
> +    keyword to asm statements will prevent this removal.
> +
> +  - The jiffies variable is special in that it can have a different value
> +    every time it is referenced, but it can be read without any special
> +    locking.  So jiffies can be volatile, but the addition of other
> +    variables of this type is frowned upon.  Jiffies is considered to be a
> +    "stupid legacy" issue in this regard.

It would seem that any variable which is (a) subject to change by other 
threads or hardware, and (b) the value of which is going to be used 
without writing the variable, would be a valid use for volatile.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
