Return-Path: <linux-kernel-owner+w=401wt.eu-S1757308AbZFNL7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308AbZFNL7A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 07:59:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756064AbZFNL6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 07:58:52 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:18125 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755987AbZFNL6v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 07:58:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=RCzt9lJttIihePFUr69z3Pj7Cw+Ns8uH4dNgvCyTgi5nXy2Q4S2wEVbbR/r5XSYfZV
         B19E2gqrbuw5p6RGjYFP69tjpl4KVskS9g6F1gkK5nqGtB2/m7/GRScMxcRNCxSUASV1
         WqdlW+w5/HXs0JRBW4SzW2115UX8ZtFruyMBw=
MIME-Version: 1.0
In-Reply-To: <20090614114935.GA7489@localhost>
References: <1244872920-13511-1-git-send-email-vapier@gentoo.org> 
	<Pine.LNX.4.64.0906131456090.5069@sister.anvils> <20090614100110.GA19875@localhost> 
	<20090614104212.GA5977@localhost> <8bd0f97a0906140346t6b19f00aq29cfd4c554682f07@mail.gmail.com> 
	<20090614111440.GC6046@localhost> <8bd0f97a0906140426g5c9ad183qa258be91c17c929d@mail.gmail.com> 
	<20090614114935.GA7489@localhost>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sun, 14 Jun 2009 07:58:29 -0400
Message-ID: <8bd0f97a0906140458s25bdaca9jc5ba2db76da913d7@mail.gmail.com>
Subject: Re: [PATCH] ramfs: ignore tmpfs options when we emulate it
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 14, 2009 at 07:49, Wu Fengguang wrote:
> On Sun, Jun 14, 2009 at 07:26:37PM +0800, Mike Frysinger wrote:
>> On Sun, Jun 14, 2009 at 07:14, Wu Fengguang wrote:
>> > On Sun, Jun 14, 2009 at 06:46:24PM +0800, Mike Frysinger wrote:
>> >> On Sun, Jun 14, 2009 at 06:42, Wu Fengguang wrote:
>> >> > On Sun, Jun 14, 2009 at 06:01:10PM +0800, Wu Fengguang wrote:
>> >> > Sorry I take back the previous patch. It makes sense to not break
>> >> > existing user space tools, but a warning message looks OK to remind
>> >> > people of possibly unexpected behavior.
>> >> >
>> >> >                default:
>> >> >                        printk(KERN_ERR "ramfs: bad mount option: %s\n", p);
>> >> > -                       return -EINVAL;
>> >> > +                       break;
>> >>
>> >> hmm, if the warning was wrapped in #ifdef CONFIG_SHMEM, i'd be ok with
>> >> this.  otherwise we end up with warnings that can (should) be ignored
>> >> when tmpfs is being emulated with ramfs.
>> >
>> > We may change the "ramfs:" accordingly. But *silently* ignoring
>> > options is bad anyway?
>>
>> i really hate nitpicking such minor shit, but reality is that output
>> displayed in the kernel log that is incorrect is going to cause me
>> grief via customer support, updating documentation, adding FAQs,
>> etc... and i doubt i'm the only one here.
>
> I don't think the message is "incorrect" - it is reminding user the fact.

when talking about ramfs, the message is correct -- the option is
wrong.  when talking about tmpfs emulated by ramfs, that may be a
matter of opinion.  i can understand why you still prefer a warning,
but there is a significant body of people out there (myself including)
that views warnings generally as something that should be addressed.
ignoring that, people who see warnings and dont understand what's
going on will ask/complain/whatever to someone somewhere.  including
an explanatory message along side the warning will make that number go
down, but it wont go away, and it sucks to have to do that.  ive seen
people ask questions where they copy & paste error messages that
already included explanatory text in it telling them how to
fix/resolve/research the issue.  i'm sure you have too :).

>> my requirement is simple: valid tmpfs options should be silently
>> consumed (i.e. ignored) when tmpfs is being emulated by ramfs (i.e.
>> CONFIG_SHMEM=n).
>>
>> so how about:
>> default:
>>     if (!strcmp(sb->s_id, "ramfs"))
>>         printk(KERN_WARNING "%s: ignoring mount option: %s\n", sb->s_id, p);
>>     break;
>
> This is going overly complex, maybe we just revert to Hugh's original
> patch for *complete* compatibility?

if my basic requirement is met, i dont care much about the details
beyond that :).
-mike
