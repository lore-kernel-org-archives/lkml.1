Return-Path: <linux-kernel-owner+w=401wt.eu-S1754903AbZIAPDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903AbZIAPDP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 11:03:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754589AbZIAPDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 11:03:14 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:37113 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559AbZIAPDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 11:03:13 -0400
MIME-Version: 1.0
In-Reply-To: <20090901104731.5f119d53@pedra.chehab.org>
References: <20090730200714.5a7ab8a6@pedra.chehab.org>
	 <20090801014053.7f53da83@pedra.chehab.org>
	 <303a8ee30908011103n3c12258icd2bfd1305b419d3@mail.gmail.com>
	 <20090811140128.211d4d11@caramujo.chehab.org>
	 <37219a840908111457o4b6abc64n52291f044b56782d@mail.gmail.com>
	 <37219a840908241332w2e2d45d8kd6406de3e60d1317@mail.gmail.com>
	 <303a8ee30908300553s6d81a2cdn43145de51298afd5@mail.gmail.com>
	 <20090830191325.45cf1e69@pedra.chehab.org>
	 <303a8ee30908310403x73d067rd58d01fbd4fde299@mail.gmail.com>
	 <20090901104731.5f119d53@pedra.chehab.org>
Date: Tue, 1 Sep 2009 11:03:14 -0400
Message-ID: <303a8ee30909010803r69f18fa0n8d40f164cf51607f@mail.gmail.com>
Subject: Re: [PULL] http://kernellabs.com/hg/~mkrufky/sms1xxx
From: Michael Krufky <mkrufky@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 1, 2009 at 9:47 AM, Mauro Carvalho
Chehab<mchehab@infradead.org> wrote:
> Em Mon, 31 Aug 2009 07:03:18 -0400
> Michael Krufky <mkrufky@kernellabs.com> escreveu:
>
>> I see the GPIO fix in your git tree now -- Thanks for merging it.
>>
>> However, I also see this changeset:
>>
>> http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-2.6.git;a=commitdiff;h=31e0ad693fb4e1d1be19dbe1c4f5a1ab9978e810
>>
>> I believe that it is way too late in 2.6.31 to merge a changeset like
>> this -- Please revert that and if there is actually a Kconfig change
>> required, merge a more minimal change for 2.6.31 and hold off this
>> huge, risky change for the next merge window.
>>
>> There is not enough time to fix this, if this changeset causes
>> additional breakage.
>
> This is just Kbuild changes, and it is there at linux-next for some time,
> where for sure people already tried to do several different building tests.
> Among some cosmetics, it removes a dead symbol (DVB_SIANO_SMS1XXX_SMS_IDS).
>
> It is very bad to expose to the user a config option that configs nothing.
>
> Anyway, Linus already merged the pull request. If you eventually find a bug on
> it, please ping me for us to send a fix.
>
> Cheers,
> Mauro
>

The Kconfig symbol names were changed, the target object has changed,
the module filename has changed.

A submenu was added, the USB support is not enabled by default.

None of the above fixed any bug, it just makes unnecessary changes
that are inappropriate this late in a kernel development cycle.

If a bug needed to be fixed, it would have been as simple as adding
the new object file for smssdio.o , and the old
DVB_SIANO_SMS1XXX_SMS_IDS section could have been removed without
changing everything.

I think this is ridiculous to slip in at the last moment, but I would
have had no complaints seeing this in the next merge window.

What is the point of a "merge window" if you let people make such
changes as this right before a kernel is released.

Maybe it all works, maybe it doesnt.  I know I personally am not going
to test this before September fifth, the day Linus plans to release
2.6.31. ..  And even if I do find a problem, how should I know that
the powers that be will act on a regression fix in a timely manner?

Apologies to the users of this driver -- I am not interested anymore.
My time is better spend working on my own code.

On the bright side, I have some really interesting stuff coming.  I
will be posting some RFC's this week that will help to alleviate some
long-standing problems within the media subsystems.  I won't stress
over Siano's driver any longer -- this gives me more time to focus on
the really cool fun stuff :-)

If the kernel's support for this driver becomes broken again, users
can just use the driver that I have posted on kernellabs.com

Cheers,

Mike
