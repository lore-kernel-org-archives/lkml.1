Return-Path: <linux-kernel-owner+w=401wt.eu-S1753568AbZHLP2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568AbZHLP2j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 11:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753531AbZHLP2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 11:28:38 -0400
Received: from www84.your-server.de ([213.133.104.84]:56268 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526AbZHLP2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 11:28:37 -0400
Subject: Re: [PATCH 0/7] new kfifo API
From: Stefani Seibold <stefani@seibold.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
In-Reply-To: <200908121658.16689.arnd@arndb.de>
References: <1250029873.17599.98.camel@wall-e>
	 <200908121658.16689.arnd@arndb.de>
Content-Type: text/plain
Date: Wed, 12 Aug 2009 17:28:22 +0200
Message-Id: <1250090902.21135.26.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 12.08.2009, 16:58 +0200 schrieb Arnd Bergmann:
> On Wednesday 12 August 2009, Stefani Seibold wrote:
> > This is a proposal of a new generic kernel FIFO implementation.
> 
> Hi Stefani,
> 

Hi Arnd,

Thanks for reviewing my code.

> The patches look mostly good content-wise, but you don't have
> separate changelog entries. The text of your introductory
> mail will be lost in git history when the patches get
> applied, so all the reaoning why a patch makes sense needs
> to get into the patch description.
> 

It was so late in the night... sorry i was tiered and i will do a more
accurate description the next time ;-)
 
> Similarly, the patch shortlog, i.e. the subject lines of
> your mails, should be the lines you mention below.
> 
> > The patch is splitted into 7 parts:
> >  Part 1: Code reorganization, no functional change
> 
> This one is not 'no functional change', because it
> actually changes the interface, so the description needs
> to be adapted.
> 
> Making the fifo itself a member of the data structure is
> a very good idea, which should be what the changeset
> comment describes (why that is done, not how of course).
> 
> The other change in here is that you add a 'spinlock_t *'
> argument to kfifo_alloc and kfifo_init. AFAICT this is
> unrelated, and it gets reverted by the next patch, so it
> would be more straightforward to leave that change out.
> 

That is the problem: If i do to much in one patch set it is bad... but
if i try to make smaller patch which are viable, than i need some
intermediate steps. So what is the right way???
  
> >  Part 2: Move out spinlock
> 
> I don't see this one as worthwhile, but I don't mind
> either. The contents look correct. 

Andrew like the idea too, because it gibe the user the freedom of choice
which locking he needs, in most case no locking is required.

> 
> >  Part 3: Cleanup namespace
> 
> Looks good, it's the obvious consequence of the patch before.
> 
> >  Part 4: rename kfifo_put... -> kfifo_in... and kfifo_get... -> kfifo_out...
> 
> That one is new, right?
> 
> It's probably better to have this, just to make sure everyone
> understands that the API is different now and no (out of tree)
> drivers or patches accidentally break.
> 

Yes, it new. It was your suggestion to make the new API miss use save. I
like the idea, but i am not very happy with the names. The old names was
much more logical.
 
> It only changes code that you already changed in patches 2 and 3
> though, so I'd recommend folding the respective changes into
> those patches.
> 
> >  Part 5: add DEFINE_KFIFO and friends, add very tiny functions
> >  Part 6: add kfifo_from_user and kfifo_to_user
> 
> These look good. The macros in patch 5 could use some kerneldoc
> comments so they show up in Documentation/Docbook/kernel-api.*.
> 

I will have a look on these....

> >  Part 7: add record handling functions (does some reorg)
> 
> This one adds a lot of extra complexity in unused code.
> I'll add my Acked-by to the first six patches if you do the
> minor modifications I mention above, but for the last one,
> I suggest you either add an actual user of that code, or find
> someone else to advocate its inclusion.
> 

Thats the reason why i made a separate patch for this. But i fixed a lot
of your objections since last time. Please have a look on it. It solves
much of the use case needed by the current users.

a.) It doesn't copy anything if the FIFO supply not enough data
b.) It doesn't copy anything if the target buffer has not enough space
c.) It returns the number of bytes which could not copied, or 0 if okay.
This makes error handling much easier.
d.) It gives device driver developer more flexibility to store variable
length data into the FIFO.
e.) It also gives a better support for fixed record size entries.

I still have an actual user for this... a lot of my device drivers
depend on it and some of them are also interesting for the community,
like my USB NRP-Sensor (Rohde&Schwarz) driver. 

I also can fix some of the current user to use the new API function. But
i have none of this hardware, so i am unable to test it :-( I can do it
for you as an examples how things will be simplified.

One of the main reasons for this patch was to get in the record support.
So i still hope that you and/or andrew give it a try. It does not really
blow the kernel, because the functionality is most inline.
 
> 	Arnd <><

Greetings,
Stefani


