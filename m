Return-Path: <linux-kernel-owner+w=401wt.eu-S1754283AbYIYLCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283AbYIYLCi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 07:02:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752827AbYIYLCa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 07:02:30 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:4823 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736AbYIYLC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 07:02:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=tCX2oB/6hUe+xk95QgEka0VK8IHusGsCrM/WhnoAqMdgn6xP5Xb63KUfiDZZyQJYM5
         29Zj1BUpWEURWBb+pG8n5z4vDsL6NF7rIlBzJaZjq+1bSe/Sjd8EmF+F1RX3J0LxP5xW
         KyvduJmceWJFJFFxBaPqRw1vSlu4kMJ/Mpy/Y=
Message-ID: <f7848160809250402l163bb177oeed30f2daa18fafd@mail.gmail.com>
Date: Thu, 25 Sep 2008 07:02:28 -0400
From: "Parag Warudkar" <parag.lkml@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: [patch 00/04] RFC: Staging tree (drivers/staging)
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Andreas Gruenbacher" <agruen@suse.de>,
       "Jeff Mahoney" <jeffm@suse.de>
In-Reply-To: <20080925042108.GA3931@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080924230054.GA27730@suse.de>
	 <f7848160809241639hbe716c9q76b0e1b83d853721@mail.gmail.com>
	 <20080925020608.GA13869@suse.de>
	 <f7848160809241959s3f3092b2nf05d2245a08bed03@mail.gmail.com>
	 <20080925042108.GA3931@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2008 at 12:21 AM, Greg KH <gregkh@suse.de> wrote:

>
> It is not different, except by name only.  Don't bike-shed :)

The whole concept is a bike shed - disproportionate importance to
labeling same things with different name.
So it should come as no surprise that we are discussing the need for
trivial duplications.


> It provides a fast way into the kernel for companies who do not stick
> around to take the time to merge things in.  That's what the -staging
> tree has been doing quite well for the past 6 months or so, with lots of
> drivers moving into mainline, and 15 drivers currently residing in it.

Again - sure move the staging directory to the mainline tree, group
all those drivers under CONFIG_HALFBAKED and default the whole
category to N.
Name those driver modules with a _stg prefix and be done with it. No
need for the insanely useless module loading crap because -
1) You will happily load from that directory automatically if device
is present - user wants it or not
2) You want users to test it and report bugs and still warn them and
taint their kernel so any problems can be ignored.
3) OOPS reports are generally specific enough to identify the
peripheral driver was a culprit or not - TAINTING does not achieve
anything significant apart from intimidation and completely redundant
classification.

>
> But I sure want to show such a marking, don't you?  It isn't costing
> anything, and if a developer doesn't want to debug the kernel if such a
> driver is loaded, this allows them to do this.  It was a requirement
> that came out of the discussion at the kernel summit.

I am not sure why _anyone_ would want to since it serves nothing.

I will ask it again -

If you do not want to use EXPERIMENTAL - fine. How about you remove
the TAINT crap and do this instead -

1) Give a staging directory for all such low quality crap
2) Give a KConfig group "Staging Drivers (Low Quality/High Risk)" and
if that is selected allow users to individually select the crappy
drivers they want to actually use - default all entries to N
3) Name all modules under staging  with a _stg suffix or something unique
4) By default do NOT load anything with a _stg suffix - deal with this
in insmod code, not the kernel
5) Require that -f be specified to load _stg modules - which will
auto-taint the kernel

That will allow you to do what you want without touching kernel code -
OOPS report, just look for _stg and decided whether or not to pursue
the report.

>> There's the clue - this _will_ happen with staging - I can almost see it.
>> So why not do it under one existing monster of an umbrella - or do you
>> have plans to make sure you are not going to add a new staging driver
>> unless the existing ones graduate to stable? Even if you do -  doable
>> under EXPERIMENTAL.
>
> No, it will not happen, the code is self-contained in a sub-directory,
> with an active maintainer, and lots of active helper developers (as have
> been sending me patches over the past weeks.)  If this does happen, and
> drivers/staging/ grows to be a large dumping ground with no movement out
> of it, then I'll worry about that then.  But I really don't think it
> will happen.

That is good to hear - we will see :)

Thanks!
Parag
