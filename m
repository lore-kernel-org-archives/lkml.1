Return-Path: <linux-kernel-owner+w=401wt.eu-S1754830AbZIAR7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbZIAR7i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 13:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750985AbZIAR7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 13:59:37 -0400
Received: from mail-iw0-f204.google.com ([209.85.223.204]:51111 "EHLO
	mail-iw0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbZIAR7h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 13:59:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type:content-transfer-encoding;
        b=o4LwskWkKeSOmmcieBthll2h1BdVGO4SKQAi+YsBHpceT2Wm90bNLkmeSxhcGhSc/u
         stWxnUWMfys/EyPyD1ZSAhdYguFueGB1CjSW2cqjJZMrnGhY3E+euxAwhmyepwUOveIj
         LLrKyU9PSQOvdw1IfHzybg69TAL5+CeX2rPlM=
MIME-Version: 1.0
In-Reply-To: <20090830182424.GB20822@mit.edu>
References: <43e72e890908272225w79ec5bf6kc7ef1160e5a088ae@mail.gmail.com> 
	<tnxtyzr7vcl.fsf@pc1117.cambridge.arm.com> <20090830163417.GA15183@skywalker.linux.vnet.ibm.com> 
	<20090830171749.GA8642@mit.edu> <43e72e890908301029t71a9c1a2t3d17e99cf3112ad2@mail.gmail.com> 
	<20090830182424.GB20822@mit.edu>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 1 Sep 2009 10:59:19 -0700
Message-ID: <43e72e890909011059x166d4ac4s7998cc3ce64a9c99@mail.gmail.com>
Subject: Re: memleaks, acpi + ext4 + tty
To: Theodore Tso <tytso@mit.edu>, "Luis R. Rodriguez" <mcgrof@gmail.com>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 30, 2009 at 11:24 AM, Theodore Tso<tytso@mit.edu> wrote:
> On Sun, Aug 30, 2009 at 10:29:01AM -0700, Luis R. Rodriguez wrote:
>> > Yes, as soon as the next merge window opens.  The leak only shows up
>> > when you mount and unmount a filesystem, which under normal
>> > circumstances doesn't happen a huge number of times on most systems.
>> > By the time it showed up it was late enough in the 2.6.31-rcX series
>> > that I figured it was better to wait until the next merge window.  I
>> > didn't consider it a high priority bug.
>>
>> That's odd I run into this kmemleak with a single bootup, no manual remounts.
>>
>
> Yeah, but it's a singleton leak.  Let me be a bit more precise this
> time: the leak happens at mount time because we're essentially doing
> this due to some code that was accidentally duplicated when it was
> being refactored:
>
>        a = kmalloc(sizeof(...)*N, GFP_ATOMIC);
>          ...
>        a = kmalloc(sizeof(...)*N, GFP_ATOMIC);
>
> So a small amount of memory is leaked each time a filesystem is
> mounted.  It doesn't become a huge problem unless you are repeatedly
> mounting and unmounting the same filesystem in a tight loop.

Thanks for the explanation -- this still does seem like something
which could affect some users, say of, embedded systems which do need
to remount, so while it may be a priority for an average user it seems
high priority for embedded system users using ext4 and remounting a
lot.

Either way, I guess what I'm getting at is it seems rather odd to me
we would not consider fixing some memory leaks on an rc release when
we already have a fix prepared. I understand the merge window is
closing in but we're not there yet -- and in worst case, can't we at
least consider this fix after rc1?

kmeleak reports seem rather useful, I'd hate to see more users told
their memory leak issues won't be fixed until a later kernel release.
That just seems... shitty.

  Luis
