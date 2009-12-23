Return-Path: <linux-kernel-owner+w=401wt.eu-S1756335AbZLWP1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335AbZLWP1X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 10:27:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756281AbZLWP1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 10:27:22 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:56005 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756258AbZLWP1W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 10:27:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CjSZFxmv0+FdRwp35HoW/ClUCp824txsGWr/q90B3WJMvfzy8hqPREHwAu4xw9lRWq
         R8q6ZJFl/XOLqPCZMcVly6hCdG908p5kE4GVk8yTPDbh2DdNJTEtU4m0oXDYgHdUu2Uu
         le4CCIE5nMIEGWV/qbFxZqtmXJllP/DMV+D74=
MIME-Version: 1.0
In-Reply-To: <43e72e890912181403k3a194326jbb8ca70a16cdcb74@mail.gmail.com>
References: <43e72e890912180926oad3b09fl6b7951864a836700@mail.gmail.com>
	 <20091219085640.c3414f51.sfr@canb.auug.org.au>
	 <43e72e890912181403k3a194326jbb8ca70a16cdcb74@mail.gmail.com>
Date: Wed, 23 Dec 2009 16:27:20 +0100
Message-ID: <1158166a0912230727h5ebbba81w5cb5d10648f791d3@mail.gmail.com>
Subject: Re: git pull on linux-next makes my system crawl to its knees and beg 
	for mercy
From: Denys Vlasenko <vda.linux@googlemail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       Bob Copeland <me@bobcopeland.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 18, 2009 at 11:03 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Fri, Dec 18, 2009 at 1:56 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> Hi Luis,
>>
>> On Fri, 18 Dec 2009 09:26:29 -0800 "Luis R. Rodriguez" <mcgrof@gmail.com> wrote:
>>>
>>> I tend to always be on a 2.6.32 kernel + John's queued up patches for
>>> wireless for the next kernel release (I use wireless-testing). My
>>> system is a Thinkpad T61, userspace is Ubuntu 9.10 based (ships with
>>> git 1.6.3.3) and I kept an ext3 filesystem to be able to go back in
>>> time to 2.6.27 at will without issues.  I git clone'd linux-next a few
>>> weeks ago. After a few days I then tried to git pull and my system
>>> became completely unusable, It took *ages* to open up a terminal and
>>
>> The start of the daily linux-next boilerplate says:
>>
>>> If you are tracking the linux-next tree using git, you should not use
>>> "git pull" to do so as that will try to merge the new linux-next release
>>> with the old one.  You should use "git fetch" as mentioned in the FAQ on
>>> the wiki (see below).
>>
>> (Unfortunately, the wiki seems to be unavailable at the moment)
>>
>> I am guessing that the merge that git is attempting is killing your
>> laptop (though besides the number of common commits I am not sure why).
>> Please try using "get fetch" instead.
>
> Indeed, I learned my lesson now. Thanks for the details.
>
> Now granted, even if 'git merge' is killing my laptop due to the
> conflicts of the insane merge I was trying to do it *still* should not
> make my box completely unresponsive for so long. And given that I'm
> using mostly distribution specific kernel config options and my have
> ruled out my hard drive it seems a general serious kernel issue even
> down to 2.6.27. Whatever git is doing I'm sure other userspace
> software can also end up generating and would make any user go
> completely bananas. I was about to rip my hair out.

Git gurus would know it by heart, but I am not one. So if I were you,
I would just do a generic diagnostic run. What is it git is doing
so that machine slows down that much? Is it spawning a lot
of running processes? Is it allocating/using so much memory
that your box goes into a severe swap storm?

I guess it is the latter. If it is, then it's not a kernel problem -
kernel can't magically make your system adequately handle a workload
which needs 3 GB for working set when the box only has 2 GB of RAM.
It _will_ be very slow.

--
vda
