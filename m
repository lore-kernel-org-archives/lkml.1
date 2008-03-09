Return-Path: <linux-kernel-owner+w=401wt.eu-S1752846AbYCIKLN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846AbYCIKLN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 06:11:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbYCIKLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 06:11:03 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57467 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751269AbYCIKLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 06:11:01 -0400
Date: Sun, 9 Mar 2008 09:58:02 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Dave Young" <hidave.darkstar@gmail.com>
Cc: "Johannes Weiner" <hannes@saeurebad.de>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] add time_now_after and other macros which compare
 with jiffies
Message-ID: <20080309095802.70d91c7b@core>
In-Reply-To: <a8e1da0803081654l50fdda44jbbed1d1ed2caf9ae@mail.gmail.com>
References: <200803080735.06984.hidave.darkstar@gmail.com>
	<877igd6vqn.fsf@saeurebad.de>
	<a8e1da0803081654l50fdda44jbbed1d1ed2caf9ae@mail.gmail.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  > +/* time_now_before_eq(a) return true if now (jiffies) is before or equal to a */
> >  > +#define time_now_before_eq(a) time_before_eq(jiffies, a)
> >
> >  How about even more obvious names like time_is_past(), time_is_future(),
> >  ...?
> 
> Thanks for comment.
> 
> Then how do we name the _eq version?  IMHO, the time_now_* is enough.

Why do you even need them. I don't see the point of *any* of these extra
macros as they simply obfuscate code and hide what is actually going on.
The initial macros were added because of the type safety and correct
comparison rules being complex. They have a purpose.

Even if you want these you can use !time_future() if you don't want the
_eq variants. Generally speaking drivers should be using timers not
polled loops, and most of our loops comparing with jiffies want removing.

Alan
