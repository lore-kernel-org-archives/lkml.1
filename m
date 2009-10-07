Return-Path: <linux-kernel-owner+w=401wt.eu-S934312AbZJGQgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934312AbZJGQgP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 12:36:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934240AbZJGQgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 12:36:14 -0400
Received: from mxout-08.mxes.net ([216.86.168.183]:12065 "EHLO
	mxout-08.mxes.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933757AbZJGQgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 12:36:14 -0400
Message-ID: <4ACCC347.4000404@tuffmail.co.uk>
Date: Wed, 07 Oct 2009 17:35:19 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: mingo@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] x86 dumpstack: fix printing of stack dump loglevels
References: <1254904787-11323-1-git-send-email-alan-jenkins@tuffmail.co.uk> <1254904787-11323-7-git-send-email-alan-jenkins@tuffmail.co.uk> <alpine.LFD.2.01.0910070731080.3432@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0910070731080.3432@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Wed, 7 Oct 2009, Alan Jenkins wrote:
>   
>> Changing printk() to accept loglevels in the middle of the string again
>> would be non-trivial.  Let's accept this limitation and simply split the
>> above code into two separate calls to printk().
>>     
>
> Actually, let's just drop the log_lvl printout in the middle.
>
> And to do that, let's clean up printk() a bit further - just make it say 
> "if there is no loglevel, use the previous loglevel". That's going to 
> simplify _all_ kinds of multi-line code.
>   

I think its more of a special case.  It's most useful where we output a
multi-line hexdump (or some other sort of array).  I think that's just
stack dumps (albeit potentially one for each architecture).  Is there
really anything else?  If not, I would lean against doing this.

None of the other architectures seem to set any loglevel in
dump_stack(), so this would change their behaviour.  I.e. dump_stack()
would print with the current loglevel, whatever that is.  That's a neat
behaviour and we could simplify x86 to match.  But it seems less simple
overall.  This one arch function would rely implicitly on the new, not
immediately obvious behaviour of printk().

> As far as I can tell, that's a oneliner: make 'current_log_level' be a 
> 'static' variable.
>
> Wouldn't that be much simpler for everybody?
>
> (And yes, if you mix multi-line messages that are printed as separate 
> printk's and with different loglevels, output will be confused. But quite 
> frankly, it will be confused regardless)
>   

It is more obvious that there is confusion when you see "<0>" in the
middle of a line though :-).

Regards
Alan
