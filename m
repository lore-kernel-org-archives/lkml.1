Return-Path: <linux-kernel-owner+w=401wt.eu-S1755410AbZLWQVO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410AbZLWQVO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 11:21:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752682AbZLWQVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 11:21:13 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:63106 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbZLWQVL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 11:21:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Hqk6C0cYlC+N21CeWkYXJ1dW/ZClnDrKz7rGgHbe3qQuixoLTvRvuQ4zH7fr8eNf0I
         4xgYrgSuYpCDiwirAqx9p75hUFafZcJX7mHrlYBa09awmPt7/cy+vK22KsNTK2B4c+RD
         rIt5byTg4hYuJc0LWB85CgP8tBVee5OVIAG9A=
MIME-Version: 1.0
In-Reply-To: <1158166a0912230727h5ebbba81w5cb5d10648f791d3@mail.gmail.com>
References: <43e72e890912180926oad3b09fl6b7951864a836700@mail.gmail.com> 
	<20091219085640.c3414f51.sfr@canb.auug.org.au> <43e72e890912181403k3a194326jbb8ca70a16cdcb74@mail.gmail.com> 
	<1158166a0912230727h5ebbba81w5cb5d10648f791d3@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 23 Dec 2009 08:20:51 -0800
Message-ID: <43e72e890912230820j5e00b8cbq9ea9009cdcf25a0f@mail.gmail.com>
Subject: Re: git pull on linux-next makes my system crawl to its knees and beg 
	for mercy
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       Bob Copeland <me@bobcopeland.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 23, 2009 at 7:27 AM, Denys Vlasenko
<vda.linux@googlemail.com> wrote:
> On Fri, Dec 18, 2009 at 11:03 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> On Fri, Dec 18, 2009 at 1:56 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>> Hi Luis,
>>>
>>> On Fri, 18 Dec 2009 09:26:29 -0800 "Luis R. Rodriguez" <mcgrof@gmail.com> wrote:
>>>>
>>>> I tend to always be on a 2.6.32 kernel + John's queued up patches for
>>>> wireless for the next kernel release (I use wireless-testing). My
>>>> system is a Thinkpad T61, userspace is Ubuntu 9.10 based (ships with
>>>> git 1.6.3.3) and I kept an ext3 filesystem to be able to go back in
>>>> time to 2.6.27 at will without issues.  I git clone'd linux-next a few
>>>> weeks ago. After a few days I then tried to git pull and my system
>>>> became completely unusable, It took *ages* to open up a terminal and
>>>
>>> The start of the daily linux-next boilerplate says:
>>>
>>>> If you are tracking the linux-next tree using git, you should not use
>>>> "git pull" to do so as that will try to merge the new linux-next release
>>>> with the old one.  You should use "git fetch" as mentioned in the FAQ on
>>>> the wiki (see below).
>>>
>>> (Unfortunately, the wiki seems to be unavailable at the moment)
>>>
>>> I am guessing that the merge that git is attempting is killing your
>>> laptop (though besides the number of common commits I am not sure why).
>>> Please try using "get fetch" instead.
>>
>> Indeed, I learned my lesson now. Thanks for the details.
>>
>> Now granted, even if 'git merge' is killing my laptop due to the
>> conflicts of the insane merge I was trying to do it *still* should not
>> make my box completely unresponsive for so long. And given that I'm
>> using mostly distribution specific kernel config options and my have
>> ruled out my hard drive it seems a general serious kernel issue even
>> down to 2.6.27. Whatever git is doing I'm sure other userspace
>> software can also end up generating and would make any user go
>> completely bananas. I was about to rip my hair out.
>
> Git gurus would know it by heart, but I am not one. So if I were you,
> I would just do a generic diagnostic run.

Right its the first thing I did, but its to the extent that even doing
that is not possible unless you're willing to wait 5-10 minutes for
some output. I'm not kidding.

> What is it git is doing
> so that machine slows down that much? Is it spawning a lot
> of running processes?

Doesn't seem like it, the only visible git process is get-merge, I
forgot to grep for all git processes though, but I think that was the
only one.

> Is it allocating/using so much memory
> that your box goes into a severe swap storm?

Could be, 979M virtual, 298M resident size (non swapped), 58665 shared.

Unfortunately when this happens I cannot log into my box and run good
diagnostics, that's how much of a pain in the bolas this is. Some
morning I had enough patience I did leave vmstat and iostat running
and didn't see much out of the ordinary except CPU wait time was
pretty high. I did manage to get at least htop running once and took a
screenshot (and this took me about 10 minutes to generate):

http://bombadil.infradead.org/~mcgrof/images/2009/12/git-merge.jpg

So if anything it could be the later, that of a swap storm.

What I should have running is sar, that way I can treck back in time
when I want to.

But even when compiling the kernel my machine becomes unusable for a
few seconds when the linking for vmlinux.o starts and in that case my
swap usage is about 45 - 125 M. A silly example, pandora reliably poos
out on firefox requiring a pkill on firefox to get it back while
vmlinux.o is linking.

> I guess it is the latter.

Only it seems to happen with some other things like compiling the kernel.

I'll see if I can upgrade the memory on this thing.

> If it is, then it's not a kernel problem -
> kernel can't magically make your system adequately handle a workload
> which needs 3 GB for working set when the box only has 2 GB of RAM.
> It _will_ be very slow.

Sure, I'll try to keep my eye out on swap overuse, I suppose it could be that.

I started to be suspicious about the CPU freq governor but I'll note
on both systems even if I set the freq static to the highest I still
had issues. I'll also note on both 2.6.27 and 2.6.32 I used:

CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y

I started testing CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE=y

but don't really notice an improvement.

  Luis
