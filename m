Return-Path: <linux-kernel-owner+w=401wt.eu-S933612AbZJGOjL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933612AbZJGOjL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 10:39:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932508AbZJGOjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 10:39:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60605 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932368AbZJGOjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 10:39:10 -0400
Date: Wed, 7 Oct 2009 07:36:30 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
cc: mingo@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] x86 dumpstack: fix printing of stack dump
 loglevels
In-Reply-To: <1254904787-11323-7-git-send-email-alan-jenkins@tuffmail.co.uk>
Message-ID: <alpine.LFD.2.01.0910070731080.3432@localhost.localdomain>
References: <1254904787-11323-1-git-send-email-alan-jenkins@tuffmail.co.uk> <1254904787-11323-7-git-send-email-alan-jenkins@tuffmail.co.uk>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Oct 2009, Alan Jenkins wrote:
> 
> Changing printk() to accept loglevels in the middle of the string again
> would be non-trivial.  Let's accept this limitation and simply split the
> above code into two separate calls to printk().

Actually, let's just drop the log_lvl printout in the middle.

And to do that, let's clean up printk() a bit further - just make it say 
"if there is no loglevel, use the previous loglevel". That's going to 
simplify _all_ kinds of multi-line code.

As far as I can tell, that's a oneliner: make 'current_log_level' be a 
'static' variable.

Wouldn't that be much simpler for everybody?

(And yes, if you mix multi-line messages that are printed as separate 
printk's and with different loglevels, output will be confused. But quite 
frankly, it will be confused regardless)

				Linus
