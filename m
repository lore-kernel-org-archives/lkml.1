Return-Path: <linux-kernel-owner+w=401wt.eu-S1755363AbXFYPoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363AbXFYPoz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 11:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920AbXFYPos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 11:44:48 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:54499
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbXFYPor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 11:44:47 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: holzheu@linux.vnet.ibm.com
Subject: Re: Documentation of kernel messages (Summary)
Date: Mon, 25 Jun 2007 11:44:45 -0400
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       lf_kernel_messages@linux-foundation.org, mtk-manpages@gmx.net,
       jack@suse.cz, randy.dunlap@oracle.com, gregkh@suse.de, pavel@ucw.cz,
       kunai@linux-foundation.jp, tim.bird@am.sony.com, gh@us.ibm.com,
       arjan@infradead.org, sam@ravnborg.org, jengelh@computergmbh.de,
       hpa@zytor.com, joe@perches.com, auke-jan.h.kok@intel.com,
       hansendc@us.ibm.com, davem@davemloft.net, Valdis.Kletnieks@vt.edu,
       kenistoj@us.ibm.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
References: <1181747217.29512.9.camel@localhost.localdomain> <20070613111549.db1fa4d9.akpm@linux-foundation.org> <1182779321.7142.15.camel@localhost.localdomain>
In-Reply-To: <1182779321.7142.15.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706251144.48658.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 June 2007 09:48:41 Michael Holzheu wrote:
> Hi all,
>
> Any idea, how to proceed with this topic? Do you think that any of the
> suggested solutions for documentation / translation of kernel messages
> will have a chance to be included in the kernel?

Personally?  No to the second question, which renders the first "do it 
yourself outside of the tree".

Just a guess, and I don't speak for anyone else here, but I think most of us 
are waiting to see how long it takes you to lose interest.

> I tried to summarize the outcome of this discussion...
>
> There are two main issues:
>
> * Translate messages
> * Document messages

I'm somewhat sympathetic to translation (although I tend to think of it as a 
distro's job, and still wonder why IBM is pushing this directly rather than 
trying to bounce it off Red Hat or somebody).  But you could put a sed filter 
around dmesg to give you swahili output entirely in userspace.  Have you 
shown the simple approach to be insufficient yet?

Is "document messages" the same problem as "translate messages", or are these 
two different problems conflated together?

I find "document messages" to be a horrible idea conceptually, because I think 
the messages should _be_ documentation.  If the message is unclear it should 
be clarified.  "There's too much garbage on the floor, we should laminate it 
so we can't smell it anymore."  Er, no...

> Three possible solutions have been suggested:
>
> 1. Use message numbers maintained by driver owners
> 2. Automatically create hashes for printks
> 3. Use printk format string as message identifier

#2 has the advantage that you can do it without buy-in from the community, and 
without touching the code.  (Of course it doesn't necessarily help you if the 
printk string is "%s:%s".)

But I'm still convinced you could tackle over 90% of the problem from 
userspace, without touching the kernel.

> Pros and Cons of the different Message ID methods:
> ==================================================
> Message numbers maintained by driver owners:
> + Unique IDs
> + Can be kept stable between different kernel versions
> + Efficient way of matching printk to Documentation or translation
> - Difficult to maintain

Will at best only ever be done for some drivers, not all.  But that's probably 
inescapable no matter what your approach is.

> printk hashes:
> - Additional preprocessor step needed

Only for you guys.  Those of us building our own kernels and NOT translating 
them or producing "the big book of explanations of kernel messages for IBM 
customers who don't understand them" shouldn't have to run this preprocessor 
step.

> Pros and Cons of external documentation (vs. internal documentation):
> ====================================================================
> + Developers have less work to do
> + Kernel sources and patches have less lines of code, since message
>   descriptions are not contained in the kernel sources.
> + You can support multiple languages
>
> - Hard to keep printks and descriptions up-to-date. If using hashes,
>   each typo fix in a printk breaks the link to your documentation.
> - Since the developer knows the meaning of a printk best, he probably
>   would be the right person to write the description.

Imposing additional requirements on developers isn't going to work unless you 
reject patches from developers who don't follow your procedures and submit 
the appropriately filled-out forms with each patch for processing by the 
central bureaucracy.

Signed-off-by works because A) Linus enforces it, B) The overhead's very low, 
C) attribution is already highly good thing within our community values, D) 
it annoys SCO.

The javadoc function comments in the source don't have complete coverage and 
probably never will (although they're getting better).  The premise of doing 
something similar for messages is that a translating dmesg in userspace can't 
necessarily get complete coverage, so you need a solution modeled on 
something that doesn't have complete covereage years after its 
introduction...

> - For every Distribution or vanilla kernel you probably need separate
>   external message databases.

"If you're resigned to doing that anyway you don't actually need him to lie 
there all the time, do you?" - Ford Prefect

If you need an external message database what's wrong with doing it entirely 
in userspace via a sed-based translating dmesg?

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
