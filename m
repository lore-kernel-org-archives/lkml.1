Return-Path: <linux-kernel-owner+w=401wt.eu-S932985AbZLRVNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932985AbZLRVNh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 16:13:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932648AbZLRVNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 16:13:36 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:41174 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932636AbZLRVNf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 16:13:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=l0HjGmoie9S2aQPIeZpL1Pt9lrv1GPAji7F352F3u5u+ja8WJkj5dQ5ZtenCuW5ePR
         kLIT4yLst+6X1V1f4E/bU5KQ/sgUpHgO3zgLjWP9LTGn4oMMRj2/12F2XxXjEkVs1HvY
         g8yVBT/hB9br8LqxmG2Eu7/MOsm5p3iJYWI5U=
MIME-Version: 1.0
In-Reply-To: <43e72e890912181251q7ef1fb59n42da94c86e5c33c1@mail.gmail.com>
References: <43e72e890912180926oad3b09fl6b7951864a836700@mail.gmail.com> 
	<200912181838.20204.bzolnier@gmail.com> <43e72e890912181119t53e01ec2y5dc8687d23f7a668@mail.gmail.com> 
	<43e72e890912181155h444956a3tf228ddd8d281a9d3@mail.gmail.com> 
	<43e72e890912181251q7ef1fb59n42da94c86e5c33c1@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 18 Dec 2009 13:13:13 -0800
Message-ID: <43e72e890912181313t124292ey7ac93c6278da7be7@mail.gmail.com>
Subject: Re: git pull on linux-next makes my system crawl to its knees and beg 
	for mercy
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       Bob Copeland <me@bobcopeland.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 18, 2009 at 12:51 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Fri, Dec 18, 2009 at 11:55 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> On Fri, Dec 18, 2009 at 11:19 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>>> On Fri, Dec 18, 2009 at 9:38 AM, Bartlomiej Zolnierkiewicz
>>> <bzolnier@gmail.com> wrote:
>>>> On Friday 18 December 2009 06:26:29 pm Luis R. Rodriguez wrote:
>>>>
>>>>> on my kernel logs. Bewildered with this issue I set out to prove to
>>>>> myself this issue was not a 2.6.32 issue and booted other kernels,
>>>>> including Ubuntu's distro kernel on 2.6.31 and then later my own built
>>>>> fresh 2.6.27.41 kernel. The issue was reproducible on all three
>>>>> kernels!
>>>>>
>>>>> This lead me to believe this was a system / hard drive issue and
>>>>> embraced myself for a system fix. I yet needed to prove this was
>>>>
>>>> Just some hints for ruling out the system / hard drive problem.
>>>>
>>>> smartctl -a /dev/sdx is your friend for checking your disk (keep an eye
>>>> on anything suspicious like re-allocated sector count going up etc.)
>>>
>>> Sweet thanks, here's my current output, I'll try later after I get
>>> some day work done to pull linux-next and make it moan. Let me know if
>>> you see anything fishy.
>>
>> <-- snip full log -->
>>
>>> Also available at:
>>>
>>> http://bombadil.infradead.org/~mcgrof/logs/2009/12/smart-ctl-sda2.txt
>>>
>>>> It could be also fs related issue that shows up only under specific
>>>> conditions
>>>
>>> OK -- I see, I used a fresh new ext3, did not make the jump to ext4.
>>>
>>>> (i.e. almost full partition -- some file-systems starts to
>>>> crawl when the amount of available free space gets low).
>>>
>>> Got it, thanks, so partition has a lot of room.
>>>
>>> mcgrof@tux ~ $ df -h
>>> Filesystem            Size  Used Avail Use% Mounted on
>>> /dev/sda2              91G   43G   44G  50% /
>>>
>>> Also ony have one partition.
>>
>> GSmartControl is very cool, just ran the short self test and it passed
>> without issues. I'll now run the extended self tests. I'll not that
>> right after the self test I had to checkout the 2.6.32.y branch on
>> hpa's tree and noticed similar type of slow down as I did with pulling
>> linux-next. Only thing with linux-next is it takes ages complete which
>> just makes waiting unbearable. This all makes me suspect its something
>> else. But lets seee what these results on the GSmartControl yield.
>
> I tested the same exact git pull on the other T61 laptop I have and
> was able to see the same crippling effects but not as bad as with my
> main T61. Different between them is the one where I see the worst
> issue has a Intel(R) Core(TM)2 Duo CPU     T8100  @ 1.80GHz while the
> other one has the same CPU but at 2.10GHz. The only thing I see
> different between linux-next and say wireless-testing is linux-next
> will have a lot more newer objects and the pull will end with a git
> merge that will fail and require you to 'git reset --hard origin'. The
> later part shouldn't be taken into the equation there though as I see
> the issue creeping up early on during the pull, while git is counting
> objects and even later compressing.
>
> I'm starting to glare at CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
> with suspicious looks. On both boxes the CPU kept itself @ 800 MHz
> during most of the git pull, I did see the CPU idle hitting 0
> frequently and the CPU wait time ~ 20 or 30.
>
> My GSmartControl extensive test is almost done.

The test completed without any errors.

> I'll test 2.6.33-rc1 once John gets it into his tree.

Now to wait for this guy.

  Luis
