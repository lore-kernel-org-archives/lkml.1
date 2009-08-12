Return-Path: <linux-kernel-owner+w=401wt.eu-S1753349AbZHLO6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349AbZHLO6l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 10:58:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752811AbZHLO6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 10:58:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:58036 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbZHLO6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 10:58:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stefani Seibold <stefani@seibold.net>
Subject: Re: [PATCH 0/7] new kfifo API
Date: Wed, 12 Aug 2009 16:58:16 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-5-generic; KDE/4.3.0; x86_64; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
References: <1250029873.17599.98.camel@wall-e>
In-Reply-To: <1250029873.17599.98.camel@wall-e>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200908121658.16689.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/WURlnJeCY1phG66MX1GTeCPnKjel0azbPD0L
 1D+hd1y8iolq1aEWXSgY5pMGYPwD43jXrdWS2E1sFPbdaE5RhI
 GTVFK//64GPIVa0P1ilQQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 August 2009, Stefani Seibold wrote:
> This is a proposal of a new generic kernel FIFO implementation.

Hi Stefani,

The patches look mostly good content-wise, but you don't have
separate changelog entries. The text of your introductory
mail will be lost in git history when the patches get
applied, so all the reaoning why a patch makes sense needs
to get into the patch description.

Similarly, the patch shortlog, i.e. the subject lines of
your mails, should be the lines you mention below.

> The patch is splitted into 7 parts:
>  Part 1: Code reorganization, no functional change

This one is not 'no functional change', because it
actually changes the interface, so the description needs
to be adapted.

Making the fifo itself a member of the data structure is
a very good idea, which should be what the changeset
comment describes (why that is done, not how of course).

The other change in here is that you add a 'spinlock_t *'
argument to kfifo_alloc and kfifo_init. AFAICT this is
unrelated, and it gets reverted by the next patch, so it
would be more straightforward to leave that change out.

>  Part 2: Move out spinlock

I don't see this one as worthwhile, but I don't mind
either. The contents look correct.

>  Part 3: Cleanup namespace

Looks good, it's the obvious consequence of the patch before.

>  Part 4: rename kfifo_put... -> kfifo_in... and kfifo_get... -> kfifo_out...

That one is new, right?

It's probably better to have this, just to make sure everyone
understands that the API is different now and no (out of tree)
drivers or patches accidentally break.

It only changes code that you already changed in patches 2 and 3
though, so I'd recommend folding the respective changes into
those patches.

>  Part 5: add DEFINE_KFIFO and friends, add very tiny functions
>  Part 6: add kfifo_from_user and kfifo_to_user

These look good. The macros in patch 5 could use some kerneldoc
comments so they show up in Documentation/Docbook/kernel-api.*.

>  Part 7: add record handling functions (does some reorg)

This one adds a lot of extra complexity in unused code.
I'll add my Acked-by to the first six patches if you do the
minor modifications I mention above, but for the last one,
I suggest you either add an actual user of that code, or find
someone else to advocate its inclusion.

	Arnd <><
